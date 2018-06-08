            TTL KL46Z Hard Fault LCD Display
;****************************************************************
;HardFault_Handler displays lower halfword of address that caused
;hard fault on LCD.
;Name:  R. W. Melton
;Date:  September 25, 2017
;****************************************************************
;Assembler directives
            THUMB
            OPT    64  ;Turn on listing macro expansions
;****************************************************************
;Include files
            GET  MKL46Z4.s     ;Included by start.s
            OPT  1   ;Turn on listing
;****************************************************************
;EQUates
;KL46 SLCD Module
LCD_AR_NORMAL_NO_BLINK               EQU  0x00
;LCD_BPEN0:
;  pins 18 and 19
;    3         2         1
;  120987654321098765432109876543210
;2_000000000000011000000000000000000
;0x   0   0    0   C   0   0   0   0
LCD_BPEN0_19_18                      EQU  0x000C0000
;LCD_BPEN1:
;  pins 52 and 40
;      6         5         4       3
;  321209876543210987654321098765432
;2_000000000000100000000000100000000
;0x   0   0    1   0   0   1   0   0
LCD_BPEN1_52_40                      EQU  0x00100100
LCD_FDCR_NO_FAULT_DETECTION          EQU  0x0000
;LCD_PEN0:
;  pins 7, 8, 10, 11, 17, 18, and 19
;    3         2         1
;  120987654321098765432109876543210
;2_000000000000011100000110110000000
;0x   0   0    0   E   0   D   8   0
LCD_PEN0_19_18_17_11_10_8_7          EQU  0x000E0D80
;LCD_PEN1:
;  pins 37, 38, 40, 52, and 53
;      6         5         4       3
;  321209876543210987654321098765432
;2_000000000001100000000000101100000
;0x   0   0    3   0   0   1   6   0
LCD_PEN1_53_52_40_38_37              EQU  0x00300160
;---------------------------------------------------------------
;FRDM-KL46Z LUMEX LCD S401M16KR
;SLCD pin connections
;  Backplane
;    COM0 pin 1:   PTD0 Alt0=LCD_P40
LCD_PIN_1  EQU  40
;    COM1 pin 2:   PTE4 Alt0=LCD_P52
LCD_PIN_2  EQU  52
;    COM2 pin 3:   PTB23 Alt0=LCD_P19
LCD_PIN_3  EQU  19
;    COM3 pin 4:   PTB22 Alt0=LCD_P18
LCD_PIN_4  EQU  18
;  Frontplane
;    DIG1 pin 5:   PTC17 Alt0=LCD_P37
LCD_DIG1_PIN1  EQU  37
LCD_PIN_5      EQU  37
;    DIG1 pin 6:   PTB21 Alt0=LCD_P17
LCD_DIG1_PIN2  EQU  17
LCD_PIN_6      EQU  17
;    DIG2 pin 7:   PTB7 Alt0=LCD_P7
LCD_DIG2_PIN1  EQU  7
LCD_PIN_7      EQU  7
;    DIG2 pin 8:   PTB8 Alt0=LCD_P8
LCD_DIG2_PIN2  EQU  8
LCD_PIN_8      EQU  8
;    DIG3 pin 9:   PTE5 Alt0=LCD_P53
LCD_DIG3_PIN1  EQU  53
LCD_PIN_9      EQU  53
;    DIG3 pin 10:  PTC18 Alt0=LCD_P38
LCD_DIG3_PIN2  EQU  38
LCD_PIN_10     EQU  38
;    DIG4 pin 11:  PTB10 Alt0=LCD_P10
LCD_DIG4_PIN1  EQU  10
LCD_PIN_11     EQU  10
;    DIG4 pin 12:  PTB11 Alt0=LCD_P11
LCD_DIG4_PIN2  EQU  11
LCD_PIN_12     EQU  11
;All digit segments:  DIG1-DIG4
;  A
;F   B
;  G
;E   C
;  D
;  First register phases
LCD_SEG_D  EQU  0x11
LCD_SEG_E  EQU  0x22
LCD_SEG_G  EQU  0x44
LCD_SEG_F  EQU  0x88
;  Second register phases
LCD_SEG_C  EQU  0x22
LCD_SEG_B  EQU  0x44
LCD_SEG_A  EQU  0x88
;DIG1-DIG3 decimal point to right
;  Second register
LCD_SEG_DECIMAL  EQU  0x11
;"DIG4" colon between DIG2 and DIG3
;  DIG4 Second register
LCD_SEG_COLON  EQU  0x11
LCD_CLEAR  EQU  0x00
;****************************************************************
;Program
;Linker requires Reset_Handler
            AREA    HardFaultLCD,CODE,READONLY
            EXPORT  HardFault_Handler
