            TTL PAGES
;------------------------------
; Description: Preconfigured Assembly Game Execution Shell
; Name: Wesley F Dahar (wesleydahar@gmail.com)
; Date: 11/26/17

;------------------------------
; Assembler Directives
;------------------------------
	THUMB
	OPT 	64
	GET 	MKL46Z4.s
	OPT 	1

;------------------------------
; Equates
;------------------------------
PIT_IRQ_PRIORITY EQU 0
NVIC_IPR_PIT_PRI_0 EQU (PIT_IRQ_PRIORITY << UART0_PRI_POS)
NVIC_IPR_PIT_MASK EQU (3 << PIT_PRI_POS)
NVIC_ICER_PIT_MASK EQU PIT_IRQ_MASK
NVIC_ICPR_PIT_MASK EQU PIT_IRQ_MASK
NVIC_ISER_PIT_MASK EQU PIT_IRQ_MASK
PIT_LDVAL_10ms EQU 239999
PIT_MCR_EN_FRZ EQU PIT_MCR_FRZ_MASK
PIT_TCTRL_CH_IE EQU (PIT_TCTRL_TEN_MASK :OR: PIT_TCTRL_TIE_MASK)

UART0_IRQ_PRIORITY EQU 3
NVIC_IPR_UART0_PRI_3 EQU (UART0_IRQ_PRIORITY << UART0_PRI_POS)
NVIC_IPR_UART0_MASK EQU (3 << UART0_PRI_POS)
NVIC_ICER_UART0_MASK EQU UART0_IRQ_MASK
NVIC_ICPR_UART0_MASK EQU UART0_IRQ_MASK
NVIC_ISER_UART0_MASK EQU UART0_IRQ_MASK
PORT_PCR_SET_PTA1_UART0_RX EQU (PORT_PCR_ISF_MASK :OR: PORT_PCR_MUX_SELECT_2_MASK)
PORT_PCR_SET_PTA2_UART0_TX EQU (PORT_PCR_ISF_MASK :OR: PORT_PCR_MUX_SELECT_2_MASK)
SIM_SOPT2_UART0SRC_MCGPLLCLK EQU (1 << SIM_SOPT2_UART0SRC_SHIFT)
SIM_SOPT2_UART0_MCGPLLCLK_DIV2 EQU (SIM_SOPT2_UART0SRC_MCGPLLCLK :OR: SIM_SOPT2_PLLFLLSEL_MASK)
SIM_SOPT5_UART0_EXTERN_MASK_CLEAR EQU (SIM_SOPT5_UART0ODE_MASK :OR: SIM_SOPT5_UART0RXSRC_MASK :OR: SIM_SOPT5_UART0TXSRC_MASK)
UART0_BDH_9600 EQU 0x01
UART0_BDL_9600 EQU 0x38

UART0_BDH_19200 EQU 0x00
UART0_BDL_19200 EQU 0x9C

UART0_C1_8N1 EQU 0x00
UART0_C2_T_R EQU (UART0_C2_TE_MASK :OR: UART0_C2_RE_MASK)
UART0_C2_T_RI EQU (UART0_C2_RIE_MASK :OR: UART0_C2_T_R)
UART0_C2_TI_RI EQU (UART0_C2_TIE_MASK :OR: UART0_C2_T_RI)
UART0_C3_NO_TXINV EQU 0x00
UART0_C4_OSR_16 EQU 0x0F
UART0_C4_NO_MATCH_OSR_16 EQU UART0_C4_OSR_16
UART0_C5_NO_DMA_SSR_SYNC EQU 0x00
UART0_S1_CLEAR_FLAGS EQU 0x1F
UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS EQU 0xC0

POS_RED EQU 29
POS_GREEN EQU 5
LED_RED_MASK EQU (1 << POS_RED)
LED_GREEN_MASK EQU (1 << POS_GREEN)
LED_PORTD_MASK EQU LED_GREEN_MASK
LED_PORTE_MASK EQU LED_RED_MASK
PTD5_MUX_GPIO EQU (1 << PORT_PCR_MUX_SHIFT)
SET_PTD5_GPIO EQU (PORT_PCR_ISF_MASK :OR: PTD5_MUX_GPIO)
PTE29_MUX_GPIO EQU (1 << PORT_PCR_MUX_SHIFT)
SET_PTE29_GPIO EQU (PORT_PCR_ISF_MASK :OR: PTE29_MUX_GPIO)
SIM_SCGC5_PORTDE_MASK EQU (SIM_SCGC5_PORTD_MASK :OR: SIM_SCGC5_PORTE_MASK)

