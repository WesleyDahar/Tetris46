            TTL KL46Z Bare Metal Assembly Startup
;****************************************************************
;* Flash configuration image for area at 0x400-0x40F(+)
;* SystemInit subroutine (++)
;* SetClock48MHz subroutine (+, +++)
;+:Following [3]
;++:Following [1].1.1.4.2 Startup routines and [2]
;+++:Following [1].4.1 Clocking
;[1] Freescale Semiconductor, <B>Kinetis L Peripheral Module Quick
;    Reference</B>, KLQRUG, Rev. 0, 9/2012.
;[2] ARM, <B>Application Note 48 Scatter Loading</B>, ARM DAI 0048A,
;    Jan. 1998
;[3] Freescale startup_MKL46Z4.s
;    Device specific configuration file for MKL46Z4
;    rev. 2.2, 4/12/2013
;Name:  R. W. Melton
;Date:  September 25, 2017
;****************************************************************
;Include files
;  MKL46Z4.s
            GET  MKL46Z4.s
            OPT  1   ;Turn on listing
;****************************************************************
            AREA    Start,CODE,READONLY
            EXPORT  Startup
;---------------------------------------------------------------
Startup     PROC    {},{}
;****************************************************************
;Performs the following startup tasks
;* System initialization
;* Mask interrupts
;* Configure 48-MHz system clock
;Calls:  SystemInit
;        SetClock48MHz
;Input:  None
;Output:  None
;Modifies:  R0-R15;APSR
;****************************************************************
;Save return address
            PUSH    {LR}
;Initialize system
            BL      SystemInit
;Mask interrupts
            CPSID   I
;Configure 48-MHz system clock
            BL      SetClock48MHz
;Return
            POP     {PC}
            ENDP
;---------------------------------------------------------------
SystemInit  PROC    {},{}
;****************************************************************
;Performs the following system initialization tasks.
;* Mask interrupts
;* Disable watchdog timer (+)
;* Load initial RAM image from end of loaded flash image (++) [2]
;* Initialize registers to known state for debugger
;+:Following [1].1.1.4.2 Startup routines: 1 Disable watchdog
;++:Step suggested [1].1.1.4.2 Startup routtines: 2 Initialize RAM
;[1] Freescale Semiconductor, <B>Kinetis L Peripheral Module Quick
;    Reference</B>, KLQRUG, Rev. 0, 9/2012.
;[2] ARM, <B>Application Note 48 Scatter Loading</B>, ARM DAI 0048A,
;    Jan. 1998
;Input:  None
;Output:  None
;Modifies:  R0-R15;APSR
;****************************************************************
;Mask interrupts
            CPSID   I
