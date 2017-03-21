.section .text

/*
This subroutine moves Mario's position in the game map

Parameters:
        r0 - which button is pressed (which direction to move)

*/

//-------------------------------------------------------------------------------------
readMario:
        push    {r4, r5, r6, r7, lr}
        mov     r6, #0                  //x coordinate of Mario
        mov     r7, #7                  //y coordinate of Mario
        ldr     r4, =GameMap
        add     r4, #175                //The upper most possible location for Mario (25*7=175) - coordinates (0, 7)

continueReadMario:
        ldrb    r5, [r4]
        cmp     r5, #3                  //check the cell contains Mario
        beq     returnMario
        add     r4, #1
        add     r6, #1                  //r6 contains the x coordinate of Mario
        cmp     r6, #25
        blt     continueReadMario
        add     r7, #1                  //increment y coordinate
        mov     r6, #0                  //reset x coordinate
        bl      continueReadMario

returnMario:
        mov     r0, r4                  //address of Mario
        mov     r1, r6                  //return x coordinate of Mario
        mov     r2, r7                  //return y coordinate of Mario
        pop     {r4, r5, r6, r7, lr}
        mov     pc,  lr

//-------------------------------------------------------------------------------------


.globl moveRight
moveRight:
        push    {r3-r10, lr}

        bl      readMario

         //update the gamestate
        mov     r3, #0
        mov     r4, #3
        mov     r5, r0                               //address of Mario
        strb    r3, [r0], #1
        strb    r4, [r0]

        mov     r6, r1                               //store current Mario XPos in r6
        mov     r7, r2                               //store current Mario YPos in r7

        mov     r0, r6
        mov     r1, r7
        mov     r2, #0                               //restore background sky

        bl      drawCell

        mov     r2, #3                               //#3 stands for Mario
        add     r0, r6, #1                           //XPos
        mov     r1, r7                               //YPos

        bl      drawCell

        pop     {r3-r10,lr}
        mov     pc, lr

.globl moveLeft
moveLeft:
        push    {r3-r7, lr}

        bl      readMario

         //update the gamestate
        mov     r3, #0
        mov     r4, #3
        mov     r5, r0                               //address of Mario
        strb    r3, [r0], #-1
        strb    r4, [r0]

        mov     r6, r1
        mov     r7, r2

        mov     r0, r6
        mov     r1, r7
        mov     r2, #0                               //restore background sky

        bl      drawCell

        mov     r2, #3                               //#3 stands for Mario
        sub     r6, r6, #1
        mov     r0, r6                               //XPos
        mov     r1, r7                               //YPos

        bl      drawCell
        pop     {r3-r7,lr}
        mov     pc, lr

.globl jump
jump:
        push    {r3-r7, lr}


        bl      readMario

        //update the gamestate
        mov     r3, #0
        mov     r4, #3
        mov     r5, r0                               //address of Mario
        strb    r3, [r0], #-100
        strb    r4, [r0]

        mov     r6, r1
        mov     r7, r2
        mov     r3, #0
jumploop:
        mov     r2, #0                               //restore background sky
        mov     r0, r6
        mov     r1, r7

        bl      drawCell
        ldr     r3, =0x1388
        bl      Wait				//wait for a second

        mov     r2, #3                               //#3 stands for Mario
        mov     r0, r6                                //XPos
        sub     r1, r7, #1                            //YPos
        mov     r7, r1
        bl      drawCell
        ldr     r3, =0x1388
        bl      Wait				//wait for a second
        add     r3, #1
        cmp     r3, #3
        ble     jumploop


        pop     {r3-r7,lr}
        mov     pc, lr

fall:
        push    {r3-r7, lr}

        bl      readMario
