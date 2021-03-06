// Interaction with the main menu and pause menu (FSM)

.section .text

.globl mainMenu
mainMenu:
        push   {r2-r9, lr}
        bl      DrawMainMenuScreen   //print the main menu
        bl      DrawMenuMushroom     //print selection indictor (a mushroom)

        mov     r8, #0               //initialize state to 0 (start selected)

readMainMenuLoop:                       //FSM: state 0(start) and 1(quit)
        bl      readMainMenuButtons

        cmp     r0 ,#1              //up button pressed
        beq     MainUpPressed

        cmp     r0 ,#2              //down button pressed
        beq     MainDownPressed

        cmp     r0 ,#3
        beq     MainAPressed       //A button pressed
        b       readMainMenuLoop

.globl MainUpPressed
MainUpPressed:
        cmp     r8, #0          //if is state 0
        beq     readMainMenuLoop    //keep reading buttons (do nothing)

        bl      DrawMenuMushroom //if is state 1, switch to and draw state 0
        mov     r8, #0

        b       readMainMenuLoop      //keep reading menu buttons
.globl MainDownPressed
MainDownPressed:
        cmp     r8,#1            //if is state 1
        beq     readMainMenuLoop     //keep reading buttons (do nothing)
        mov     r8, #1
        bl      DrawMenuMushroom2 //if is state 0, switch to and draw state 1


        b       readMainMenuLoop
.globl MainAPressed
MainAPressed:
        cmp     r8, #0           //if state 0 (start) is selected
        beq     StartGame      //start game
        cmp     r8, #1           //if state 1 (quit) is selected
        beq     exitGame         //exit game

ExitMainMenu:
        pop    {r2-r9, lr}
        mov     pc,lr
//------------------------------------------------------------------------------------
/* This function turns off the pause flag. */
.globl TurnPauseFlagOff
TurnPauseFlagOff:

        push {r1,r2,lr}

        ldr     r2, =PauseFlag
        mov     r1, #0
        strb    r1, [r2]             // set pause menu flag to 0

        pop     {r1,r2,lr}
        mov     pc, lr

//------------------------------------------------------------------------------------
/* This function deals with the interaction with the pause menu. */
.globl pauseMenu
pauseMenu:
        push    {r1, r2, r5, lr}
        mov     r5,     #1      // initialize r5 to resume mode

        ldr     r2, =PauseFlag
        mov     r1, #1
        strb    r1, [r2]        // set pause menu flag to 1

PauseBreak:
        bl      DrawPauseMenu   // draw the pause menu
        bl      DrawMenuStar1   // draw the selector (star) at the first option

PauseLabel:
        b       readPauseButtons        // read buttons pressed by the player

.globl  PauseStPressed
PauseStPressed:
        bleq    TurnPauseFlagOff        // if start button was pressed, turn off pause flag
        beq     resumeGame              // continue the game 

.globl PauseDnPressed
PauseDnPressed:                         // if down button wass pressed
        cmp     r5,     #1              // if in state 1 (option 1), move down to state 2 (option 2)
        moveq   r5,     #2      
        beq     DrawMenuStar2           

        cmp     r5,     #2              // if in state 2, move down to state 3
        moveq   r5,     #3
        beq     DrawMenuStar3

        b       PauseNext               // continue

.globl PauseUpPressed
PauseUpPressed:                         // if up button was pressed
        cmp  r5, #2                     // if in state two
        moveq   r5,     #1              //  move up to state 1
        beq     DrawMenuStar1

        cmp     r5,     #3              // if in state 3
        moveq   r5,     #2              // move up to state 2
        beq     DrawMenuStar2
        b       PauseNext

.globl PauseAPressed
PauseAPressed:
        cmp     r5,     #1      //resume selected -> resume game

        bleq     TurnPauseFlagOff // turn pause flag off

        beq     resumeGame
        cmp     r5,     #2      //restart selected > restart game
        beq     main
        cmp     r5,     #3      //quit selected -> end Game
        beq     mainMenu

PauseNext:
        ldr     r1, =0xfffff     // wait a second
        bl      Wait
        b       PauseLabel
PauseDone:
        pop     {r1, r2, r5, lr}
        mov     pc, lr
