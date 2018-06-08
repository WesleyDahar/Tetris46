;------------------------------
; Main
;
; Handles game functionality.
;
; Parameters:
;	R0 - Seed (0 for random)
;	C Flag - 0 : Soft Reset (Keep Highscore), 1 : Hard Reset (Clear Highscore)
; Returns:
;------------------------------
; R0 - (local)
; R1 - (local)
; R2 - (local)
; R3 - LED blink rate
; R4 - Address of 'blockData'
; R5 - Address of 'counter'
; R6 - Ticks per drop
; R7 - Spaces dropped
Main
	PUSH	{R0}
	BL  	Reset
	MOVS	R0,#0
	MOVS	R3,#30
	LDR 	R4,=blockData
	LDR 	R5,=counter
	MOVS	R6,#100
	LDR 	R2,=TxQRecord
Main_Delay
	LDRB	R7,[R2,#NUM_ENQD]
	CMP 	R7,#0
	BHI 	Main_Delay
	MOVS	R2,#0
	STR 	R2,[R5,#0]
	MOVS	R0,#1
	LDR 	R1,=timer
	STRB	R0,[R1,#0]
Main_Start
	LDR 	R1,[R5,#0]
	CMP 	R1,R3
	BLO 	Main_Start_Skip
	ADDS	R7,R7,R1
	LDR 	R1,=seed
	STR 	R7,[R1,#0]
	MOVS	R1,#0
	STR 	R1,[R5,#0]
	LDR 	R0,=FGPIOD_BASE
	LDR 	R1,=LED_GREEN_MASK
	CMP 	R2,#0
	BNE 	Main_Start_Toggle_Off
	STR 	R1,[R0,#GPIO_PCOR_OFFSET]
	MOVS	R2,#1
	B   	Main_Start_Skip
Main_Start_Toggle_Off
	STR 	R1,[R0,#GPIO_PSOR_OFFSET]
	MOVS	R2,#0
Main_Start_Skip
	BL  	CheckChar
	CMP 	R0,#' '
	BEQ 	Main_Start_0
	CMP 	R0,#'0'
	BLO 	Main_Start
	CMP 	R0,#'9'
	BHI 	Main_Start	
	SUBS	R0,R0,#48
	MOVS	R1,R0
	LSLS	R0,R0,#3
	SUBS	R6,R6,R0
	LDR 	R0,=level
	LSLS	R1,R1,#8
	ADDS	R1,R1,#2
	STR 	R1,[R0,#8]
	BL  	DrawText
Main_Start_0
	POP 	{R0}
	CMP 	R0,#0
	BNE 	Main_Set_Seed
	LDR 	R0,[R5,#0]
	ADDS	R0,R0,R7
Main_Set_Seed
	LDR 	R1,=seed
	STR 	R0,[R1,#0]
	STR 	R0,[R1,#4]
	MOVS	R7,#0
	BL  	GetNext
	BL  	PutNext
	MOVS	R0,#0
	STR 	R0,[R5,#0]
	LDR 	R0,=FGPIOD_BASE
	LDR 	R1,=LED_GREEN_MASK
	STR 	R1,[R0,#GPIO_PCOR_OFFSET]
Main_Loop
	BL  	CheckChar
	BCC 	Main_CheckInput_Down
	LDR 	R0,[R5,#0]
	CMP 	R0,R6
	BLO 	Main_Loop
	MOVS	R0,#24
	MOVS	R1,#0
	MOVS	R7,#0
	STR 	R1,[R5,#0]
	BL  	Update
	BCS 	Main_Placed
	B   	Main_Loop
Main_CheckInput_Down
	CMP 	R0,#'B'
	BNE 	Main_CheckInput_Left
	MOVS	R0,#24
	MOVS	R1,#0
	STR 	R1,[R5,#0]
	BL  	Update
	BCS		Main_Placed
	ADDS	R7,R7,#1
	B   	Main_Loop
Main_CheckInput_Left
	CMP 	R0,#'D'
	BNE 	Main_CheckInput_Right
	MOVS	R0,#2
	RSBS	R0,R0,#0
	MOVS	R1,#0
	BL  	Update
	B   	Main_Loop
Main_CheckInput_Right
	CMP 	R0,#'C'
	BNE 	Main_CheckInput_Z
	MOVS	R0,#2
	MOVS	R1,#0
	BL  	Update
	B   	Main_Loop
Main_CheckInput_Z
	CMP 	R0,#'z'
	BNE 	Main_CheckInput_X
	MOVS	R0,#0
	MOVS	R1,#12
	BL  	Update
	B   	Main_Loop
Main_CheckInput_X
	CMP 	R0,#'x'
	BNE 	Main_CheckInput_Space
	MOVS	R0,#0
	MOVS	R1,#4
	BL  	Update
	B   	Main_Loop
Main_CheckInput_Space
	CMP 	R0,#' '
	BNE 	Main_Loop
	LDR 	R1,[R5,#0]
	PUSH	{R1}
	MOVS	R2,#0
	STR 	R2,[R5,#0]
Main_Pause
	LDR 	R1,[R5,#0]
	CMP 	R1,R3
	BLO 	Main_Pause_Skip
	MOVS	R1,#0
	STR 	R1,[R5,#0]
	LDR 	R0,=FGPIOD_BASE
	LDR 	R1,=LED_GREEN_MASK
	CMP 	R2,#0
	BNE 	Main_Toggle_Off
	STR 	R1,[R0,#GPIO_PCOR_OFFSET]
	MOVS	R2,#1
	B   	Main_Pause_Skip
Main_Toggle_Off
	STR 	R1,[R0,#GPIO_PSOR_OFFSET]
	MOVS	R2,#0
Main_Pause_Skip
	MOVS	R0,#0
	BL  	CheckChar
	CMP 	R0,#' '
	BNE 	Main_Pause
	POP 	{R0}
	STR 	R0,[R5,#0]
	LDR 	R1,=timer
	MOVS	R0,#1
	STRB	R0,[R1,#0]
	LDR 	R0,=FGPIOD_BASE
	LDR 	R1,=LED_GREEN_MASK
	STR 	R1,[R0,#GPIO_PCOR_OFFSET]
	B   	Main_Loop
Main_Placed
	MOVS	R1,#0
	BL  	Place
	BL  	PutNext
	BCS 	Main_GameOver
	LDR 	R0,=TxQRecord
Main_Placed_Delay
	LDRB	R7,[R0,#NUM_ENQD]
	CMP 	R7,#0
	BHI 	Main_Placed_Delay
	STR 	R7,[R5,#0]
	B   	Main_Loop
Main_GameOver
	LDR 	R0,=FGPIOD_BASE
	LDR 	R1,=LED_GREEN_MASK
	STR 	R1,[R0,#GPIO_PSOR_OFFSET]
	LDR 	R0,=FGPIOE_BASE
	LDR 	R1,=LED_RED_MASK
	STR 	R1,[R0,#GPIO_PCOR_OFFSET]
	LDR 	R0,=GAMEOVER
	BL  	PutStringSB
Main_GameOver_Loop
	BL  	GetChar
	CMP 	R0,#' '
	BNE 	Main_GameOver_Loop
	LDR 	R0,=FGPIOE_BASE
	LDR 	R1,=LED_RED_MASK
	STR 	R1,[R0,#GPIO_PSOR_OFFSET]
	MOVS	R0,#0
	LSRS	R0,R0,#1
	B   	Main
Main_Exit
	END