HardFault_Handler   PROC  {},{}
;****************************************************************
;HardFault_Handler displays lower halfword of address that caused
;hard fault on LCD.
;Calls:  InitLCD
;        LCD_PutHex
;****************************************************************
;Mask interrupts
            CPSID   I
;Initialize LCD for output of exception address
            BL      InitLCD
;Display exception address
            MOV     R0, SP
            LDRH    R0,[R0,#24]      ;LSH of 7th word on stack
            BL      LCD_PutHex
;Stay here
            B       .
            ENDP
;---------------------------------------------------------------
            EXPORT  InitLCD
InitLCD     PROC  {R0-R14},{}
;****************************************************************
;Enables segment LCD (SLCD) display using the following ports:
;  COM0 pin 1:   PTD0 Alt0=LCD_P40
;  COM1 pin 2:   PTE4 Alt0=LCD_P52
;  COM2 pin 3:   PTB23 Alt0=LCD_P19
;  COM3 pin 4:   PTB22 Alt0=LCD_P18
;  DIG1 pin 5:   PTC17 Alt0=LCD_P37
;  DIG1 pin 6:   PTB21 Alt0=LCD_P17
;  DIG2 pin 7:   PTB7 Alt0=LCD_P7
;  DIG2 pin 8:   PTB8 Alt0=LCD_P8
;  DIG3 pin 9:   PTE5 Alt0=LCD_P53
;  DIG3 pin 10:  PTC18 Alt0=LCD_P38
;  DIG4 pin 11:  PTB10 Alt0=LCD_P10
;  DIG4 pin 12:  PTB11 Alt0=LCD_P11
;Input:  None
;Output:  None
;Modifies:  PSR
;****************************************************************
            ;Preserve registers used
            PUSH    {R0-R7}
            ;Select 32-kHz clock for SLCD
            LDR     R0,=SIM_SOPT1
            LDR     R1,=SIM_SOPT1_OSC32KSEL_MASK
            LDR     R2,[R0,#0]
            BICS    R2,R2,R1
            STR     R2,[R0,#0]
            ;Enable SLCD and PORTs B, C, D, and E module clocks
            LDR     R0,=SIM_SCGC5
            LDR     R1,=(SIM_SCGC5_SLCD_MASK :OR: \
                         SIM_SCGC5_PORTB_MASK :OR: \
                         SIM_SCGC5_PORTC_MASK :OR: \
                         SIM_SCGC5_PORTD_MASK :OR: \
                         SIM_SCGC5_PORTE_MASK)
            LDR     R2,[R0,#0]
            ORRS    R2,R2,R1
            STR     R2,[R0,#0]
            ;Select PORT B Pin 7 for SLCD pin 7 (MUX select 0)
            LDR     R0,=PORTB_BASE
            LDR     R1,=(PORT_PCR_ISF_MASK :OR: \
                         PORT_PCR_MUX_SELECT_0_MASK)
            STR     R1,[R0,#PORTB_PCR7_OFFSET]
            ;Select PORT B Pin 8 for SLCD pin 8 (MUX select 0)
            STR     R1,[R0,#PORTB_PCR8_OFFSET]
            ;Select PORT B Pin 10 for SLCD pin 11 (MUX select 0)
            STR     R1,[R0,#PORTB_PCR10_OFFSET]
            ;Select PORT B Pin 11 for SLCD pin 12 (MUX select 0)
            STR     R1,[R0,#PORTB_PCR11_OFFSET]
            ;Select PORT B Pin 21 for SLCD pin 6 (MUX select 0)
            STR     R1,[R0,#PORTB_PCR21_OFFSET]
            ;Select PORT B Pin 22 for SLCD pin 4 (MUX select 0)
            STR     R1,[R0,#PORTB_PCR22_OFFSET]
            ;Select PORT B Pin 23 for SLCD pin 3 (MUX select 0)
            STR     R1,[R0,#PORTB_PCR23_OFFSET]
            ;Select PORT C Pin 17 for SLCD pin 5 (MUX select 0)
            LDR     R0,=PORTC_BASE
            STR     R1,[R0,#PORTC_PCR17_OFFSET]
            ;Select PORT C Pin 18 for SLCD pin 10 (MUX select 0)
            STR     R1,[R0,#PORTC_PCR18_OFFSET]
            ;Select PORT D Pin 0 for SLCD pin 1 (MUX select 0)
            LDR     R0,=PORTD_BASE
            STR     R1,[R0,#PORTD_PCR0_OFFSET]
            ;Select PORT E Pin 4 for SLCD pin 2 (MUX select 0)
            LDR     R0,=PORTE_BASE
            STR     R1,[R0,#PORTE_PCR4_OFFSET]
            ;Select PORT E Pin 5 for SLCD pin 9 (MUX select 0)
            STR     R1,[R0,#PORTE_PCR4_OFFSET]
            ;Disable SLCD
            LDR     R0,=LCD_BASE
            MOVS    R1,#LCD_GCR_LCDEN_MASK
            LDR     R2,[R0,#LCD_GCR_OFFSET]
            BICS    R2,R2,R1
            STR     R2,[R0,#LCD_GCR_OFFSET]
            ;Set SLCD for charge pump, high capacitance,
            ;  pad safe, 32-kHz internal clock (MCGIRCLK),
            ;  and 32-Hz frame frequency
            ;LCD_GCR:  CPSEL=1; LADJ=3; PADSAFE=1; FFR=1; SOURCE=1;
            ;          LCLK=4;DUTY=3
            LDR     R1,=(LCD_GCR_CPSEL_MASK :OR: \
                         (3 << LCD_GCR_LADJ_SHIFT) :OR: \
                         LCD_GCR_PADSAFE_MASK :OR: \
                         LCD_GCR_FFR_MASK :OR: \
                         LCD_GCR_SOURCE_MASK :OR: \
                         (4 << LCD_GCR_LCLK_SHIFT) :OR \
                         (3 << LCD_GCR_DUTY_SHIFT))
            STR     R1,[R0,#LCD_GCR_OFFSET]
            ;Set SLCD for no blink
            MOVS    R1,#LCD_AR_NORMAL_NO_BLINK
            STR     R1,[R0,#LCD_AR_OFFSET]
            ;Set SLCD for no fault detection
            LDR     R1,=LCD_FDCR_NO_FAULT_DETECTION 
            STR     R1,[R0,#LCD_FDCR_OFFSET]
            ;Enable pins 7, 8, 10, 11, 17, 18, and 19
            ;Enable pins 37, 38, 40, 52, and 53
            LDR     R1,=LCD_PEN0_19_18_17_11_10_8_7
            LDR     R2,=LCD_PEN1_53_52_40_38_37
            STR     R1,[R0,#LCD_PENL_OFFSET]
            STR     R2,[R0,#LCD_PENH_OFFSET]
            ;Enable backplane for COM0-COM3 
            ;  pins 18, 19, 40, and 52
            LDR     R1,=LCD_BPEN0_19_18
            LDR     R2,=LCD_BPEN1_52_40
            STR     R1,[R0,#LCD_BPENL_OFFSET]
            STR     R2,[R0,#LCD_BPENH_OFFSET]
            ;Configure waveform registers (64 bytes = 16 words = 4 quadwords)
            LDR     R1,=LCD_WF            ;LCD_WF_Quadword_Ptr
            LDR     R2,=LCD_WF_Config     ;LCD_WF_Config_QuadwordPtr
            MOVS    R3,#4                 ;LCV = 4
InitLCD_WF_Repeat                         ;repeat {
            LDM     R2!,{R4-R7}           ;  *LCD_WF_Quadword_Ptr++ =
            STM     R1!,{R4-R7}           ;    *LCD_WF_Config_Quadword_Ptr++
            SUBS    R3,#1                 ;  LCV--
            BNE     InitLCD_WF_Repeat     ;} until (LCV == 0)
            ;Disable SCLD padsafe and enable SLCD
            MOVS    R1,#LCD_GCR_LCDEN_MASK
            LDR     R2,[R0,#LCD_GCR_OFFSET]
            LDR     R3,=LCD_GCR_PADSAFE_MASK
            ORRS    R2,R2,R1
            BICS    R2,R2,R3
            STR     R2,[R0,#LCD_GCR_OFFSET]
            ;Restore registers used
            POP     {R0-R7}
            BX      LR
            ENDP
            ALIGN
LCD_WF_Config
;Each pin:  2_HGFEDCBA phase enable
            DCB  0x00  ;Pin0
            DCB  0x00  ;Pin1
            DCB  0x00  ;Pin2
            DCB  0x00  ;Pin3
            DCB  0x00  ;Pin4
            DCB  0x00  ;Pin5
            DCB  0x00  ;Pin6
            DCB  0x00  ;Pin7
            DCB  0x00  ;Pin8
            DCB  0x00  ;Pin9
            DCB  0x00  ;Pin10
            DCB  0x00  ;Pin11
            DCB  0x00  ;Pin12
            DCB  0x00  ;Pin13
            DCB  0x00  ;Pin14
            DCB  0x00  ;Pin15
            DCB  0x00  ;Pin16
            DCB  0x00  ;Pin17
            DCB  (LCD_WF_D_MASK :OR: LCD_WF_H_MASK)  ;Pin18=COM3:D,H
            DCB  (LCD_WF_C_MASK :OR: LCD_WF_G_MASK)  ;Pin19=COM2:C,G
            DCB  0x00  ;Pin20
            DCB  0x00  ;Pin21
            DCB  0x00  ;Pin22
            DCB  0x00  ;Pin23
            DCB  0x00  ;Pin24
            DCB  0x00  ;Pin25
            DCB  0x00  ;Pin26
            DCB  0x00  ;Pin27
            DCB  0x00  ;Pin28
            DCB  0x00  ;Pin29
            DCB  0x00  ;Pin30
            DCB  0x00  ;Pin31
            DCB  0x00  ;Pin32
            DCB  0x00  ;Pin33
            DCB  0x00  ;Pin34
            DCB  0x00  ;Pin35
            DCB  0x00  ;Pin36
            DCB  0x00  ;Pin37
            DCB  0x00  ;Pin38
            DCB  0x00  ;Pin39
            DCB  (LCD_WF_A_MASK :OR: LCD_WF_E_MASK)  ;Pin40=COM0:A,E
            DCB  0x00  ;Pin41
            DCB  0x00  ;Pin42
            DCB  0x00  ;Pin43
            DCB  0x00  ;Pin44
            DCB  0x00  ;Pin45
            DCB  0x00  ;Pin46
            DCB  0x00  ;Pin47
            DCB  0x00  ;Pin48
            DCB  0x00  ;Pin49
            DCB  0x00  ;Pin50
            DCB  0x00  ;Pin51
            DCB  (LCD_WF_B_MASK :OR: LCD_WF_F_MASK)  ;Pin52=COM1:B,F
            DCB  0x00  ;Pin53
            DCB  0x00  ;Pin54
            DCB  0x00  ;Pin55
            DCB  0x00  ;Pin56
            DCB  0x00  ;Pin57
            DCB  0x00  ;Pin58
            DCB  0x00  ;Pin59
            DCB  0x00  ;Pin60
            DCB  0x00  ;Pin61
            DCB  0x00  ;Pin62
            DCB  0x00  ;Pin63
            ALIGN
;---------------------------------------------------------------
            EXPORT  LCD_PutHex
LCD_PutHex  PROC  {R0-R14},{}
;****************************************************************
;Displays 4-digit hex value of least halfword in R0 on LCD
;Input:  R0:  Halfword value to display
;Output:  None
;Modifies:  PSR
;****************************************************************
;R0:value to display
;R1:nibble mask
;R2:1)bit shift amount
;   2)working copy of value to display
;R3:loop counter variable
;R4:base address of LCD digit segment setting array
;R5:digit setment settings
;R6:pointer to array of WF addresses for LCD pins
;R7:WF address for current LCD pin
            PUSH  {R1-R7}
            MOVS  R3,#4       ;Digits = 4
            LDR   R6,=LCD_WF_FRONTPLANE_PINS
            LDR   R4,=LCD_DIGITS
            MOVS  R2,#12      ;Bit offset of most significant nibble
            MOVS  R1,#0xF     ;Least nibble mask
LCD_PutHex_Repeat             ;repeat {
            RORS  R0,R0,R2    ;  NextMSN moved to LSN
            MOV   R2,R0       ;  Working copy of value
            ANDS  R2,R2,R1    ;  Nibble value
            LSLS  R2,R2,#1    ;  Halfword array index --> Byte array index
            LDRB  R5,[R4,R2]  ;  Digit pin 1 segment value
            LDM   R6!,{R7}    ;  Address of digit pin1's WF register
            ADDS  R2,R2,#1    ;  Next byte index
            STRB  R5,[R7,#0]  ;  Write to LCD_WF[LCD_DIGn_PIN1]
            LDM   R6!,{R7}    ;  Address of digit pin2's WF register
            LDRB  R5,[R4,R2]  ;  Digit pin 2 segment value
            STRB  R5,[R7,#0]  ;  Write to LCD_WF[LCD_DIGn_PIN2]
            MOVS  R2,#28      ;  Bit offset of next most significant nibble
            SUBS  R3,R3,#1    ;  Digits--
                              ;} until (Digits == 0)
            BNE   LCD_PutHex_Repeat
            POP   {R1-R7}
            BX    LR
            ENDP
            ALIGN
;---------------------------------------------------------------
;SLCD pin connections
LCD_WF_Pins
LCD_WF_BACKPLANE_PINS
           DCD  (LCD_WF + LCD_PIN_1)
           DCD  (LCD_WF + LCD_PIN_2)
           DCD  (LCD_WF + LCD_PIN_3)
           DCD  (LCD_WF + LCD_PIN_4)
LCD_WF_FRONTPLANE_PINS
LCD_WF_FRONTPLANE_PINS_DIG1
           DCD  (LCD_WF + LCD_PIN_5)
           DCD  (LCD_WF + LCD_PIN_6)
LCD_WF_FRONTPLANE_PINS_DIG2
           DCD  (LCD_WF + LCD_PIN_7)
           DCD  (LCD_WF + LCD_PIN_8)
LCD_WF_FRONTPLANE_PINS_DIG3
           DCD  (LCD_WF + LCD_PIN_9)
           DCD  (LCD_WF + LCD_PIN_10)
LCD_WF_FRONTPLANE_PINS_DIG4
           DCD  (LCD_WF + LCD_PIN_11)
           DCD  (LCD_WF + LCD_PIN_12)
;---------------------------------------------------------------
;LCD segments
;  A
;F   B
;  G
;E   C
;  D
LCD_DIGITS
LCD_0
LCD_0_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_E :OR: LCD_SEG_F)
LCD_0_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_B :OR: LCD_SEG_C)
LCD_1
LCD_1_PIN1   DCB  LCD_CLEAR
LCD_1_PIN2   DCB  (LCD_SEG_B :OR: LCD_SEG_C)
LCD_2
LCD_2_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_E :OR: LCD_SEG_G)
LCD_2_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_B)
LCD_3
LCD_3_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_G)
LCD_3_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_B :OR: LCD_SEG_C)
LCD_4
LCD_4_PIN1   DCB  (LCD_SEG_F :OR: LCD_SEG_G)
LCD_4_PIN2   DCB  (LCD_SEG_B :OR: LCD_SEG_C)
LCD_5
LCD_5_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_F :OR: LCD_SEG_G)
LCD_5_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_C)
LCD_6
LCD_6_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_E :OR: LCD_SEG_F :OR: LCD_SEG_G)
LCD_6_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_C)
LCD_7
LCD_7_PIN1   DCB  LCD_CLEAR
LCD_7_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_B :OR: LCD_SEG_C)
LCD_8
LCD_8_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_E :OR: LCD_SEG_F :OR: LCD_SEG_G)
LCD_8_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_B :OR: LCD_SEG_C)
LCD_9
LCD_9_PIN1   DCB  (LCD_SEG_F :OR: LCD_SEG_G)
LCD_9_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_B :OR: LCD_SEG_C)
LCD_A
LCD_A_PIN1   DCB  (LCD_SEG_E :OR: LCD_SEG_F :OR: LCD_SEG_G)
LCD_A_PIN2   DCB  (LCD_SEG_A :OR: LCD_SEG_B :OR: LCD_SEG_C)
LCD_B
LCD_B_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_E :OR: LCD_SEG_F :OR: LCD_SEG_G)
LCD_B_PIN2   DCB  LCD_SEG_C
LCD_C
LCD_C_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_E :OR: LCD_SEG_F)
LCD_C_PIN2   DCB  LCD_SEG_A
LCD_D
LCD_D_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_E :OR: LCD_SEG_G)
LCD_D_PIN2   DCB  (LCD_SEG_B :OR: LCD_SEG_C)
LCD_E
LCD_E_PIN1   DCB  (LCD_SEG_D :OR: LCD_SEG_E :OR: LCD_SEG_F :OR: LCD_SEG_G)
LCD_E_PIN2   DCB  LCD_SEG_A
LCD_F
LCD_F_PIN1   DCB  (LCD_SEG_E :OR: LCD_SEG_F :OR: LCD_SEG_G)
LCD_F_PIN2   DCB  LCD_SEG_A
            ALIGN
            END