;Disable watchdog timer
;SIM_COPC:  COPT=0,COPCLKS=0,COPW=0
            LDR     R0,=SIM_COPC
            MOVS    R1,#0
            STR     R1,[R0,#0]
;Put return on stack
            PUSH    {LR}
;Initialize registers
            LDR     R1,=0x11111111
            ADDS    R2,R1,R1
            ADDS    R3,R2,R1
            ADDS    R4,R3,R1
            ADDS    R5,R4,R1
            ADDS    R6,R5,R1
            ADDS    R7,R6,R1
            ADDS    R0,R7,R1
            MOV     R8,R0
            ADDS    R0,R0,R1
            MOV     R9,R0
            ADDS    R0,R0,R1
            MOV     R10,R0
            ADDS    R0,R0,R1
            MOV     R11,R0
            ADDS    R0,R0,R1
            MOV     R12,R0
            ADDS    R0,R0,R1
            ADDS    R0,R0,R1
            MOV     R14,R0
            MOVS    R0,#0
            POP     {PC}
            ENDP
;---------------------------------------------------------------
SetClock48MHz  PROC  {R0-R14},{}
;****************************************************************
;Establishes 96-MHz PLL clock from 8-MHz external oscillator,
;with divide by 2 for core clock of 48-MHz.
;Follows [2] and [1].4.1 Clocking 3: Configuration examples
;[1] Freescale Semiconductor, <B>Kinetis L Peripheral Module Quick
;    Reference</B>, KLQRUG, Rev. 0, 9/2012.
;[3] Freescale startup_MKL46Z4.s
;    Device specific configuration file for MKL46Z4
;    rev. 2.2, 4/12/2013
;Input:  None
;Output:  None
;Modifies:  APSR
;****************************************************************
            PUSH    {R0-R3}
;Configure for external clock from external 8-MHz oscillator
;  EXTAL0 on PTA18
;  XTAL0 on PTA19
            ;Enable PORT A
            LDR      R0,=SIM_SCGC5
            LDR      R1,=SIM_SCGC5_PORTA_MASK
            LDR      R2,[R0,#0]
            ORRS     R2,R2,R1
            STR      R2,[R0,#0]
            ;Set PORT A Pin 18 for EXTAL0 (MUX select 0)
            LDR      R0,=PORTA_BASE
            LDR      R1,=(PORT_PCR_ISF_MASK :OR: \
                          PORT_PCR_MUX_SELECT_0_MASK)
            STR      R1,[R0,#PORTA_PCR18_OFFSET]
            ;Set PORT A Pin 19 for XTAL0 (MUX select 0)
            STR      R1,[R0,#PORTA_PCR19_OFFSET]
;Update system clock dividers to 2
;[1] defers this step until first part of switching to FEE mode
;  SIM_CLKDIV1: OUTDIV1=1,OUTDIV4=1
            LDR      R0,=SIM_CLKDIV1
            LDR      R1,=((1 << SIM_CLKDIV1_OUTDIV1_SHIFT) :OR: \
                          (1 << SIM_CLKDIV1_OUTDIV4_SHIFT))
            STR      R1,[R0,#0]
;------------------------------------------
;Establish FLL bypassed external mode (FBE)
;------------------------------------------
;First configure oscillator settings in MCG_C2
;  RANGE is determined from external frequency
;  Since RANGE affects FRDIV, it must be set
;  correctly even with an external clock
;  [3] (newer) indicates VHF RANGE=2,
;  whereas [1] indicates HF RANGE=1
;  Preserve existing FCFTRIM value
;  MCG_C2:  LOCRE0=0,RANGE0=2,HGO0=0,EREFS0=1,LP=0,IRCS=0
            LDR     R0,=MCG_BASE
            MOVS    R1,#((2 << MCG_C2_RANGE0_SHIFT) :OR: \
                         MCG_C2_EREFS0_MASK)
            LDRB    R2,[R0,#MCG_C2_OFFSET]
            MOVS    R3,#MCG_C2_FCFTRIM_MASK
            ANDS    R2,R2,R3
            ORRS    R1,R1,R2
            STRB    R1,[R0,#MCG_C2_OFFSET]
;Enable external reference clock OSCERCLK,
;and add 2 pF to oscillator load
;OSC0->CR:  ERCLKEN=1,EREFSTEN=0,SC2P=1,SC4P=0,SC8P=0,SC16P=0
            LDR     R2,=OSC0_CR
            MOVS    R1,#(OSC_CR_ERCLKEN_MASK :OR: \
                         OSC_CR_SC2P_MASK)
            STRB    R1,[R2,#0]
;FRDIV set to keep FLL ref clock within
;correct range, determined by ref clock.
;  For 8-MHz ref, need divide by 256 (FRDIV = 3)
;  CLKS must be set to 2_10 to select
;    external reference clock
;  Clearing IREFS selects and enables
;    external oscillator
;  [3] sets IRCLKEN for internal reference clock as MCGIRCLK
;  MCG_C1:  CLKS=2,FRDIV=3,IREFS=0,IRCLKEN=1,IREFSTEN=0
            MOVS    R1,#((2 << MCG_C1_CLKS_SHIFT) :OR: \
                         (3 << MCG_C1_FRDIV_SHIFT) :OR: \
                         MCG_C1_IRCLKEN_MASK)
            STRB    R1,[R0,#MCG_C1_OFFSET]
;[3] Ensure reset values for MCG_C4 DMX32 and DRST_DRS
;[1] omits this step
;Reference range:  31.25–39.0625 kHz
;FLL factor:  640
;DCO range:  20-25 MHz
;Preserve FCTRIM and SCFTRIM
;MCG_C4:  DMX32=0,DRST_DRS=0
            LDRB    R2,[R0,#MCG_C4_OFFSET]
            MOVS    R1,#(MCG_C4_DMX32_MASK :OR: \
                         MCG_C4_DRST_DRS_MASK)
            BICS    R2,R2,R1
            STRB    R2,[R0,#MCG_C4_OFFSET]
;[3] Disable PLL
;[1] omits this step
;[3] sets PRDIV0=1 here, whereas
;[1] waits until switch to PBE mode
;MCG_C5:  PLLCLKEN0=0,PLLSTEN0=0,PRDIV0=1
            MOVS    R1,#(1 << MCG_C5_PRDIV0_SHIFT)
            STRB    R1,[R0,#MCG_C5_OFFSET]
;[3] Select FLL
;[1] omits this step
;MCG_C6:  LOLIE0=0,PLLS=0,CME0=0,VDIV0=0
            MOVS    R1,#0
            STRB    R1,[R0,#MCG_C6_OFFSET]
;Wait for oscillator initialization cycles
;to complete
;[3] omits this step
;(MCG_S:  OSCINIT0 becomes 1)
            MOVS    R1,#MCG_S_OSCINIT0_MASK
__MCG_Wait_OSCINIT0
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BEQ     __MCG_Wait_OSCINIT0
;Wait for source of the FLL reference clock 
;to be the external reference clock.
;(MCG_S:  IREFST becomes 0)
            MOVS    R1,#MCG_S_IREFST_MASK
__MCG_Wait_IREFST_Clear
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BNE     __MCG_Wait_IREFST_Clear
;Wait for clock status to show
;external reference clock source selected
;(MCG_S:  CLKST becomes 2_10)
            MOVS    R1,#MCG_S_CLKST_MASK
__MCG_Wait_CLKST_EXT
            LDRB    R2,[R0,#MCG_S_OFFSET]
            ANDS    R2,R2,R1
            CMP     R2,#(2 << MCG_S_CLKST_SHIFT)
            BNE     __MCG_Wait_CLKST_EXT

;[1] enables clock monitor here MCG_C6:CME0
;[3] does not enable clock monitor here
;    and it was disabled above
;Not enabling here

;-----------------------------------------------
;Switch to PLL bypassed external mode (PBE mode)
;-----------------------------------------------
;[1] sets MCG_C5 PRDIV0 = 1 here
;[3] already set MCG_C5 PRDIV0 = 1 above
;Already set above

;Set PLL multiplier and enable PLL
;  PLL multiplier = 24 = VDIV0 + 24
;MCG_C6: LOLIE0=0,PLLS=1,CME0=0,VDIV0=0
            MOVS    R1,#MCG_C6_PLLS_MASK
            STRB    R1,[R0,#MCG_C6_OFFSET]

;Wait for clock status to show
;external reference clock source selected
;[1] omits this step
;(MCG_S:  CLKST becomes 2_10)
            MOVS    R1,#MCG_S_CLKST_MASK
__MCG_Wait_2_CLKST_EXT
            LDRB    R2,[R0,#MCG_S_OFFSET]
            ANDS    R2,R2,R1
            CMP     R2,#(2 << MCG_S_CLKST_SHIFT)
            BNE     __MCG_Wait_2_CLKST_EXT
;Wait for PLL select status to show
;PLL as source of PLLS
;(MCG_S:  PLLST becomes 1)
            MOVS    R1,#MCG_S_PLLST_MASK
__MCG_Wait_PLLST
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BEQ     __MCG_Wait_PLLST
;Wait for PLL lock
;(MCG_S:  LOCK0 becomes 1)
            MOVS    R1,#MCG_S_LOCK0_MASK
__MCG_Wait_LOCK0
            LDRB    R2,[R0,#MCG_S_OFFSET]
            TST     R1,R2
            BEQ     __MCG_Wait_LOCK0

;----------------------------------------------
;Switch to PLL engaged external mode (PEE mode)
;----------------------------------------------
;[1] sets system clock dividers to 2 here
;[3] already set above
;Already set

;Select PLL as MCGCLKOUT
;FRDIV set to keep FLL ref clock within
;correct range, determined by ref clock.
;  For 8-MHz ref, need divide by 256 (FRDIV = 3)
;  CLKS must be set to 0_10 to select PLL
;  Clearing IREFS selects and enables
;    external oscillator
;  [3] sets IRCLKEN for internal reference clock as MCGIRCLK
;  MCG_C1:  CLKS=0,FRDIV=3,IREFS=0,IRCLKEN=1,IREFSTEN=0
            MOVS    R1,#((3 << MCG_C1_FRDIV_SHIFT) :OR: \
                         MCG_C1_IRCLKEN_MASK)
            STRB    R1,[R0,#MCG_C1_OFFSET]
;Wait for clock status to show PLL clock source
;(MCG_S:  CLKST becomes 2_11)
            MOVS    R1,#MCG_S_CLKST_MASK
__MCG_Wait_CLKST_PLL
            LDRB    R2,[R0,#MCG_S_OFFSET]
            ANDS    R2,R2,R1
            CMP     R2,#MCG_S_CLKST_MASK
            BNE     __MCG_Wait_CLKST_PLL
;Now have 96-MHz PLL clock and
;48-MHz core clock
            POP     {R0-R3}
            BX      LR
            ENDP
;****************************************************************
            ALIGN
;Program template for CMPE-250 uses main as "Reset_Handler"
;           EXPORT  Reset_Handler
;****************************************************************
;Goto main
;****************************************************************
;           LDR     R0,=main
;           BX      R0
            EXPORT  Dummy_Handler
            EXPORT  HardFault_Handler  [WEAK]
Dummy_Handler  PROC  {},{}
HardFault_Handler
;****************************************************************
;Dummy exception handler (infinite loop)
;****************************************************************
            B       .
            ENDP
;---------------------------------------------------------------
            ALIGN
;****************************************************************
            AREA    |.ARM.__at_0xC0|,DATA,NOALLOC,READONLY
;Program once field:  0xC0-0xFF
            SPACE   0x40
;****************************************************************
            IF      :LNOT::DEF:RAM_TARGET
            AREA    |.ARM.__at_0x400|,CODE,READONLY
            DCB     FCF_BACKDOOR_KEY0,FCF_BACKDOOR_KEY1
            DCB     FCF_BACKDOOR_KEY2,FCF_BACKDOOR_KEY3
            DCB     FCF_BACKDOOR_KEY4,FCF_BACKDOOR_KEY5
            DCB     FCF_BACKDOOR_KEY6,FCF_BACKDOOR_KEY7
            DCB     FCF_FPROT0,FCF_FPROT1,FCF_FPROT2,FCF_FPROT3
            DCB     FCF_FSEC,FCF_FOPT,0xFF,0xFF
            ENDIF
;****************************************************************
            AREA    |.ARM.__at_0x1FFFE000|,DATA,READWRITE,ALIGN=3
            EXPORT  __initial_sp
;Allocate system stack
            IF      :LNOT::DEF:SSTACK_SIZE
SSTACK_SIZE EQU     0x00000100
            ENDIF
Stack_Mem   SPACE   SSTACK_SIZE
__initial_sp
;****************************************************************
            END
