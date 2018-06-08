;------------------------------
; Subroutines
;------------------------------

;------------------------------
; Update
;
; Modifies the position and orientation
;	of the block. Calls 'DrawBlock'. 
;
; Parameters:
;	R0 - Position offset amount
;	R1 - Orientation offset amount
;	R4 - Address of 'blockData'
; Returns:
;	C Flag - 0 : Okay, 1 : Block overlap
;------------------------------
Update PROC {R0-R14},{}			; 
	PUSH	{LR,R0-R3,R5-R7}	; 
	LDRH	R2,[R4,#2]			; Load block position index
	ADDS	R0,R0,R2			; Add position offest to position index
	LDRB	R2,[R4,#0]			; Load block type
	LSLS	R2,R2,#4			; 
	LDR 	R5,=BLOCK			; Load block definition table
	ADDS	R5,R5,R2			; Add block type offset to base address
	LDRB	R2,[R4,#1]			; Load block orientation
	ADDS	R1,R1,R2			; Add orientation offset to definition address
	CMP 	R1,#16				; 
	BLO 	Update_Skip			; Branch if orientation equals 16 (full cycle)
	SUBS	R1,R1,#16			; Subtract 16 from orientation
Update_Skip						; 
	ADDS	R5,R5,R1			; Add block orientation to base address (R5 is now the address of the new block definition)
	MOVS	R2,#0				; Initialize cell counter to 0
	LDR 	R3,=board			; Load board address
Update_Check					; 
	LDRSB	R6,[R5,R2]			; Load cell position offset from new block definition
	ADDS	R6,R6,R0			; Add new block position index to cell position offset
	LDRB	R6,[R3,R6]			; Load cell type at new cell position
	ADDS	R2,R2,#1			; Increment cell counter
	CMP 	R6,#'@'				; 
	BEQ 	Update_Failed		; Branch if cell type is placed
	CMP 	R2,#4				; 
	BLO 	Update_Check		; Branch if cell counter is lower than 4
	LDR 	R6,[R4,#0]			; Load block data
	STR 	R6,[R4,#4]			; Store block data in last data
	STRB	R1,[R4,#1]			; Store new orientation in block data
	STRH	R0,[R4,#2]			; Store new position in block data
	LDRH	R1,[R4,#6]			; Load last position
	LDRB	R2,[R4,#0]			; Load block type
	LSLS	R2,R2,#4			; 
	LDR 	R6,=BLOCK			; Load block definition table
	ADDS	R6,R6,R2			; Add block type offset to base address
	LDRB	R2,[R4,#5]			; Load last orientation
	ADDS	R6,R6,R2			; Add orientation offset to definition address (R6 is now the address of the last block definition)
	MOVS	R2,#0				; Initialize cell counter to 0
	LDR 	R7,=0x2020			; Load empty cell type
Update_Clear_Loop				; 
	LDRSB	R0,[R6,R2]			; Load cell position offset from last block definition
	ADDS	R0,R0,R1			; Add last block position index to cell position offset
	STRH	R7,[R3,R0]			; Store empty type at last cell position
	ADDS	R2,R2,#1			; Increment cell counter
	CMP 	R2,#4				; 
	BLO 	Update_Clear_Loop	; Branch if cell counter is lower than 4
	LDRB	R7,[R4,#0]			; Load block type
	LSLS	R7,R7,#8			; Shift type by 1 byte
	ADDS	R7,R7,#'('			; Add '(' to block type (signifies unplaced type)
	LDRH	R0,[R4,#2]			; Load new block position offset
Update_Place_Loop				; 
	SUBS	R2,R2,#1			; Decrement cell counter
	LDRSB	R1,[R5,R2]			; Load cell position offset from new block definition
	ADDS	R1,R1,R0			; Add new block position index to cell position offset
	STRH	R7,[R3,R1]			; Store unplaced type at new cell position
	CMP 	R2,#0				; 
	BHI 	Update_Place_Loop	; Loop if counter is higher than 0
	BL  	DrawBlock			; Show changes in the terminal
	B   	Update_Exit			; 
Update_Failed					; 
	MOVS	R2,#1				; Set R2 to 1
Update_Exit						; 
	LSRS	R2,R2,#1			; Set C flag to R2
	POP 	{R5-R7,R0-R3,PC}	; 
	ENDP						; 


	ALIGN
	LTORG


;------------------------------
; Place
;
; Handles the placement of blocks,
;	clearing of lines, and adjustment
;	of the score.
;
; Parameters:
;	R4 - Address of 'blockData'
;	R6 - Ticks per drop
;	R7 - Spaces dropped
; Modifies:
;	R6 - Ticks per drop
; Returns:
;------------------------------
Place PROC {R0-R5,R7-R14},{}					; 
	PUSH	{LR,R0-R3,R5}						; 
	PUSH	{R6-R7}								; 
	LDRB	R2,[R4,#0]							; Load block type
	CMP 	R2,#6
	LSLS	R2,R2,#4							; 
	LDR 	R5,=BLOCK							; Load block definition table
	ADDS	R5,R5,R2							; Add block type offset to base address
	LDRB	R1,[R4,#1]							; Load block orientation
	ADDS	R5,R5,R1							; Add block orientation to definition address
	LDRH	R0,[R4,#2]							; Load block position index
	MOVS	R2,#0								; Initialize cell counter
	LDR 	R3,=board							; Load board address
	MOVS	R6,#'@'								; Load placed type
Place_Loop										; 
	LDRSB	R1,[R5,R2]							; Load cell position offset from block definition
	ADDS	R1,R1,R0							; Add block position index to cell position offset
	STRB	R6,[R3,R1]							; Store placed type at cell position
	ADDS	R2,R2,#1							; Increment cell counter
	CMP 	R2,#4								; 
	BLO 	Place_Loop							; Branch if cell counter is lower than 4
	MOVS	R7,R0								; 
	LDR 	R0,=sequenceBuffer					; Load sequenceBuffer
	MOVS	R6,#0								; Initialize character counter
	LDR 	R1,=0x335B1B						; Load character sequence: "\0x1b[3"
	STR 	R1,[R0,R6]							; Append: "\0x1b[3"
	ADDS	R6,R6,#3							; Increment character counter
	LDRB	R1,[R4,#0]							; 
	LDR 	R3,=COLOR							; Load color table
	LDRB	R1,[R3,R1]							; Load color of block type
	STRB	R1,[R0,R6]							; Append: block color
	ADDS	R6,R6,#1							; Increment character counter
	MOVS	R1,#'m'								; 
	STRB	R1,[R0,R6]							; Append: 'm'
	ADDS	R6,R6,#1							; Increment character counter
	MOVS	R2,#0								; Initialize cell counter
	MOVS	R3,#0								; Set previous cell index to 0
Place_Build_Loop								; 
	LDRSB	R1,[R5,R2]							; Load cell position offset from block definition
	ADDS	R2,R2,#1							; Increment cell counter
	ADDS	R1,R1,R7							; Add block position index to cell position offset
	CMP 	R1,#72								; 
	BLO 	Place_Build_Skip					; Skip if cell position is outside visible range
	SUBS	R3,R1,R3							; Cell index difference equals current index - last index
	CMP 	R3,#2								; 
	BEQ 	Place_Build_Append					; Append imediately if this cell is adjacent to previous cell
	PUSH	{R1-R5}								; 	(Otherwise, insert cursor relocation ascii sequence)
	SUBS	R1,R1,#72							; Convert cell position index to visible position index
	MOVS	R4,#23								; Load base column number
	MOVS	R5,#5								; Load base row number
Place_Build_Divide								; Convert hexadecimal index (R1) to 
	CMP 	R1,#24								; 	decimal column offset (R1)
	BLO 	Place_Build_Divide_Exit				; 	and absolute decimal row number (R5)
	SUBS	R1,R1,#24							; 
	ADDS	R5,R5,#1							; 
	B   	Place_Build_Divide					; 
Place_Build_Divide_Exit							; 
	ADDS	R4,R4,R1							; Add base column number to column offset
	MOVS	R1,#'\x1b'							; 
	STRB	R1,[R0,R6]							; Append: '\x1b'
	ADDS	R6,R6,#1							; Increment character counter
	MOVS	R1,#'['								; 
	STRB	R1,[R0,R6]							; Append: '['
	ADDS	R6,R6,#1							; Increment character counter
	MOVS	R2,#48								; 
	MOVS	R3,R5								; 
Place_Build_MoveY								; Convert decimal column number (R3) to decimal ascii sequence (R2,R3)
	CMP 	R3,#10								; 
	BLO 	Place_Build_MoveY_Exit				; 
	ADDS	R2,R2,#1							; 
	SUBS	R3,R3,#10							; 
	BHI 	Place_Build_MoveY					; 
Place_Build_MoveY_Exit							; 
	STRB	R2,[R0,R6]							; Append: first ascii number
	ADDS	R6,R6,#1							; Increment character counter
	ADDS	R3,R3,#48							; Convert decimal to ascii
	STRB	R3,[R0,R6]							; Append: second ascii number
	ADDS	R6,R6,#1							; Increment character counter
	MOVS	R1,#';'								; 
	STRB	R1,[R0,R6]							; Append: ';'
	ADDS	R6,R6,#1							; Increment character counter
	MOVS	R2,#48								; 
	MOVS	R3,R4								; 
Place_Build_MoveX								; Convert decimal row number (R3) to decimal ascii sequence (R2,R3)
	CMP 	R3,#10								; 
	BLO 	Place_Build_MoveX_Exit				; 
	ADDS	R2,R2,#1							; 
	SUBS	R3,R3,#10							; 
	BHI 	Place_Build_MoveX					; 
Place_Build_MoveX_Exit							; 
	STRB	R2,[R0,R6]							; Append: first ascii number
	ADDS	R6,R6,#1							; Increment character counter
	ADDS	R3,R3,#48							; Convert decimal to ascii
	STRB	R3,[R0,R6]							; Append: second ascii number
	ADDS	R6,R6,#1							; Increment character counter
	MOVS	R1,#'H'								; 
	STRB	R1,[R0,R6]							; Append: 'H'
	ADDS	R6,R6,#1							; Increment character counter
	POP 	{R1-R5}								; 
Place_Build_Append								; 
	MOVS	R3,R1								; Move cell position index to previous index
	MOVS	R1,#'['								; 
	STRB	R1,[R0,R6]							; Append '['
	ADDS	R6,R6,#1							; Increment character counter
	MOVS	R1,#']'								; 
	STRB	R1,[R0,R6]							; Append ']'
	ADDS	R6,R6,#1							; Increment character counter
Place_Build_Skip								; 
	CMP 	R2,#4								; 
	BLO 	Place_Build_Loop					; Branch if cell counter is lower than 4
	MOVS	R1,#'\0'							; 
	STRB	R1,[R0,R6]							; Append null character
	BL  	PutStringSB							; Draw placed block in the terminal
	LDR 	R0,=CURSOR_SET						; 
	BL  	PutStringSB							; Position the cursor one line below the bottom left of the board
	LDR 	R0,=lineBuffer						; Load lineBuffer
	MOVS	R2,#0								; Initialize clearBuffer counter
	LDR 	R3,=0x2020							; Load empty cell type
	LDR 	R4,=seed							; Load seed address
	SUBS	R4,R4,#22							; R4 is now the address of the end of the last row on the board
	MOVS	R5,#0								; Initialize cleared line counter
Place_Clear_Loop								; 
	SUBS	R4,R4,#24							; Set R4 to the address of the beginning of the previous row
	MOVS	R6,#0								; Initialize cell counter
	MOVS	R7,#0								; Initialize placed cell counter
Place_Clear_CheckLine							; 
	LDRH	R1,[R4,R6]							; 
	CMP 	R1,R3								; 
	BEQ 	Place_Clear_Check_Space				; 
	ADDS	R7,R7,#1							; Increment placed cell counter
Place_Clear_Check_Space							; 
	STRH	R1,[R0,R6]							; Append cell to lineBuffer
	ADDS	R6,R6,#2							; Increment cell counter by 2
	CMP 	R6,#20								; 
	BLO 	Place_Clear_CheckLine				; Loop if line is still being read
	CMP 	R7,#0								; 
	BEQ 	Place_Clear_Loop_Finish				; Finish dropping lines if line is empty
	CMP 	R7,#10								; 
	BEQ 	Place_Clear_Loop_Full				; Skip storing if line is full
	PUSH	{R0}								; 
	LDR 	R0,=board							; Load board address
	ADDS	R0,#74								; R5 marks the first visible line (no rows should be drawn above this line)
	CMP 	R4,R0								; 
	BLO 	Place_Skip_MoveUp					; 
	LDR 	R0,=CURSOR_UP						; 
	BL  	PutStringSB							; Move cursor up one line
Place_Skip_MoveUp								; 
	POP 	{R0}								; 
	CMP 	R5,#0								; 
	BEQ 	Place_Clear_Loop					; Don't drop lines if cleared line counter is 0
	PUSH	{R5}								; Preserve cleared line counter
Place_Clear_Load_Pre_Adjust						; 
	CMP 	R5,#0								; 
	BEQ 	Place_Clear_Load_Pre_Adjust_Exit	; 
	ADDS	R4,R4,#24							; For each cleared line move pointer R4 to the next line
	SUBS	R5,R5,#1							; 
	B   	Place_Clear_Load_Pre_Adjust			; 
Place_Clear_Load_Pre_Adjust_Exit				; 
	POP 	{R5}								; Retrieve cleared line counter
	LDR 	R7,=clearBuffer						; Load clearBuffer (Reverse ordered list of board contents from first cleared line to first empty line)
Place_Clear_Load								; 
	SUBS	R6,R6,#2							; Decrement cell counter by 2
	LDRH	R1,[R0,R6]							; Load cell in lineBuffer
	STRH	R1,[R4,R6]							; Store cell in the board at line R4
	STRH	R1,[R7,R2]							; Store cell in clearBuffer
	ADDS	R2,R2,#2							; Increment clearBuffer counter
	CMP 	R6,#0								; 
	BHI 	Place_Clear_Load					; Loop if cell counter is higher than 0
	PUSH	{R5}								; Preserve cleared line counter
Place_Clear_Load_Post_Adjust					; 
	CMP 	R5,#0								; 
	BEQ 	Place_Clear_Load_Post_Adjust_Exit	; 
	SUBS	R4,R4,#24							; For each cleared line move pointer R4 to the previous line
	SUBS	R5,R5,#1							; 
	B   	Place_Clear_Load_Post_Adjust		; 
Place_Clear_Load_Post_Adjust_Exit				; 
	POP 	{R5}								; Retrieve cleared line counter
	B   	Place_Clear_Loop					; 
Place_Clear_Loop_Full							; 
	PUSH	{R0}								; 
	LDR 	R0,=CLEAR_LINE						; 
	BL  	PutStringSB							; Clear row in terminal
	LDR 	R0,=CURSOR_UP						; 
	BL  	PutStringSB							; Move cursor up one line
	POP 	{R0}								; 
	ADDS	R5,R5,#1							; Increment cleared line counter
	B   	Place_Clear_Loop					; 
Place_Clear_Loop_Finish							; 
	PUSH	{R5}								; Preserve cleared line counter
	CMP 	R5,#0								; 
	BEQ 	Place_Clear_Exit					; Exit if no lines were cleared
	MOVS	R3,R5								; Move cleared line counter to R3
	LDR 	R5,=board							; Load board address
	ADDS	R5,#50								; R5 marks the line above first visible line
	ADDS	R4,R4,#24							; Move R4 to the next line
	CMP 	R4,R5								; 
	BHS 	Place_Clear_SkipHighest				; Overwrite top line if top line is the 2 lines above the first visible line
	CMP 	R3,#1								; 
	BNE 	Place_Clear_SkipHighest				; Overwrite top line if only 1 line was cleared
	SUBS	R2,R2,#20							; Move clearBuffer counter back 10 cells to overwrite top line
Place_Clear_SkipHighest							; 
	LDR 	R1,=0x2020							; Load empty cell type
	ADDS	R5,#24								; R5 marks the first visible line (no rows should be dropped above this line in the terminal)
	LDR 	R7,=clearBuffer						; Load clearBuffer
Place_Clear_Loop_Finish_Loop					; (Append empty lines to clearBuffer to overwrite the topmost lines of cells for each cleared line)
	SUBS	R6,R6,#2							; Decrement cell counter by 2
	STRH	R1,[R4,R6]							; Store cell in the board at line R4
	CMP 	R4,R5								; 
	BLO 	Place_Clear_Skip_Store				; Store empty cell if line is visible
	STRH	R1,[R7,R2]							; Store cell in clearBuffer
	ADDS	R2,R2,#2							; Increment clearBuffer counter
Place_Clear_Skip_Store							; 
	CMP 	R6,#0								; 
	BHI 	Place_Clear_Loop_Finish_Loop		; Loop if cell counter is higher than 0
	ADDS	R4,R4,#24							; Move R4 to the next line
	SUBS	R3,R3,#1							; Decrement cleared line counter
	CMP 	R3,#0								; 
	BEQ 	Place_Clear_Exit					; Leave loop if cleared line counter is 0
	MOVS	R6,#20								; Reset cell counter to 20
	B   	Place_Clear_Loop_Finish_Loop		; 
Place_Clear_Exit								; 
	POP 	{R5}								; 	
	CMP 	R5,#0								; 
	BEQ 	Place_Line_Skip						; Skip line clearing in the terminal if no lines were cleared
	LDR 	R4,=counter							; Load counter address
	STR 	R3,[R4,#0]							; Store a 0 in counter
Place_Clear_Delay								; 
	LDR 	R3,[R4,#0]							; Load counter
	CMP 	R3,#80								; 
	BLO 	Place_Clear_Delay					; (Loop for .8 seconds)
	LDR 	R0,=sequenceBuffer					; Load sequenceBuffer
	LDR 	R3,=clearBuffer						; Load clearBuffer
	MOVS	R4,#0								; Initialize previous cell color to 0
	MOVS	R7,#0								; Initialize character counter to 0
Place_Line_Loop									; 
	MOVS	R1,#'\x1b'							; (Generates an ascii character sequence which moves the cursor down 1 line)
	STRB	R1,[R0,R7]							; Append: '\x1b'
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'['								; 
	STRB	R1,[R0,R7]							; Append: '['
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'B'								; 
	STRB	R1,[R0,R7]							; Append: 'B'
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R6,#0								; Initialize cell counter
Place_Cell_Loop									; 
	SUBS	R2,R2,#1							; 
	LDRB	R1,[R3,R2]							; 
	SUBS	R2,R2,#1							; Decrement clearBuffer counter
	ADDS	R6,R6,#1							; Increment cell counter
	CMP 	R1,#' '								; 
	BEQ 	Place_Cell_Space					; Branch if cell is empty type
	PUSH	{R0}								; 
	LDR 	R0,=COLOR							; Load color table
	LDRB	R1,[R0,R1]							; Load color of block type
	POP 	{R0}								; 
	CMP 	R1,R4								; 
	BEQ 	Place_Line_SameColor				; Skip color change if cell color is the same as previous
	MOVS	R4,R1								; Update previous cell color
	MOVS	R1,#'\x1b'							; (Generates an ascii color sequence which changes the text color)
	STRB	R1,[R0,R7]							; Append: '\x1b'
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'['								; 
	STRB	R1,[R0,R7]							; Append: '['
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'3'								; 
	STRB	R1,[R0,R7]							; Append: '3'
	ADDS	R7,R7,#1							; Increment character counter
	STRB	R4,[R0,R7]							; Append: block color
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'m'								; 
	STRB	R1,[R0,R7]							; Append: 'm'
	ADDS	R7,R7,#1							; Increment character counter
Place_Line_SameColor							; 
	MOVS	R1,#'['								; (Draw placed cell)
	STRB	R1,[R0,R7]							; Append: '['
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#']'								; 
	STRB	R1,[R0,R7]							; Append: ']'
	ADDS	R7,R7,#1							; Increment character counter
	B   	Place_Cell_Exit						; 
Place_Cell_Space								; (Draw empty cell)
	STRB	R1,[R0,R7]							; Append: ' '
	ADDS	R7,R7,#1							; Increment character counter
	STRB	R1,[R0,R7]							; Append: ' '
	ADDS	R7,R7,#1							; Increment character counter
Place_Cell_Exit									; 
	CMP 	R6,#10								; 
	BLO 	Place_Cell_Loop						; Branch if line is still being read
	MOVS	R1,#'\x1b'							; (Generates an ascii character sequence which moves the cursor back 20 columns)
	STRB	R1,[R0,R7]							; Append: '\x1b'
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'['								; 
	STRB	R1,[R0,R7]							; Append: '['
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'2'								; 
	STRB	R1,[R0,R7]							; Append: '2'
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'0'								; 
	STRB	R1,[R0,R7]							; Append: '0'
	ADDS	R7,R7,#1							; Increment character counter
	MOVS	R1,#'D'								; 
	STRB	R1,[R0,R7]							; Append: 'B'
	ADDS	R7,R7,#1							; Increment character counter
	CMP 	R2,#0								; 
	BHI 	Place_Line_Loop						; Branch if clearBuffer counter is higher than 0
	STRB	R2,[R0,R7]							; Append: null character
	BL  	PutStringSB							; Print sequenceBuffer to the terminal
Place_Line_Skip									; 
	LDR 	R4,=blockData						; Restore the address of blockData to R4
	POP 	{R6-R7}								; 
	LDR 	R0,=lines							; Load lines text field address
	LDR 	R1,[R0,#8]							; Load lines text field data
	MOVS	R2,R5								; 
	LSLS	R2,R2,#8							; 
	ADDS	R1,R1,R2							; Add lines cleared to the value starting at the second byte of the word (0x123456xx + 0x100)
	STR 	R1,[R0,#8]							; Store lines text field data
	BL  	DrawText							; Update lines text field in terminal
	LSRS	R1,R1,#8							; Convert lines data to lines value
	MOVS    R2,#0								; 
Place_Level_Divide_Loop							; (Convert total lines cleared to corresponding level)
	CMP     R1,#10								; 
	BLO     Place_Level_Divide_Exit				; 
	SUBS    R1,R1,#10							; 
	ADDS    R2,R2,#1							; 
	B       Place_Level_Divide_Loop				; 
Place_Level_Divide_Exit							; 
	LSLS	R2,R2,#8							; Convert level value to level data (0x00001234 -> 0x00123400)
	ADDS	R2,R2,#2							; Add character data to level data (0x00123400 + number of characters -> 0x00123402)
	LDR 	R0,=level							; Load level text field address
	LDR 	R1,[R0,#8]							; Load previous level data
	MOVS	R3,R1								; 
	LSRS	R3,R3,#8							; Convert previous level data to previous level value
	ADDS	R3,R3,#1							; Add 1 to previous level value for scoring purposes (level + 1)
	CMP 	R2,R1								; If new level is lower than the previous level don't update previous level
	BLS 	Place_SameLevel						; 	(Handles case of starting at a higher level)
	SUBS	R6,R6,#8							; Decrease drop time by .08 seconds
	STR 	R2,[R0,#8]							; Store new level data
	BL  	DrawText							; Update level text field in terminal
Place_SameLevel									; 
	MOVS	R2,#0								; Initialize 
	CMP 	R5,#0								; 
	BEQ 	Place_Score_Bonus					; Skip line clearing bonus if no lines were cleared
	MOVS	R1,R3								; Bonus for 1 line: 40 * (level + 1)
	LSLS	R1,R1,#5							; 32 * (level + 1)
	ADDS	R2,R2,R1							; 
	MOVS	R1,R3								; 
	LSLS	R1,R1,#3							; 8 * (level + 1)
	ADDS	R2,R2,R1							; line bonus = 40 * (level + 1)
	CMP 	R5,#2								; 
	BLO 	Place_Score_Bonus					; 
	MOVS	R1,R2								; Bonus for 2 lines: 100 * (level  + 1)
	LSLS	R2,R2,#1							; 
	LSRS	R1,R1,#1							; 
	ADDS	R2,R2,R1							; line bonus *= 1.5
	CMP 	R5,#3								; 
	BLO 	Place_Score_Bonus					; 
	MOVS	R1,R2								; Bonus for 3 lines: 300 * (level  + 1)
	LSLS	R2,R2,#1							; 
	ADDS	R2,R2,R1							; line bonus *= 3
	CMP 	R5,#4								; 
	BLO 	Place_Score_Bonus					; Bonus for 4 lines: 1200 * (level  + 1)
	LSLS	R2,R2,#2							; line bonus *= 4
Place_Score_Bonus								; 
	ADDS	R2,R2,R7							; points = line bonus + drop bonus
	LSLS	R2,R2,#8							; 
	LDR 	R0,=score							; Load score text field address
	LDR 	R1,[R0,#8]							; Load previous score data
	ADDS	R1,R1,R2							; Increase score by point
	STR 	R1,[R0,#8]							; Store new score data
	LDR 	R0,=top								; Load top text field address
	LDR 	R2,[R0,#8]							; Load top data
	CMP 	R1,R2								; 
	BLO 	Place_Score_SkipHigh				; Update highscore if score is higher
	STR 	R1,[R0,#8]							; Store score data in top text field
	BL  	DrawText							; Draw changes in terminal
Place_Score_SkipHigh							; 
	LDR 	R0,=score							; Load score text field address
	BL  	DrawText							; Draw changes in terminal
	LDR 	R0,=TxQRecord						; Load transmit queue address
Place_Delay										; 
	LDRB	R1,[R0,#NUM_ENQD]					; Load TxQueue size
	CMP 	R1,#0								; 
	BHI 	Place_Delay							; Wait until screen is finished updating
	POP 	{R5,R0-R3,PC}						; Exit
	ENDP										; 


	ALIGN
	LTORG


;------------------------------
; DrawBlock
;
; Re-draws the block in the terminal.
;
; Parameters:
;	R4 - Address of 'blockData'
; Returns:
;------------------------------
DrawBlock PROC {R0-R14},{}					; 
	PUSH	{LR,R0-R3,R5-R7}				; 
	LDRB	R2,[R4,#4]						; Load old block type
	LSLS	R2,R2,#4						; 
	LDR 	R5,=BLOCK						; Load block definition table
	ADDS	R5,R5,R2						; Add old block type offset to base address
	LDRB	R1,[R4,#5]						; Load old block orientation
	ADDS	R5,R5,R1						; Add old orientation offset to definition address
	LDRH	R1,[R4,#6]						; Load old block position index
	MOVS	R2,#4							; Initialize cell down-counter
	LDR 	R3,=indexBuffer					; Load indexBuffer address
	LDR 	R6,=0x20200000					; Load empty cell type
	MOVS	R7,#0							; Initialize cell data counter
DrawBlock_Load_Clear_Loop					; 
	SUBS	R2,R2,#1						; Decrement cell counter
	LDRSB	R0,[R5,R2]						; Load old cell position offset
	ADDS	R0,R0,R1						; Add old cell position index to old cell position offset
	CMP 	R0,#72							; 
	BLO 	DrawBlock_Load_Clear_Skip		; Skip if old cell is outside visible range
	ADDS	R0,R0,R6						; Add empty cell type to cell data (cell data: 0x[4-7: type][0-3: index])
	STR 	R0,[R3,R7]						; Append cell data to indexBuffer
	ADDS	R7,R7,#4						; Increment cell data counter
DrawBlock_Load_Clear_Skip					; 
	CMP 	R2,#0							; 
	BHI 	DrawBlock_Load_Clear_Loop		; Repeat for each old cell
	LDRB	R2,[R4,#0]						; Load current block type
	LSLS	R2,R2,#4						; 
	LDR 	R5,=BLOCK						; Load block definition table
	ADDS	R5,R5,R2						; Add current block type offset to base address
	LDRB	R1,[R4,#1]						; Load current block orientation
	ADDS	R5,R5,R1						; Add current orientation offset to definition address
	LDRH	R1,[R4,#2]						; Load current block position index
	LDR 	R6,=0x29280000					; Load unplaced cell type
	MOVS	R2,#4							; Initialize cell down-counter
DrawBlock_Load_Place_Loop					; 
	SUBS	R2,R2,#1						; Decrement cell counter
	LDRSB	R0,[R5,R2]						; Load current cell position offset
	ADDS	R0,R0,R1						; Add current cell position index to current cell position offset
	CMP 	R0,#72							; 
	BLO 	DrawBlock_Load_Place_Skip		; Skip if current cell is outside visible range
	PUSH	{R2}							; Preserve cell counter
	MOVS	R2,#0							; Initialize temp cell data counter
DrawBlock_Load_Place_Loop_0					; 
	LDRH	R4,[R3,R2]						; Load cell index from cell data
	CMP 	R0,R4							; 
	BLO 	DrawBlock_Load_Insert			; Insert current cell if current cell index is lower than cell index
	BEQ 	DrawBlock_Load_Replace			; Replace cell if current cell index is equal to cell index
	ADDS	R2,R2,#4						; Increment temp cell data counter
	CMP 	R2,R7							; 
	BLO 	DrawBlock_Load_Place_Loop_0		; Repeat while temp cell data counter is lower than cell data counter
	ADDS	R7,R7,#4						; Increment cell data counter
DrawBlock_Load_Replace						; 
	ADDS	R0,R0,R6						; Convert current cell index to cell data
	STR 	R0,[R3,R2]						; Store cell data in place of old cell data
	POP 	{R2}							; Retrieve cell counter
	CMP 	R2,#0							; 
	BHI 	DrawBlock_Load_Place_Loop		; Repeat for each cell
	B   	DrawBlock_Load_Place_Loop_Exit	; 
DrawBlock_Load_Insert						; 
	ADDS	R0,R0,R6						; Convert current cell index to cell data
	ADDS	R7,R7,#4						; Increment cell data counter
DrawBlock_Load_Insert_Loop					; 
	LDR 	R4,[R3,R2]						; Load next cell data element
	STR 	R0,[R3,R2]						; Store current cell data
	ADDS	R2,R2,#4						; Increment cell counter
	MOVS	R0,R4							; Move next cell data to current cell data
	CMP 	R2,R7							; 
	BLO 	DrawBlock_Load_Insert_Loop		; Loop for each element stored
	POP 	{R2}							; Restore cell counter to amount before insertion
DrawBlock_Load_Place_Skip					; 
	CMP 	R2,#0							; 
	BHI 	DrawBlock_Load_Place_Loop		; Store next cell data until none remain
DrawBlock_Load_Place_Loop_Exit				; 
	LDR 	R0,=sequenceBuffer				; Load sequenceBuffer addess
	MOVS	R6,#0							; Initialize character counter
	LDR 	R1,=0x335B1B					; Load "\x1b[3"
	STR 	R1,[R0,R6]						; Append: "\x1b[3"
	ADDS	R6,R6,#3						; Increment character counter by 3
	LDR 	R4,=blockData					; Load blockData address
	LDRB	R1,[R4,#0]						; Load block type
	LDR 	R4,=COLOR						; Load block definition table
	LDRB	R1,[R4,R1]						; Load color of block type
	STRB	R1,[R0,R6]						; Append: block color
	ADDS	R6,R6,#1						; Increment character counter
	MOVS	R1,#'m'							; 
	STRB	R1,[R0,R6]						; Append: 'm'
	ADDS	R6,R6,#1						; Increment character counter
	MOVS	R4,#0							; Set last cell index to 0
	MOVS	R5,#0							; Initialize cell data counter
DrawBlock_Build_Loop						; 
	LDRH	R1,[R3,R5]						; Load next cell data
	ADDS	R5,R5,#2						; Increment cell data counter
	SUBS	R4,R1,R4						; Get distance from last cell
	CMP 	R4,#2							; 
	BEQ 	DrawBlock_Build_Append			; Append cell if adjacent to previous cell
	PUSH	{R1-R5}							; 	(Otherwise set new cursor position)
	SUBS	R1,R1,#72						; Convert absolute position index to visible position index
	MOVS	R4,#23							; Initialize column number
	MOVS	R5,#5							; Initialize row number
DrawBlock_Build_Divide						; (Convert hexadecimal position index to ascii row and column)
	CMP 	R1,#24							; Divide visible position index (R1) by row length
	BLO 	DrawBlock_Build_Divide_Exit		; 
	SUBS	R1,R1,#24						; Decrement column number offset
	ADDS	R5,R5,#1						; Increment row number
	B   	DrawBlock_Build_Divide			; 
DrawBlock_Build_Divide_Exit					; 
	ADDS	R4,R4,R1						; Add column number offset to column number
	MOVS	R1,#'\x1b'						; 
	STRB	R1,[R0,R6]						; Append: '\x1b'
	ADDS	R6,R6,#1						; Increment character counter
	MOVS	R1,#'['							; 
	STRB	R1,[R0,R6]						; Append: '['
	ADDS	R6,R6,#1						; Increment character counter
	MOVS	R2,#48							; Initailize row ascii decimal (High)
	MOVS	R3,R5							; Initailize row ascii decimal (Low)
DrawBlock_Build_MoveY						; 
	CMP 	R3,#10							; 
	BLO 	DrawBlock_Build_MoveY_Exit		; 
	ADDS	R2,R2,#1						; Increment row ascii decimal (High)
	SUBS	R3,R3,#10						; Decrement row ascii decimal (Low)
	BHI 	DrawBlock_Build_MoveY			; 
DrawBlock_Build_MoveY_Exit					; 
	STRB	R2,[R0,R6]						; Append: row ascii decimal (High)
	ADDS	R6,R6,#1						; Increment character counter
	ADDS	R3,R3,#48						; Convert decimal to ascii
	STRB	R3,[R0,R6]						; Append: row ascii decimal (Low)
	ADDS	R6,R6,#1						; Increment character counter
	MOVS	R1,#';'							; 
	STRB	R1,[R0,R6]						; Append: ';'
	ADDS	R6,R6,#1						; Increment character counter
	MOVS	R2,#48							; Initailize column ascii decimal (High)
	MOVS	R3,R4							; Initailize column ascii decimal (Low)
DrawBlock_Build_MoveX						; 
	CMP 	R3,#10							; 
	BLO 	DrawBlock_Build_MoveX_Exit		; 
	ADDS	R2,R2,#1						; Increment column ascii decimal (High)
	SUBS	R3,R3,#10						; Decrement column ascii decimal (Low)
	BHI 	DrawBlock_Build_MoveX			; 
DrawBlock_Build_MoveX_Exit					; 
	STRB	R2,[R0,R6]						; Append: column ascii decimal (High)
	ADDS	R6,R6,#1						; Increment character counter
	ADDS	R3,R3,#48						; Convert decimal to ascii
	STRB	R3,[R0,R6]						; Append: column ascii decimal (Low)
	ADDS	R6,R6,#1						; Increment character counter
	MOVS	R1,#'H'							; 
	STRB	R1,[R0,R6]						; Append: 'H'
	ADDS	R6,R6,#1						; Increment character counter
	POP 	{R1-R5}							; 
DrawBlock_Build_Append						; 
	MOVS	R4,R1							; Set current position index as last position index
	LDRH	R1,[R3,R5]						; Load cell data
	ADDS	R5,R5,#2						; Increment cell data counter
	STRB	R1,[R0,R6]						; Append: cell type
	ADDS	R6,R6,#1						; Increment character counter
	LSRS	R1,R1,#8						; Convert cell data to cell color
	STRB	R1,[R0,R6]						; Append: cell color
	ADDS	R6,R6,#1						; Increment character counter
	CMP 	R5,R7							; 
	BLO 	DrawBlock_Build_Loop			; Repeat until no cells remain
	MOVS	R1,#'\0'						; 
	STRB	R1,[R0,R6]						; Append: null character
	BL  	PutStringSB						; Draw changes in the terminal
	LDR 	R4,=blockData					; Restore address of blockData to R4
	POP 	{R5-R7,R0-R3,PC}				; Exit
	ENDP									; 


;------------------------------
; GetNext
;
; Determines the next block and
;	displays it in the preview box.
;
; Parameters:
; Returns:
;------------------------------
GetNext PROC {R0-R14},{}		; 
	PUSH	{LR,R0-R3,R6-R7}	; 
	LDR 	R3,=seed			; Load seed address
	LDR 	R0,[R3,#0]			; Load seed
	CMP 	R0,#0				; 
	BNE 	GetNext_SeedOkay	; Skip if seed is non-zero
	LDR 	R0,[R3,#4]			; Load original seed
	STR 	R0,[R3,#0]			; Replace current seed with original
GetNext_SeedOkay				; 
	MOVS	R1,R0				; Copy seed
	LSLS	R1,R1,#13			; Shift copy
	EORS	R0,R0,R1			; XOR with original
	MOVS	R1,R0				; Copy seed
	LSRS	R1,R1,#17			; Shift copy
	EORS	R0,R0,R1			; XOR with last seed
	MOVS	R1,R0				; Copy seed
	LSLS	R1,R1,#5			; Shift copy
	EORS	R0,R0,R1			; XOR with last seed
	STR 	R0,[R3,#0]			; Store new seed
	LSRS	R0,R0,#16			; Shift number right 16 bits for longer RNG period
	MOVS	R2,#7				; Set mask
GetNext_Shift					; 
	LSRS	R0,R0,#4			; Shift next half byte
	MOVS	R1,R0				; Copy number
	ANDS	R1,R1,R2			; Mask number
	CMP 	R1,#6				; 
	BHI 	GetNext_Shift		; Branch if higher than 6 (not a valid block type)
	LDR 	R0,=nextBlock		; Load nextBlock address
	STRB	R1,[R0,#0]			; Store block type in nextBlock
	LDR 	R0,=CLEAR_NEXT		; Load clear block string address
	BL  	PutStringSB			; Clear the previous block from the display
	LDR 	R0,=DRAW_NEXT		; Load next block draw table
	LSLS	R1,R1,#5			; 
	ADDS	R0,R0,R1			; Get next block draw string address from table at block type offset
	BL  	PutStringSB			; Draw next block in the preview window in the terminal
	POP 	{R6-R7,R0-R3,PC}	; Exit
	ENDP						; 


;------------------------------
; PutNext
;
; Initializes the next block, increments
;	block statistics, and calls 'GetNext'
;	and 'Update'.
;
; Parameters:
;	R4 - Address of 'blockData'
; Returns:
;	C Flag - 0 : Okay, 1 : Invalid block placement (Game Over)
;------------------------------
PutNext PROC {R0-R14},{}	; 
	PUSH	{LR,R0-R2}		; 
	LDR 	R0,=nextBlock	; Load nextBlock address
	LDRB	R1,[R0,#0]		; Load next block type
	STRB	R1,[R4,#0]		; Store next block type in block data
	MOVS	R0,#0			; 
	STRB	R0,[R4,#1]		; Set block orientation to 0
	MOVS	R0,#0x54		; 
	STRH	R0,[R4,#2]		; Set block position index to 0x54
	LDR 	R0,[R4,#0]		; Load block data
	STR 	R0,[R4,#4]		; Copy block data to last data (No spaces will be cleared on re-draw)
	MOVS	R0,R1			; 
	LSLS	R1,R1,#2		; 
	LSLS	R0,R0,#3		; 
	ADDS	R1,R1,R0		; Multiply next block type by 12
	LDR 	R0,=statistics	; Load statistics table address
	ADDS	R0,R0,R1		; Add block type offset to statistics table
	LDR 	R1,[R0,#8]		; Load statistics text field data
	MOVS	R2,#1			; 
	LSLS	R2,R2,#8		; 
	ADDS	R1,R1,R2		; Add 1 to the value starting at the second byte of the word (0x123456xx + 0x100)
	STR 	R1,[R0,#8]		; Store new value
	BL  	DrawText		; Draw the new statistics value
	BL  	GetNext			; Call GetNext
	MOVS	R0,#0			; 
	MOVS	R1,#0			; 
	BL  	Update			; Call Update with no changes to place and draw block (returns C flag)
	POP 	{R0-R2,PC}		; Exit
	ENDP					; 


;------------------------------
; DrawText
;
; Draws the formatted text at the
;	address specified.
;
; Parameters:
;	R0 - Address of the text field
; Returns:
;------------------------------
DrawText PROC {R0-R14},{}			; 
	PUSH	{LR,R0-R3,R5-R6}		; 
	MOVS	R3,R0					; Move address of text field
	LDR 	R0,=sequenceBuffer		; Load sequenceBuffer
	LDR 	R1,[R3,#0]				; Load text field cursor location sequence (1/2)
	STR 	R1,[R0,#0]				; Append: text field cursor location sequence (1/2)
	LDR 	R1,[R3,#4]				; Load text field cursor location sequence (2/2)
	STR 	R1,[R0,#4]				; Append: text field cursor location sequence (2/2)
	LDR 	R1,=0x37335B1B			; Load "\x1b[37" (color: white)
	STR 	R1,[R0,#8]				; Append: "\x1b[37"
	MOVS	R1,#'m'					; 
	STR 	R1,[R0,#12]				; Append: 'm'
	LDR 	R1,[R3,#8]				; Load text field data
	LSRS	R1,R1,#8				; Shift first byte out of value (0x123456xx -> 0x00123456)
	LDRB	R2,[R3,#8]				; Load text field number of characters (0xxxxxxx12 -> 0x00000012)
	MOVS	R6,R2					; Copy number of characters
	ADDS	R2,R2,#13				; Set max characters to 13 + number of characters
	MOVS	R3,#13					; Initialize character counter to 13
DrawText_Divide						; 
	MOVS    R5,R1					; Move number to R5
	MOVS    R1,#0					; Initialize dividend to 0
DrawText_Divide_Loop				; Convert hexadecimal number (R5) to decimal
	CMP     R5,#10					; 
	BLO     DrawText_Divide_Exit	; 
	SUBS    R5,R5,#10				; 
	ADDS    R1,R1,#1				; 
	B       DrawText_Divide_Loop	; 
DrawText_Divide_Exit				; 
	ADDS	R5,R5,#48				; Covert decimal to ascii
	PUSH	{R5}					; Save character to append in reverse order and after padding
	SUBS	R6,R6,#1				; Decrement number of characters
	CMP 	R1,#0					; 
	BHI 	DrawText_Divide			; Loop if dividend is higher than 0
DrawText_Pad						; Append leading 0's (number's never decrease so could've just moved the cursor instead)
	CMP 	R6,#0					; 
	BEQ 	DrawText_Append			; Append number if all leading 0's have been placed
	SUBS	R6,R6,#1				; Decrement number of characters
	MOVS	R1,#'0'					; 
	STRB	R1,[R0,R3]				; Append: '0'
	ADDS	R3,R3,#1				; Increment character counter
	B   	DrawText_Pad			; 
DrawText_Append						; 
	CMP 	R3,R2					; 
	BEQ 	DrawText_Finish			; Branch if character counter equals max characters
	POP 	{R1}					; Retrieve saved character
	STRB	R1,[R0,R3]				; Append: character
	ADDS	R3,R3,#1				; Increment character counter
	B   	DrawText_Append			; 
DrawText_Finish						; 
	MOVS	R1,#'\0'				; 
	STRB	R1,[R0,R3]				; Append: null character
	BL  	PutStringSB				; Modify the text field in the terminal
	POP 	{R5-R6,R0-R3,PC}		; Exit
	ENDP							; 


;------------------------------
; Reset
;
; Initializes a new instance of the game.
;
; Parameters:
;	C Flag - 0 : Keep Highscore, 1 : Clear Highscore
; Returns:
;------------------------------
Reset PROC {R0-R14},{}				; 
	PUSH	{LR,R0-R4}				; 
	BCC 	Reset_Soft				; Branch if C flag is clear (keep highscore)
	LDR 	R1,=VTP					; Load top text field reset value address
	LDR 	R2,=top					; Load top address
	LDR 	R0,[R1,#8]				; Load top text field reset value
	STR 	R0,[R2,#8]				; Store top text field reset value in text field
Reset_Soft							; 
	MOVS	R1,#0					; Initialize character counter
	LDR 	R2,=BOARD				; Load board display base address
	LDR 	R3,=1773				; Load number of board display characters
Reset_Display_Loop					; 
	LDRB 	R0,[R2,R1]				; Load character
	BL  	PutChar					; Print character to the terminal
	ADDS	R1,R1,#1				; Increment character counter
	CMP 	R1,R3					; 
	BLO 	Reset_Display_Loop		; Loop if character counter is lower than number of board display characters
	LDR 	R2,=board				; Load board address
	LDR 	R3,=552					; Load size of board
	ADDS	R3,R3,R2				; Set max characters
Reset_Board_Loop					; 
	LDR 	R0,=0x20204040			; Load 'row reset' (1/3)
	STR  	R0,[R2,#0]				; Store 'row reset' (1/3)
	LDR 	R0,=0x20202020			; Load 'row reset' (2/3)
	STR  	R0,[R2,#4]				; Store 'row reset' (2/3)
	STR  	R0,[R2,#8]				; Store 'row reset' (2/3)
	STR  	R0,[R2,#12]				; Store 'row reset' (2/3)
	STR  	R0,[R2,#16]				; Store 'row reset' (2/3)
	LDR 	R0,=0x40402020			; Load 'row reset' (3/3)
	STR  	R0,[R2,#20]				; Store 'row reset' (3/3)
	ADDS	R2,R2,#24				; Increment character counter
	CMP 	R2,R3					; 
	BLO 	Reset_Board_Loop		; Loop if character counter is lower than max characters
	LDR 	R0,=0x40404040			; Load 'last row reset'
	STR  	R0,[R2,#0]				; Store 'last row reset'
	STR  	R0,[R2,#4]				; Store 'last row reset'
	STR  	R0,[R2,#8]				; Store 'last row reset'
	STR  	R0,[R2,#12]				; Store 'last row reset'
	STR  	R0,[R2,#16]				; Store 'last row reset'
	STR  	R0,[R2,#20]				; Store 'last row reset'
	LDR 	R1,=VARIABLE_BASE		; Load variable base table
	LDR 	R2,=statistics			; Load statistics table
	MOVS	R3,#0					; Initialize word counter
Reset_Variables_Loop				; (Hard copy variable reset values)
	LDR 	R0,[R1,R3]				; Load word
	STR 	R0,[R2,R3]				; Store word
	ADDS	R3,R3,#4				; Increment word counter
	CMP 	R3,#128					; 
	BLO 	Reset_Variables_Loop	; Loop if word counter is lower than 128
	LDR 	R0,=top					; Load top text field address
	BL  	DrawText				; Modify text in the terminal
	POP 	{R0-R4,PC}				; Exit
	ENDP							; 


	ALIGN
	LTORG
	END