IN_PTR EQU 0
OUT_PTR EQU 4
BUF_STRT EQU 8
BUF_PAST EQU 12
BUF_SIZE EQU 16
NUM_ENQD EQU 17
REC_SIZE EQU 18
RxQ_SIZE EQU 1
TxQ_SIZE EQU 128

	INCLUDE	Equates.s

;------------------------------
; Program
;------------------------------
	AREA	PAGES_Code,CODE,READONLY
ENTRY
	EXPORT	Reset_Handler
	IMPORT	Startup

;------------------------------
; Reset Handler
;------------------------------
Reset_Handler PROC {},{}
	CPSID	I
	BL  	Startup
	BL  	Init_UART0_IRQ
	BL  	Init_PIT_IRQ
	BL  	Init_LEDs
	CPSIE	I
	LDR 	R0,=0x0
	MOVS	R1,#1
	LSRS	R1,R1,#1
	INCLUDE	Main.s
	B   	.
	ENDP

;------------------------------
; Subroutines
;------------------------------
	INCLUDE	Subroutines.s

InitQueue PROC {R0-R14},{}		; 
	PUSH	{R0}				; 
	STR 	R0,[R1,#IN_PTR]		; 
	STR 	R0,[R1,#OUT_PTR]	; 
	STR 	R0,[R1,#BUF_STRT]	; 
	ADDS	R0,R0,R2			; 
	STR 	R0,[R1,#BUF_PAST]	; 
	STRB	R2,[R1,#BUF_SIZE]	; Set max size to R2
	MOVS	R0,#0				; 
	STRB	R0,[R1,#NUM_ENQD]	; Set size to 0
	POP 	{R0}				; 
	BX  	LR					; Exit
	ENDP						; 


Enqueue PROC {R0-R14},{}		; 
	PUSH	{R2-R3}				; 
	LDRB	R2,[R1,#NUM_ENQD]	; Load size
	LDRB	R3,[R1,#BUF_SIZE]	; Load max size
	CMP 	R2,R3				; 
	BEQ 	Enqueue_Failed		; Exit if full
	LDR 	R3,[R1,#IN_PTR]		; Load InPointer
	STRB	R0,[R3,#0]			; Store element at InPointer
	ADDS	R2,R2,#1			; Increment size
	STRB	R2,[R1,#NUM_ENQD]	; Store size
	ADDS	R3,R3,#1			; Increment InPointer
	LDR 	R2,[R1,#BUF_PAST]	; Load PastPointer
	CMP 	R3,R2				; 
	BLO 	Enqueue_NoLoop		; Branch if InPointer is lower than PastPointer
	LDR 	R3,[R1,#BUF_STRT]	; Load StartPointer
Enqueue_NoLoop					; 
	STR 	R3,[R1,#IN_PTR]		; Store StartPointer in InPointer
	MOVS	R2,#0				; Set R2 to 0
	B   	Enqueue_Exit		; 
Enqueue_Failed					; 
	MOVS	R2,#1				; Set R2 to 1
Enqueue_Exit					; 
	LSRS	R2,R2,#1			; Set C flag to R2
	POP 	{R2-R3}				; 
	BX  	LR					; Exit
	ENDP						; 


Dequeue PROC {R0-R14},{}		; 
	PUSH	{R2-R3}				; 
	LDRB	R2,[R1,#NUM_ENQD]	; Load size
	CMP 	R2,#0				; 
	BEQ 	Dequeue_Failed		; Exit if empty
	LDR 	R3,[R1,#OUT_PTR]	; Load OutPointer
	LDRB	R0,[R3,#0]			; Load element at OutPointer
	ADDS	R3,R3,#1			; Increment OutPointer
	SUBS	R2,R2,#1			; Decrement size
	STRB	R2,[R1,#NUM_ENQD]	; Store size
	LDR 	R2,[R1,#BUF_PAST]	; Load PastPointer
	CMP 	R3,R2				; 
	BLO 	Dequeue_NoLoop		; Branch if OutPointer is lower than PastPointer
	LDR 	R3,[R1,#BUF_STRT]	; Load StartPointer
Dequeue_NoLoop					; 
	STR 	R3,[R1,#OUT_PTR]	; Store StartPointer in OutPointer
	MOVS	R2,#0				; Set R2 to 0
	B   	Dequeue_Exit		; 
Dequeue_Failed					; 
	MOVS	R2,#1				; Set R2 to 1
Dequeue_Exit					; 
	LSRS	R2,R2,#1			; Set C flag to R2
	POP 	{R2-R3}				; 
	BX  	LR					; Exit
	ENDP						; 


PutStringSB PROC {R0-R14},{}	; 
	PUSH	{LR,R0,R2-R3}		; 
	MOVS	R2,R0				; Move string address to R2
	MOVS	R3,#0				; Initialize index to 0
PutStringSB_Loop				; 
	LDRB	R0,[R2,R3]			; Get character from string
	ADDS	R3,R3,#1			; Increment index
	;CMP 	R3,R1				; (Removed max length functionality)
	;BEQ 	PutStringSB_Exit	; 
	BL  	PutChar				; Print character to terminal
	CMP 	R0,#'\0'			; Exit if character is null
	BNE 	PutStringSB_Loop	; 
PutStringSB_Exit				; 
	POP 	{R2-R3,R0,PC}		; Exit
	ENDP						; 


CheckChar PROC {R1-R14},{}	; 
	PUSH	{LR,R1}			; 
	LDR 	R1,=RxQRecord	; Load RxQueue record address
	CPSID	I				; Disable interrupts
	BL  	Dequeue			; Dequeue character from RxQueue
	CPSIE	I				; Enable interrupts
	POP 	{R1,PC}			; Exit
	ENDP					; 


GetChar PROC {R1-R14},{}	; 
	PUSH	{LR,R1}			; 
	LDR 	R1,=RxQRecord	; Load RxQueue record address
GetChar_Loop				; 
	CPSID	I				; Disable interrupts
	BL  	Dequeue			; Dequeue chartacter from RxQueue
	CPSIE	I				; Enable interrupts
	BCS 	GetChar_Loop	; Loop if no character returned
	POP 	{R1,PC}			; Exit
	ENDP					; 


PutChar PROC {R0-R14},{}				; 
	PUSH	{LR,R1-R2}					; 
	LDR 	R1,=TxQRecord				; Load TxQueue record address
PutChar_Loop							; 
	CPSID	I							; Disable interrupts
	BL  	Enqueue						; Enqueue character to TxQueue
	CPSIE	I							; Enable interrupts
	BCS 	PutChar_Loop				; Loop if no character returned
	LDR 	R2,=UART0_BASE				; 
	MOVS	R1,#UART0_C2_TI_RI			; 
	STRB	R1,[R2,#UART0_C2_OFFSET]	; Set transmit interrupt flag
	POP 	{R1-R2,PC}					; Exit
	ENDP								; 


PIT_ISR PROC {R0-R14},{}			; 
	CPSID	I						; Disable interrupts
	LDR 	R0,=timer				; 
	LDRB	R0,[R0,#0]				; Load timer boolean value
	CMP 	R0,#0					; Exit if timer equals 0
	BEQ 	PIT_ISR_Exit			; 
	LDR 	R0,=counter				; 
	LDR 	R1,[R0,#0]				; Load counter value
	ADDS	R1,R1,#1				; Increment counter
	STR 	R1,[R0,#0]				; Store counter
PIT_ISR_Exit						; 
	LDR 	R0,=PIT_TFLG0			; 
	LDR 	R1,=PIT_TFLG_TIF_MASK	; 
	STR 	R1,[R0,#0]				; Clear interrupt flag
	CPSIE	I						; Enable interrupts
	BX  	LR						; Exit
	ENDP							; 


UART0_ISR PROC {R0-R14},{}				; 
	CPSID	I							; Disable interrupts
	PUSH	{LR,R4}						; 
	LDR 	R2,=UART0_BASE				; 
	LDRB	R3,[R2,#UART0_S1_OFFSET]	; 
	LDRB	R1,[R2,#UART0_C2_OFFSET]	; 
	MOVS	R4,#UART0_C2_TIE_MASK		; 
	TST 	R1,R4						; 
	BEQ 	UART0_ISR_Read				; Branch if UART0 transmit interrupts are disabled
	MOVS	R4,#UART0_S1_TDRE_MASK		; 
	TST 	R3,R4						; 
	BEQ 	UART0_ISR_Read				; Branch if UART0 transmit data register is empty
	LDR 	R1,=TxQRecord				; 
	BL  	Dequeue						; Dequeue character from TxQueue
	BCS 	UART0_ISR_DTI				; 
	STRB	R0,[R2,#UART0_D_OFFSET]		; Write character to UART0 transmit data register
	B   	UART0_ISR_Read				; 
UART0_ISR_DTI							; 
	MOVS	R4,#UART0_C2_T_RI			; 
	STRB	R4,[R2,#UART0_C2_OFFSET]	; Clear transmit interrupt flag
UART0_ISR_Read							; 
	MOVS	R4,#UART0_S1_RDRF_MASK		; 
	TST 	R3,R4						; if (RDRF == 1)
	BEQ 	UART0_ISR_Exit				; 
	LDRB	R0,[R2,#UART0_D_OFFSET]		; Read character from UART0 receive data register
	LDR 	R1,=RxQRecord				; 
	BL  	Enqueue						; Enqueue character in RxQueue
UART0_ISR_Exit							; 
	CPSIE	I							; Enable interrupts
	POP 	{R4,PC}						; Exit
	ENDP								; 


Init_LEDs PROC {R0-R14},{}				; 
	PUSH	{R0-R2}						; 
	LDR 	R0,=SIM_SCGC5				; 
	LDR 	R1,=(SIM_SCGC5_PORTDE_MASK)	; 
	LDR     R2,[R0,#0]					; 
	ORRS    R2,R2,R1					; 
	STR     R2,[R0,#0]					; Enable clock for PORT D and E modules
	LDR 	R0,=PORTE_BASE				; 
	LDR 	R1,=SET_PTE29_GPIO			; 
	STR 	R1,[R0,#PORTE_PCR29_OFFSET]	; Select PORT E Pin 29 for GPIO to red LED
	LDR 	R0,=PORTD_BASE				; 
	LDR 	R1,=SET_PTD5_GPIO			; 
	STR 	R1,[R0,#PORTD_PCR5_OFFSET]	; Select PORT D Pin 5 for GPIO to green LED
	LDR 	R0,=FGPIOD_BASE				; 
	LDR 	R1,=LED_PORTD_MASK			; 
	STR 	R1,[R0,#GPIO_PDDR_OFFSET]	; Set PORT E Pin 29 to output
	LDR 	R1,=LED_GREEN_MASK			; 
	STR 	R1,[R0,#GPIO_PSOR_OFFSET]	; Turn off green LED
	LDR 	R0,=FGPIOE_BASE				; 
	LDR 	R1,=LED_PORTE_MASK			; 
	STR 	R1,[R0,#GPIO_PDDR_OFFSET]	; Set PORT D Pin 5 to output
	LDR 	R1,=LED_RED_MASK			; 
	STR 	R1,[R0,#GPIO_PSOR_OFFSET]	; Turn off red LED
	POP 	{R0-R2}						; 
	BX  	LR							; Exit
	ENDP								; 


Init_PIT_IRQ PROC {R0-R14},{}
	PUSH	{R0-R3}
	LDR 	R0,=SIM_SCGC6
	LDR 	R1,=SIM_SCGC6_PIT_MASK
	LDR 	R2,[R0,#0]
	ORRS	R2,R2,R1
	STR 	R2,[R0,#0]
	LDR 	R0,=PIT_CH0_BASE
	LDR 	R1,=PIT_TCTRL_TEN_MASK
	LDR 	R2,[R0,#PIT_TCTRL_OFFSET]
	BICS	R2,R2,R1
	STR 	R2,[R0,#PIT_TCTRL_OFFSET] 
	LDR 	R0,=PIT_IPR
	LDR 	R1,=NVIC_IPR_PIT_MASK
	LDR 	R3,[R0,#0]
	BICS    R3,R3,R1
	;LDR     R2,=NVIC_IPR_PIT_PRI_0
	;ORRS    R3,R3,R2
	STR 	R3,[R0,#0]
	LDR     R0,=NVIC_ICPR
	LDR     R1,=NVIC_ICPR_PIT_MASK
	STR     R1,[R0,#0]
	LDR     R0,=NVIC_ISER
	LDR     R1,=NVIC_ISER_PIT_MASK
	STR     R1,[R0,#0]
	LDR 	R0,=PIT_BASE
	LDR 	R1,=PIT_MCR_EN_FRZ
	STR 	R1,[R0,#PIT_MCR_OFFSET]
	LDR 	R0,=PIT_CH0_BASE
	LDR 	R1,=PIT_LDVAL_10ms
	STR 	R1,[R0,#PIT_LDVAL_OFFSET]
	LDR 	R1,=PIT_TCTRL_CH_IE
	STR 	R1,[R0,#PIT_TCTRL_OFFSET] 
	POP 	{R0-R3}
	BX  	LR
	ENDP


Init_UART0_IRQ PROC {R0-R14},{}
	PUSH	{LR,R0-R3}
	LDR 	R0,=RxQBuffer
	LDR 	R1,=RxQRecord
	MOVS	R2,#RxQ_SIZE
	BL  	InitQueue
	LDR 	R0,=TxQBuffer
	LDR 	R1,=TxQRecord
	MOVS	R2,#TxQ_SIZE
	BL  	InitQueue
	LDR 	R0,=SIM_SOPT2
	LDR 	R1,=SIM_SOPT2_UART0SRC_MASK
	LDR 	R2,[R0,#0]
	BICS	R2,R2,R1
	LDR 	R1,=SIM_SOPT2_UART0_MCGPLLCLK_DIV2
	ORRS	R2,R2,R1
	STR 	R2,[R0,#0]
	LDR 	R0,=SIM_SOPT5
	LDR 	R1,=SIM_SOPT5_UART0_EXTERN_MASK_CLEAR
	LDR 	R2,[R0,#0]
	BICS	R2,R2,R1
	STR 	R2,[R0,#0]
	LDR 	R0,=SIM_SCGC4
	LDR 	R1,=SIM_SCGC4_UART0_MASK
	LDR 	R2,[R0,#0]
	ORRS	R2,R2,R1
	STR 	R2,[R0,#0]
	LDR 	R0,=SIM_SCGC5
	LDR 	R1,=SIM_SCGC5_PORTA_MASK
	LDR 	R2,[R0,#0]
	ORRS	R2,R2,R1
	STR 	R2,[R0,#0]
	LDR 	R0,=PORTA_PCR1
	LDR 	R2,=PORT_PCR_SET_PTA1_UART0_RX
	STR 	R2,[R0,#0]
	LDR 	R0,=PORTA_PCR2
	LDR 	R2,=PORT_PCR_SET_PTA2_UART0_TX
	STR 	R2,[R0,#0]
	LDR 	R0,=UART0_BASE
	MOVS	R1,#UART0_C2_T_R
	LDRB	R2,[R0,#UART0_C2_OFFSET]
	BICS	R2,R2,R1
	STRB	R2,[R0,#UART0_C2_OFFSET]
	LDR     R0,=UART0_IPR 
	LDR     R2,=NVIC_IPR_UART0_PRI_3
	LDR     R3,[R0,#0]
	;LDR     R1,=NVIC_IPR_UART0_MASK
	;BICS    R3,R3,R1
	ORRS    R3,R3,R2
	STR     R3,[R0,#0]
	LDR     R0,=NVIC_ICPR
	LDR     R1,=NVIC_ICPR_UART0_MASK
	STR     R1,[R0,#0]
	LDR     R0,=NVIC_ISER
	LDR     R1,=NVIC_ISER_UART0_MASK
	STR     R1,[R0,#0]
	LDR 	R0,=UART0_BASE
	MOVS	R1,#UART0_BDH_19200
	STRB	R1,[R0,#UART0_BDH_OFFSET]
	MOVS	R1,#UART0_BDL_19200
	STRB	R1,[R0,#UART0_BDL_OFFSET]
	MOVS	R1,#UART0_C1_8N1
	STRB	R1,[R0,#UART0_C1_OFFSET]
	MOVS	R1,#UART0_C3_NO_TXINV
	STRB	R1,[R0,#UART0_C3_OFFSET]
	MOVS	R1,#UART0_C4_NO_MATCH_OSR_16
	STRB	R1,[R0,#UART0_C4_OFFSET]
	MOVS	R1,#UART0_C5_NO_DMA_SSR_SYNC
	STRB	R1,[R0,#UART0_C5_OFFSET]
	MOVS	R1,#UART0_S1_CLEAR_FLAGS
	STRB	R1,[R0,#UART0_S1_OFFSET]
	MOVS	R1,#UART0_S2_NO_RXINV_BRK10_NO_LBKDETECT_CLEAR_FLAGS
	STRB	R1,[R0,#UART0_S2_OFFSET]
	MOVS	R1,#UART0_C2_T_RI
	STRB	R1,[R0,#UART0_C2_OFFSET]
	POP 	{R0-R3,PC}
	BX  	LR
	ENDP


	ALIGN

;------------------------------
; Interrupt Vector Table
;------------------------------
	AREA	PAGES_Reset,DATA,READONLY
	EXPORT	__Vectors
	EXPORT	__Vectors_End
	EXPORT	__Vectors_Size
	IMPORT	__initial_sp
	IMPORT	Dummy_Handler
	IMPORT	HardFault_Handler
__Vectors					;ARM core vectors
	DCD __initial_sp		;00:end of stack
	DCD Reset_Handler		;01:reset vector
	DCD Dummy_Handler		;02:NMI
	DCD HardFault_Handler	;03:hard fault
	DCD Dummy_Handler		;04:(reserved)
	DCD Dummy_Handler		;05:(reserved)
	DCD Dummy_Handler		;06:(reserved)
	DCD Dummy_Handler		;07:(reserved)
	DCD Dummy_Handler		;08:(reserved)
	DCD Dummy_Handler		;09:(reserved)
	DCD Dummy_Handler		;10:(reserved)
	DCD Dummy_Handler		;11:SVCall (supervisor call)
	DCD Dummy_Handler		;12:(reserved)
	DCD Dummy_Handler		;13:(reserved)
	DCD Dummy_Handler		;14:PendableSrvReq (pendable request for system service)
	DCD Dummy_Handler		;15:SysTick (system tick timer)
	DCD Dummy_Handler		;16:DMA channel 0 xfer complete/error
	DCD Dummy_Handler		;17:DMA channel 1 xfer complete/error
	DCD Dummy_Handler		;18:DMA channel 2 xfer complete/error
	DCD Dummy_Handler		;19:DMA channel 3 xfer complete/error
	DCD Dummy_Handler		;20:(reserved)
	DCD Dummy_Handler		;21:command complete; read collision
	DCD Dummy_Handler		;22:low-voltage detect; low-voltage warning
	DCD Dummy_Handler		;23:low leakage wakeup
	DCD Dummy_Handler		;24:I2C0
	DCD Dummy_Handler		;25:I2C1
	DCD Dummy_Handler		;26:SPI0 (all IRQ sources)
	DCD Dummy_Handler		;27:SPI1 (all IRQ sources)
	DCD UART0_ISR			;28:UART0 (status; error)
	DCD Dummy_Handler		;29:UART1 (status; error)
	DCD Dummy_Handler		;30:UART2 (status; error)
	DCD Dummy_Handler		;31:ADC0
	DCD Dummy_Handler		;32:CMP0
	DCD Dummy_Handler		;33:TPM0
	DCD Dummy_Handler		;34:TPM1
	DCD Dummy_Handler		;35:TPM2
	DCD Dummy_Handler		;36:RTC (alarm)
	DCD Dummy_Handler		;37:RTC (seconds)
	DCD PIT_ISR				;38:PIT (all IRQ sources)
	DCD Dummy_Handler		;39:I2S0
	DCD Dummy_Handler		;40:USB0
	DCD Dummy_Handler		;41:DAC0
	DCD Dummy_Handler		;42:TSI0
	DCD Dummy_Handler		;43:MCG
	DCD Dummy_Handler		;44:LPTMR0
	DCD Dummy_Handler		;45:Segment LCD
	DCD Dummy_Handler		;46:PORTA pin detect
	DCD Dummy_Handler		;47:PORTC and PORTD pin detect
__Vectors_End
__Vectors_Size EQU __Vectors_End - __Vectors
	ALIGN

;------------------------------
; Constants
;------------------------------
	AREA	PAGES_Constants,DATA,READONLY
	INCLUDE	Constants.s
	ALIGN

;------------------------------
; Variables
;------------------------------
	AREA	PAGES_Variables,DATA,READWRITE	
RxQRecord SPACE REC_SIZE
RxQBuffer SPACE RxQ_SIZE
	ALIGN
TxQRecord SPACE REC_SIZE
TxQBuffer SPACE TxQ_SIZE
	ALIGN
counter SPACE 4
timer SPACE 1
	ALIGN
	INCLUDE	Variables.s
	ALIGN
	END
