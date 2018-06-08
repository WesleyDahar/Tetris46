            OPT   2   ;Turn off listing
            IF    :DEF:MIXED_ASM_C
            PRESERVE8
            ELSE
            PRESERVE8   {FALSE}
            ENDIF
;**********************************************************************
;Freescale MKL46Z256xxx4 device values and configuration code
;* Various EQUATES for memory map
;[1] Freescale Semiconductor, <B>Kinetis L Peripheral Module Quick
;    Reference</B>, KLQRUG, Rev. 0, 9/2012.
;[2] ARM, <B>Application Note 48 Scatter Loading</B>, ARM DAI 0048A,
;    Jan. 1998
;[3] Freescale Semiconductor, <B>KL46 Sub-Family Reference Manual</B>,
;    KL46P121M48SF4RM, Rev. 3, 7/2013.
;[4] Freescale Semiconductor, MKL46Z4.h, rev. 2.2, 4/12/2013
;---------------------------------------------------------------
;Author:  R. W. Melton
;Date:  September 25, 2017
;***************************************************************
;EQUates
;Standard data masks
BYTE_MASK         EQU  0xFF
NIBBLE_MASK       EQU  0x0F
;Standard data sizes (in bits)
BYTE_BITS         EQU  8
NIBBLE_BITS       EQU  4
;Architecture data sizes (in bytes)
WORD_SIZE         EQU  4  ;Cortex-M0+
HALFWORD_SIZE     EQU  2  ;Cortex-M0+
;Architecture data masks
HALFWORD_MASK     EQU  0xFFFF
;Return                 
RET_ADDR_T_MASK   EQU  1  ;Bit 0 of ret. addr. must be
                          ;set for BX, BLX, or POP
                          ;mask in thumb
;---------------------------------------------------------------
;Vectors
VECTOR_TABLE_SIZE EQU  0x000000C0  ;KL46
VECTOR_SIZE       EQU  4           ;Bytes per vector
;---------------------------------------------------------------
;CPU PSR:  Program status register
;Combined APSR, EPSR, and IPSR
;----------------------------------------------------------
;APSR:  Application Program Status Register
;31  :N=negative flag
;30  :Z=zero flag
;29  :C=carry flag
;28  :V=overflow flag
;27-0:(reserved)
APSR_MASK     EQU  0xF0000000
APSR_SHIFT    EQU  28
APSR_N_MASK   EQU  0x80000000
APSR_N_SHIFT  EQU  31
APSR_Z_MASK   EQU  0x40000000
APSR_Z_SHIFT  EQU  30
APSR_C_MASK   EQU  0x20000000
APSR_C_SHIFT  EQU  29
APSR_V_MASK   EQU  0x10000000
APSR_V_SHIFT  EQU  28
;----------------------------------------------------------
;EPSR
;31-25:(reserved)
;   24:T=thumb state bit
;23- 0:(reserved)
EPSR_MASK     EQU  0x01000000
EPSR_SHIFT    EQU  24
EPSR_T_MASK   EQU  0x01000000
EPSR_T_SHIFT  EQU  24
;----------------------------------------------------------
;IPSR
;31-6:(reserved)
; 5-0:Exception number=number of current exception
;      0=thread mode
;      1:(reserved)
;      2=NMI
;      3=hard fault
;      4-10:(reserved)
;     11=SVCall
;     12-13:(reserved)
;     14=PendSV
;     15=SysTick
;     16=IRQ0
;     16-47:IRQ(Exception number - 16)
;     47=IRQ31
;     48-63:(reserved)
IPSR_MASK             EQU  0x0000003F
IPSR_SHIFT            EQU  0
IPSR_EXCEPTION_MASK   EQU  0x0000003F
IPSR_EXCEPTION_SHIFT  EQU  0
;----------------------------------------------------------
PSR_N_MASK           EQU  APSR_N_MASK
PSR_N_SHIFT          EQU  APSR_N_SHIFT
PSR_Z_MASK           EQU  APSR_Z_MASK
PSR_Z_SHIFT          EQU  APSR_Z_SHIFT
PSR_C_MASK           EQU  APSR_C_MASK
PSR_C_SHIFT          EQU  APSR_C_SHIFT
PSR_V_MASK           EQU  APSR_V_MASK
PSR_V_SHIFT          EQU  APSR_V_SHIFT
PSR_T_MASK           EQU  EPSR_T_MASK
PSR_T_SHIFT          EQU  EPSR_T_SHIFT
PSR_EXCEPTION_MASK   EQU  IPSR_EXCEPTION_MASK
PSR_EXCEPTION_SHIFT  EQU  IPSR_EXCEPTION_SHIFT
;---------------------------------------------------------------
;Cortex-M0+ Core
__CM0PLUS_REV           EQU  0x0000  ;Core revision r0p0
__MPU_PRESENT           EQU  0       ;Whether MPU is present
__NVIC_PRIO_BITS        EQU  2       ;Number of NVIC priority bits
__Vendor_SysTickConfig  EQU  0       ;Whether vendor-specific 
                                     ;SysTickConfig is defined
__VTOR_PRESENT          EQU  1       ;Whether VTOR is present
;---------------------------------------------------------------
;Interrupt numbers
;Core interrupts
NonMaskableInt_IRQn  EQU  -14  ;Non-maskable interrupt (NMI)
HardFault_IRQn       EQU  -13  ;Hard fault interrupt
SVCall_IRQn          EQU  -5   ;Supervisor call interrupt (SVCall)
PendSV_IRQn          EQU  -2   ;Pendable request for system service interrupt
                               ;(PendableSrvReq)
SysTick_IRQn         EQU  -1   ;System tick timer interrupt (SysTick)
;--------------------------
;Device specific interrupts
DMA0_IRQn            EQU  0   ;DMA channel 0 transfer complete/error interrupt
DMA1_IRQn            EQU  1   ;DMA channel 1 transfer complete/error interrupt
DMA2_IRQn            EQU  2   ;DMA channel 2 transfer complete/error interrupt
DMA3_IRQn            EQU  3   ;DMA channel 3 transfer complete/error interrupt
Reserved20_IRQn      EQU  4   ;Reserved interrupt 20
FTFA_IRQn            EQU  5   ;FTFA command complete/read collision interrupt
LVD_LVW_IRQn         EQU  6   ;Low-voltage detect, low-voltage warning interrupt
LLW_IRQn             EQU  7   ;Low leakage wakeup interrupt
I2C0_IRQn            EQU  8   ;I2C0 interrupt
I2C1_IRQn            EQU  9   ;I2C1 interrupt
SPI0_IRQn            EQU  10  ;SPI0 interrupt
SPI1_IRQn            EQU  11  ;SPI1 interrupt
UART0_IRQn           EQU  12  ;UART0 status/error interrupt
UART1_IRQn           EQU  13  ;UART1 status/error interrupt
UART2_IRQn           EQU  14  ;UART2 status/error interrupt
ADC0_IRQn            EQU  15  ;ADC0 interrupt
CMP0_IRQn            EQU  16  ;CMP0 interrupt
TPM0_IRQn            EQU  17  ;TPM0 fault, overflow, and channels interrupt
TPM1_IRQn            EQU  18  ;TPM1 fault, overflow, and channels interrupt
TPM2_IRQn            EQU  19  ;TPM2 fault, overflow, and channels interrupt
RTC_IRQn             EQU  20  ;RTC alarm interrupt
RTC_Seconds_IRQn     EQU  21  ;RTC seconds interrupt
PIT_IRQn             EQU  22  ;PIT interrupt
I2S0_IRQn            EQU  23  ;I2S0 interrupt
USB0_IRQn            EQU  24  ;USB OTG interrupt
DAC0_IRQn            EQU  25  ;DAC0 interrupt
TSI0_IRQn            EQU  26  ;TSI0 interrupt
MCG_IRQn             EQU  27  ;MCG interrupt
LPTimer_IRQn         EQU  28  ;LPTMR0 interrupt
LCD_IRQn             EQU  29  ;SLCD interrupt
PORTA_IRQn           EQU  30  ;Port A pin detect interrupt
PORTC_PORTD_IRQn     EQU  31  ;Port C and Port D pin detectinterrupt
;---------------------------------------------------------------
;Memory map major version
;(Memory maps with equal major version number are compatible)
MCU_MEM_MAP_VERSION        EQU 0x0200
;Memory map minor version
MCU_MEM_MAP_VERSION_MINOR  EQU  0x0002
;---------------------------------------------------------------
;ADC
ADC0_BASE         EQU  0x4003B000
ADC_SC1A_OFFSET  EQU  0x00
ADC_SC1B_OFFSET  EQU  0x04
ADC_CFG1_OFFSET  EQU  0x08
ADC_CFG2_OFFSET  EQU  0x0C
ADC_RA_OFFSET    EQU  0x10
ADC_RB_OFFSET    EQU  0x14
ADC_CV1_OFFSET   EQU  0x18
ADC_CV2_OFFSET   EQU  0x1C
ADC_SC2_OFFSET   EQU  0x20
ADC_SC3_OFFSET   EQU  0x24
ADC_OFS_OFFSET   EQU  0x28
ADC_PG_OFFSET    EQU  0x2C
ADC_MG_OFFSET    EQU  0x30
ADC_CLPD_OFFSET  EQU  0x34
ADC_CLPS_OFFSET  EQU  0x38
ADC_CLP4_OFFSET  EQU  0x3C
ADC_CLP3_OFFSET  EQU  0x40
ADC_CLP2_OFFSET  EQU  0x44
ADC_CLP1_OFFSET  EQU  0x48
ADC_CLP0_OFFSET  EQU  0x4C
ADC_CLMD_OFFSET  EQU  0x54
ADC_CLMS_OFFSET  EQU  0x58
ADC_CLM4_OFFSET  EQU  0x5C
ADC_CLM3_OFFSET  EQU  0x60
ADC_CLM2_OFFSET  EQU  0x64
ADC_CLM1_OFFSET  EQU  0x68
ADC_CLM0_OFFSET  EQU  0x6C
ADC0_CFG1         EQU  ( ADC0_BASE + ADC_CFG1_OFFSET)
ADC0_CFG2         EQU  ( ADC0_BASE + ADC_CFG2_OFFSET)
ADC0_CLMD         EQU  ( ADC0_BASE + ADC_CLMD_OFFSET)
ADC0_CLMS         EQU  ( ADC0_BASE + ADC_CLMS_OFFSET)
ADC0_CLM0         EQU  ( ADC0_BASE + ADC_CLM0_OFFSET)
ADC0_CLM1         EQU  ( ADC0_BASE + ADC_CLM1_OFFSET)
ADC0_CLM2         EQU  ( ADC0_BASE + ADC_CLM2_OFFSET)
ADC0_CLM3         EQU  ( ADC0_BASE + ADC_CLM3_OFFSET)
ADC0_CLM4         EQU  ( ADC0_BASE + ADC_CLM4_OFFSET)
ADC0_CLPD         EQU  ( ADC0_BASE + ADC_CLPD_OFFSET)
ADC0_CLPS         EQU  ( ADC0_BASE + ADC_CLPS_OFFSET)
ADC0_CLP0         EQU  ( ADC0_BASE + ADC_CLP0_OFFSET)
ADC0_CLP1         EQU  ( ADC0_BASE + ADC_CLP1_OFFSET)
ADC0_CLP2         EQU  ( ADC0_BASE + ADC_CLP2_OFFSET)
ADC0_CLP3         EQU  ( ADC0_BASE + ADC_CLP3_OFFSET)
ADC0_CLP4         EQU  ( ADC0_BASE + ADC_CLP4_OFFSET)
ADC0_CV1          EQU  ( ADC0_BASE + ADC_CV1_OFFSET)
ADC0_CV2          EQU  ( ADC0_BASE + ADC_CV2_OFFSET)
ADC0_MG           EQU  ( ADC0_BASE + ADC_MG_OFFSET) 
ADC0_OFS          EQU  ( ADC0_BASE + ADC_OFS_OFFSET)
ADC0_PG           EQU  ( ADC0_BASE + ADC_PG_OFFSET) 
ADC0_RA           EQU  ( ADC0_BASE + ADC_RA_OFFSET)  
ADC0_RB           EQU  ( ADC0_BASE + ADC_RB_OFFSET)  
ADC0_SC1A         EQU  ( ADC0_BASE + ADC_SC1A_OFFSET)
ADC0_SC1B         EQU  ( ADC0_BASE + ADC_SC1B_OFFSET)
ADC0_SC2          EQU  ( ADC0_BASE + ADC_SC2_OFFSET)
ADC0_SC3          EQU  ( ADC0_BASE + ADC_SC3_OFFSET)
;---------------------------------------------------------------
;ADC_CFG1:  ADC configuration register 1
;31-8:(reserved):read-only:0
;   7:ADLPC=ADC low-power configuration
; 6-5:ADIV=ADC clock divide select
;     Internal ADC clock = input clock / 2^ADIV
;   4:ADLSMP=ADC long sample time configuration
;            0=short
;            1=long
; 3-2:MODE=conversion mode selection
;          00=(DIFF'):single-ended 8-bit conversion
;             (DIFF):differential 9-bit 2's complement conversion
;          01=(DIFF'):single-ended 12-bit conversion
;             (DIFF):differential 13-bit 2's complement conversion
;          10=(DIFF'):single-ended 10-bit conversion
;             (DIFF):differential 11-bit 2's complement conversion
;          11=(DIFF'):single-ended 16-bit conversion
;             (DIFF):differential 16-bit 2's complement conversion
; 1-0:ADICLK=ADC input clock select
;          00=bus clock
;          01=bus clock / 2
;          10=alternate clock (ALTCLK)
;          11=asynchronous clock (ADACK)
ADC_CFG1_ADLPC_MASK   EQU  0x80
ADC_CFG1_ADLPC_SHIFT  EQU  7
ADC_CFG1_ADIV_MASK    EQU  0x60
ADC_CFG1_ADIV_SHIFT   EQU  5
ADC_CFG1_ADLSMP_MASK  EQU  0x10
ADC_CFG1_ADLSMP_SHIFT EQU  4
ADC_CFG1_MODE_MASK    EQU  0x0C
ADC_CFG1_MODE_SHIFT   EQU  2
ADC_CFG1_ADICLK_MASK  EQU  0x03
ADC_CFG1_ADICLK_SHIFT EQU  0
;---------------------------------------------------------------
;ADC_CFG2:  ADC configuration register 2
;31-8:(reserved):read-only:0
; 7-5:(reserved):read-only:0
;   4:MUXSEL=ADC mux select
;            0=ADxxA channels are selected
;            1=ADxxB channels are selected
;   3:ADACKEN=ADC asynchronous clock output enable
;             0=asynchronous clock determined by ACD0_CFG1.ADICLK 
;             1=asynchronous clock enabled
;   2:ADHSC=ADC high-speed configuration
;           0=normal conversion
;           1=high-speed conversion (only 2 additional ADK cycles)
; 1-0:ADLSTS=ADC long sample time select (ADK cycles)
;          00=default longest sample time:  
;             24 total ADK cycles (20 extra)
;          01=16 total ADK cycles (12 extra)
;          10=10 total ADK cycles (6 extra)
;          11=6 total ADK cycles (2 extra)
ADC_CFG2_MUXSEL_MASK    EQU  0x10
ADC_CFG2_MUXSEL_SHIFT   EQU  4
ADC_CFG2_ADACKEN_MASK   EQU  0x08
ADC_CFG2_ADACKEN_SHIFT  EQU  3
ADC_CFG2_ADHSC_MASK     EQU  0x04
ADC_CFG2_ADHSC_SHIFT    EQU  2
ADC_CFG2_ADLSTS_MASK    EQU  0x03
ADC_CFG2_ADLSTS_SHIFT   EQU  0
;---------------------------------------------------------------
;ADC_CLMD:  ADC minus-side general calibration value register D
;31-6:(reserved):read-only:0
; 5-0:CLMD=calibration value
ADC_CLMD_MASK   EQU  0x3F
ADC_CLMD_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLMS:  ADC minus-side general calibration value register S
;31-6:(reserved):read-only:0
; 5-0:CLMS=calibration value
ADC_CLMS_MASK   EQU  0x3F
ADC_CLMS_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLM0:  ADC minus-side general calibration value register 0
;31-6:(reserved):read-only:0
; 5-0:CLM0=calibration value
ADC_CLM0_MASK   EQU  0x3F
ADC_CLM0_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLM1:  ADC minus-side general calibration value register 1
;31-7:(reserved):read-only:0
; 6-0:CLM1=calibration value
ADC_CLM1_MASK   EQU  0x7F
ADC_CLM1_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLM2:  ADC minus-side general calibration value register 2
;31-8:(reserved):read-only:0
; 7-0:CLM2=calibration value
ADC_CLM2_MASK   EQU  0xFF
ADC_CLM2_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLM3:  ADC minus-side general calibration value register 3
;31-9:(reserved):read-only:0
; 8-0:CLM3=calibration value
ADC_CLM3_MASK   EQU  0x1FF
ADC_CLM3_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLM4:  ADC minus-side general calibration value register 4
;31-10:(reserved):read-only:0
; 9- 0:CLM4=calibration value
ADC_CLM4_MASK   EQU  0x3FF
ADC_CLM4_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLPD:  ADC plus-side general calibration value register D
;31-6:(reserved):read-only:0
; 5-0:CLPD=calibration value
ADC_CLPD_MASK   EQU  0x3F
ADC_CLPD_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLPS:  ADC plus-side general calibration value register S
;31-6:(reserved):read-only:0
; 5-0:CLPS=calibration value
ADC_CLPS_MASK   EQU  0x3F
ADC_CLPS_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLP0:  ADC plus-side general calibration value register 0
;31-6:(reserved):read-only:0
; 5-0:CLP0=calibration value
ADC_CLP0_MASK   EQU  0x3F
ADC_CLP0_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLP1:  ADC plus-side general calibration value register 1
;31-7:(reserved):read-only:0
; 6-0:CLP1=calibration value
ADC_CLP1_MASK   EQU  0x7F
ADC_CLP1_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLP2:  ADC plus-side general calibration value register 2
;31-8:(reserved):read-only:0
; 7-0:CLP2=calibration value
ADC_CLP2_MASK   EQU  0xFF
ADC_CLP2_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLP3:  ADC plus-side general calibration value register 3
;31-9:(reserved):read-only:0
; 8-0:CLP3=calibration value
ADC_CLP3_MASK   EQU  0x1FF
ADC_CLP3_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CLP4:  ADC plus-side general calibration value register 4
;31-10:(reserved):read-only:0
; 9- 0:CLP4=calibration value
ADC_CLP4_MASK   EQU  0x3FF
ADC_CLP4_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_CVn:  ADC channel n compare value register
;CV1 used to compare result when ADC_SC2.ACFE=1
;CV2 used to compare result when ADC_SC2.ACREN=1
;31-16:(reserved):read-only:0
;15- 0:compare value (sign- or zero-extended if fewer than 16 bits)
ADC_CV_MASK   EQU  0xFFFF
ADC_CV_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_MG:  ADC minus-side gain register
;31-16:(reserved):read-only:0
;15- 0:MG=minus-side gain
ADC_MG_MASK   EQU  0xFFFF
ADC_MG_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_OFS:  ADC offset correction register
;31-16:(reserved):read-only:0
;15- 0:OFS=offset error correction value
ADC_OFS_MASK   EQU  0xFFFF
ADC_OFS_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_PG:  ADC plus-side gain register
;31-16:(reserved):read-only:0
;15- 0:PG=plus-side gain
ADC_PG_MASK   EQU  0xFFFF
ADC_PG_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_Rn:  ADC channel n data result register
;31-16:(reserved):read-only:0
;15- 0:data result (sign- or zero-extended if fewer than 16 bits)
ADC_D_MASK   EQU  0xFFFF
ADC_D_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_SC1n:  ADC channel n status and control register 1
;31-8:(reserved):read-only:0
;   7:COCO=conversion complete flag (read-only)
;   6:AIEN=ADC interrupt enabled
;   5:DIFF=differential mode enable
; 4-0:ADCH=ADC input channel select
;          00000=(DIFF'):DADP0;(DIFF):DAD0
;          00001=(DIFF'):DADP1;(DIFF):DAD1
;          00010=(DIFF'):DADP2;(DIFF):DAD2
;          00011=(DIFF'):DADP3;(DIFF):DAD3
;          00100=(DIFF'):AD4;(DIFF):(reserved)
;          00101=(DIFF'):AD5;(DIFF):(reserved)
;          00110=(DIFF'):AD6;(DIFF):(reserved)
;          00111=(DIFF'):AD7;(DIFF):(reserved)
;          01000=(DIFF'):AD8;(DIFF):(reserved)
;          01001=(DIFF'):AD9;(DIFF):(reserved)
;          01010=(DIFF'):AD10;(DIFF):(reserved)
;          01011=(DIFF'):AD11;(DIFF):(reserved)
;          01100=(DIFF'):AD12;(DIFF):(reserved)
;          01101=(DIFF'):AD13;(DIFF):(reserved)
;          01110=(DIFF'):AD14;(DIFF):(reserved)
;          01111=(DIFF'):AD15;(DIFF):(reserved)
;          10000=(DIFF'):AD16;(DIFF):(reserved)
;          10001=(DIFF'):AD17;(DIFF):(reserved)
;          10010=(DIFF'):AD18;(DIFF):(reserved)
;          10011=(DIFF'):AD19;(DIFF):(reserved)
;          10100=(DIFF'):AD20;(DIFF):(reserved)
;          10101=(DIFF'):AD21;(DIFF):(reserved)
;          10110=(DIFF'):AD22;(DIFF):(reserved)
;          10111=(DIFF'):AD23;(DIFF):(reserved)
;          11000 (reserved)
;          11001 (reserved)
;          11010=(DIFF'):temp sensor (single-ended)
;                (DIFF):temp sensor (differential)
;          11011=(DIFF'):bandgap (single-ended)
;                (DIFF):bandgap (differential)
;          11100 (reserved)
;          11101=(DIFF'):VREFSH (single-ended)
;                (DIFF):-VREFSH (differential)
;          11110=(DIFF'):VREFSL (single-ended)
;                (DIFF):(reserved)
;          11111=disabled
ADC_COCO_MASK   EQU  0x80
ADC_COCO_SHIFT  EQU  7
ADC_AIEN_MASK   EQU  0x40
ADC_AIEN_SHIFT  EQU  6
ADC_DIFF_MASK   EQU  0x20
ADC_DIFF_SHIFT  EQU  5
ADC_ADCH_MASK   EQU  0x1F
ADC_ADCH_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_SC2:  ADC status and control register 2
;31-8:(reserved):read-only:0
;   7:ADACT=ADC conversion active
;   6:ADTRG=ADC conversion trigger select
;           0=software trigger
;           1=hardware trigger
;   5:ACFE=ADC compare function enable
;   4:ACFGT=ADC compare function greater than enable
;           based on values in ADC_CV1 and ADC_CV2
;           0=configure less than threshold and non-inclusive range
;           1=configure greater than threshold and non-inclusive range
;   3:ACREN=ADC compare function range enable
;           0=disabled; only ADC_CV1 compared
;           1=enabled; both ADC_CV1 and ADC_CV2 compared
;   2:DMAEN=DMA enable
; 1-0:REFSEL=voltage reference selection
;            00=default:VREFH and VREFL
;            01=alterantive:VALTH and VALTL
;            10=(reserved)
;            11=(reserved)
ADC_ADACT_MASK    EQU  0x80
ADC_ADACT_SHIFT   EQU  7
ADC_ADTRG_MASK    EQU  0x40
ADC_ADTRG_SHIFT   EQU  6
ADC_ACFE_MASK     EQU  0x20
ADC_ACFE_SHIFT    EQU  5
ADC_ACFGT_MASK    EQU  0x10
ADC_ACFGT_SHIFT   EQU  4
ADC_ACREN_MASK    EQU  0x08
ADC_ACREN_SHIFT   EQU  3
ADC_DMAEN_MASK    EQU  0x04
ADC_DMAEN_SHIFT   EQU  2
ADC_REFSEL_MASK   EQU  0x03
ADC_REFSEL_SHIFT  EQU  0
;---------------------------------------------------------------
;ADC_SC3:  ADC status and control register 3
;31-8:(reserved):read-only:0
;   7:CAL=calibration
;         write:0=(no effect)
;               1=start calibration sequence
;         read:0=calibration sequence complete
;              1=calibration sequence in progress
;   6:CALF=calibration failed flag
; 5-4:(reserved):read-only:0
;   3:ADC=ADC continuous conversion enable (if ADC_SC3.AVGE = 1)
;   2:AVGE=hardware average enable
; 1-0:AVGS=hardware average select:  2^(2+AVGS) samples
ADC_CAL_MASK    EQU  0x80
ADC_CAL_SHIFT   EQU  7
ADC_CALF_MASK   EQU  0x40
ADC_CALF_SHIFT  EQU  6
ADC_ADCO_MASK   EQU  0x08
ADC_ADCO_SHIFT  EQU  3
ADC_AVGE_MASK   EQU  0x04
ADC_AVGE_SHIFT  EQU  2
ADC_AVGS_MASK   EQU  0x03
ADC_AVGS_SHIFT  EQU  0
;---------------------------------------------------------------
;CMP
CMP0_BASE          EQU  0x40073000
CMP0_CR0_OFFSET    EQU  0x00
CMP0_CR1_OFFSET    EQU  0x01
CMP0_FPR_OFFSET    EQU  0x02
CMP0_SCR_OFFSET    EQU  0x03
CMP0_DACCR_OFFSET  EQU  0x04
CMP0_MUXCR_OFFSET  EQU  0x05
CMP0_CR0           EQU  (CMP0_BASE + CMP0_CR0_OFFSET)
CMP0_CR1           EQU  (CMP0_BASE + CMP0_CR1_OFFSET)
CMP0_FPR           EQU  (CMP0_BASE + CMP0_FPR_OFFSET)
CMP0_SCR           EQU  (CMP0_BASE + CMP0_SCR_OFFSET)
CMP0_DACCR         EQU  (CMP0_BASE + CMP0_DACCR_OFFSET)
CMP0_MUXCR         EQU  (CMP0_BASE + CMP0_MUXCR_OFFSET)
;---------------------------------------------------------------
;CMP0_CR0:  CMP0 control register 0 (0x00)
;  7:(reserved):read-only:0
;6-4:FILTER_CNT=filter sample count (00)
;  3:(reserved):read-only:0
;  2:(reserved):read-only:0
;1-0:HYSTCTR=comparator hard block hysteresis control (00)
CMP_CR0_HYSTCTR_MASK      EQU  0x3
CMP_CR0_HYSTCTR_SHIFT     EQU  0
CMP_CR0_FILTER_CNT_MASK   EQU  0x70
CMP_CR0_FILTER_CNT_SHIFT  EQU  4
;---------------------------------------------------------------
;CMP0_CR0:  CMP0 control register 1 (0x00)
;7:SE=sample enable (0)
;6:WE=windowing enable (0)
;5:TRIGM=trigger mode enable (0)
;4:PMODE=power mode select (0)
;3:INV=comparator invert (0)
;2:COS=comparator output select (0)
;1:OPE=comparator output pin enable (0)
;0:EN=comparator module enable (0)
CMP_CR1_EN_MASK      EQU  0x1
CMP_CR1_EN_SHIFT     EQU  0
CMP_CR1_OPE_MASK     EQU  0x2
CMP_CR1_OPE_SHIFT    EQU  1
CMP_CR1_COS_MASK     EQU  0x4
CMP_CR1_COS_SHIFT    EQU  2
CMP_CR1_INV_MASK     EQU  0x8
CMP_CR1_INV_SHIFT    EQU  3
CMP_CR1_PMODE_MASK   EQU  0x10
CMP_CR1_PMODE_SHIFT  EQU  4
CMP_CR1_TRIGM_MASK   EQU  0x20
CMP_CR1_TRIGM_SHIFT  EQU  5
CMP_CR1_WE_MASK      EQU  0x40
CMP_CR1_WE_SHIFT     EQU  6
CMP_CR1_SE_MASK      EQU  0x80
CMP_CR1_SE_SHIFT     EQU  7
;---------------------------------------------------------------
;CMP0_FPR=CMP filter period register (0x00)
;7-0:FILT_PER=CMP filter period register (0x00)
CMP_FPR_FILT_PER_MASK   EQU  0xFF
CMP_FPR_FILT_PER_SHIFT  EQU  0
;---------------------------------------------------------------
;CMP0_SCR=CMP status and control register (0x00)
;7:(reserved):read-only:0
;6:DMAEN=DMA enable control (0)
;5:(reserved):read-only:0
;4:IER=comparator interrupt enable rising (0)
;3:IEF=comparator interrupt enable falling (0)
;2:CFR=analog comparator flag rising: w1c (0)
;1:CFF=analog comparator flag falling: w1c (0)
;0:COUT=analog comparator output (0)
CMP_SCR_COUT_MASK    EQU  0x1
CMP_SCR_COUT_SHIFT   EQU  0
CMP_SCR_CFF_MASK     EQU  0x2
CMP_SCR_CFF_SHIFT    EQU  1
CMP_SCR_CFR_MASK     EQU  0x4
CMP_SCR_CFR_SHIFT    EQU  2
CMP_SCR_IEF_MASK     EQU  0x8
CMP_SCR_IEF_SHIFT    EQU  3
CMP_SCR_IER_MASK     EQU  0x10
CMP_SCR_IER_SHIFT    EQU  4
CMP_SCR_DMAEN_MASK   EQU  0x40
CMP_SCR_DMAEN_SHIFT  EQU  6
;---------------------------------------------------------------
;CMP0_DACCR=DAC control register (0x00)
;  7:DACEN=DAC enable (0)
;  6:VRSEL=supply voltage reference source select (0)
;5-0:VOSEL=DAC output voltage select (00000)
;          DAC0 = (Vin / 64) x (VOSEL[5:0] + 1)
CMP_DACCR_VOSEL_MASK   EQU  0x3F
CMP_DACCR_VOSEL_SHIFT  EQU  0
CMP_DACCR_VRSEL_MASK   EQU  0x40
CMP_DACCR_VRSEL_SHIFT  EQU  6
CMP_DACCR_DACEN_MASK   EQU  0x80
CMP_DACCR_DACEN_SHIFT  EQU  7
;---------------------------------------------------------------
;CMP0_MUXCR=MUX control register (0x00)
;  7:PSTM=pass through mode enable (0)
;5-3:PSEL=plus input mux control (000)
;         selects IN[PSEL]
;2-0:MSEL=minus input mux control (000)
;         selects IN[MSEL]
CMP_MUXCR_MSEL_MASK   EQU  0x7
CMP_MUXCR_MSEL_SHIFT  EQU  0
CMP_MUXCR_PSEL_MASK   EQU  0x38
CMP_MUXCR_PSEL_SHIFT  EQU  3
CMP_MUXCR_PSTM_MASK   EQU  0x80
CMP_MUXCR_PSTM_SHIFT  EQU  7
;---------------------------------------------------------------
;DAC
DAC0_BASE          EQU  0x4003F000
DAC0_DAT0L_OFFSET  EQU  0x00
DAC0_DAT0H_OFFSET  EQU  0x01
DAC0_DAT1L_OFFSET  EQU  0x02
DAC0_DAT1H_OFFSET  EQU  0x03
DAC0_SR_OFFSET     EQU  0x20
DAC0_C0_OFFSET     EQU  0x21
DAC0_C1_OFFSET     EQU  0x22
DAC0_C2_OFFSET     EQU  0x23
DAC0_DAT0L         EQU  (DAC0_BASE + DAC0_DAT0L_OFFSET)
DAC0_DAT0H         EQU  (DAC0_BASE + DAC0_DAT0H_OFFSET)
DAC0_DAT1L         EQU  (DAC0_BASE + DAC0_DAT1L_OFFSET)
DAC0_DAT1H         EQU  (DAC0_BASE + DAC0_DAT1H_OFFSET)
DAC0_SR            EQU  (DAC0_BASE + DAC0_SR_OFFSET)
DAC0_C0            EQU  (DAC0_BASE + DAC0_C0_OFFSET)
DAC0_C1            EQU  (DAC0_BASE + DAC0_C1_OFFSET)
DAC0_C2            EQU  (DAC0_BASE + DAC0_C2_OFFSET)
;---------------------------------------------------------------
;DAC_DAT0H:  DAC data high register 0
;If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
;7-4:(reserved):read-only:0
;3-0:DATA1=DATA[11:8]
DAC_DAT0H_MASK   EQU  0x0F
DAC_DAT0H_SHIFT  EQU  0
;---------------------------------------------------------------
;DAC_DAT0L:  DAC data low register 0
;If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
;7-0:DATA0=DATA[7:0]
;---------------------------------------------------------------
;DAC_DAT1H:  DAC data high register 1
;If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
;7-4:(reserved):read-only:0
;3-0:DATA1=DATA[11:8]
DAC_DAT1H_MASK   EQU  0x0F
DAC_DAT1H_SHIFT  EQU  0
;---------------------------------------------------------------
;DAC_DAT1L:  DAC data low register 1
;If buffer not enabled, Vout = Vin * (1 + DATA[11:0])/4096.
;7-0:DATA0=DATA[7:0]
;---------------------------------------------------------------
;DAC_C0:  DAC control register 0
;7:DACEN=DAC enable
;6:DACRFS=DAC reference select
;         0:DACREF_1=VREFH
;         1:DACREF_2=VDDA (best for ADC operation)
;5:DACTRGSEL=DAC trigger select
;            0:HW
;            1:SW
;4:DACSWTRG=DAC software trigger
;           active-high write-only field that reads 0
;           DACBFEN & DACTRGSEL:  writing 1 advances buffer pointer
;3:LPEN=DAC low power control
;       0:high-power mode
;       1:low-power mode
;2:(reserved):read-only:0
;1:DACBTIEN=DAC buffer read pointer top flag interrupt enable
;0:DACBBIEN=DAC buffer read pointer bottom flag interrupt enable
DAC_C0_DACEN_MASK       EQU  0x80
DAC_C0_DACEN_SHIFT      EQU  7
DAC_C0_DACRFS_MASK      EQU  0x40
DAC_C0_DACRFS_SHIFT     EQU  6
DAC_C0_DACTRGSEL_MASK   EQU  0x20
DAC_C0_DACTRGSEL_SHIFT  EQU  5
DAC_C0_DACSWTRG_MASK    EQU  0x10
DAC_C0_DACSWTRG_SHIFT   EQU  4
DAC_C0_LPEN_MASK        EQU  0x08
DAC_C0_LPEN_SHIFT       EQU  3
DAC_C0_DACBTIEN_MASK    EQU  0x02
DAC_C0_DACBTIEN_SHIFT   EQU  1
DAC_C0_DACBBIEN_MASK    EQU  0x01
DAC_C0_DACBBIEN_SHIFT   EQU  0
;---------------------------------------------------------------
;DAC_C1:  DAC control register 1
;  7:DMAEN=DMA enable select
;6-3:(reserved)
;  2:DACBFMD=DAC buffer work mode select
;            0:normal
;            1:one-time scan
;  1:(reserved)
;  0:DACBFEN=DAC buffer enable
;            0:disabled:data in first word of buffer
;            1:enabled:read pointer points to data
DAC_C1_DMAEN_MASK       EQU  0x80
DAC_C1_DMAEN_SHIFT      EQU  7
DAC_C1_DACBFMD_MASK     EQU  0x04
DAC_C1_DACBFMD_SHIFT    EQU  2
DAC_C1_DACBFEN_MASK     EQU  0x01
DAC_C1_DACBFEN_SHIFT    EQU  0
;---------------------------------------------------------------
;DAC_C2:  DAC control register 2
;7-5:(reserved):read-only:0
;  4:DACBFRP=DAC buffer read pointer
;3-1:(reserved):read-only:0
;  0:DACBFUP=DAC buffer read upper limit
DAC_C2_DACBFRP_MASK   EQU  0x10
DAC_C2_DACBFRP_SHIFT  EQU  4
DAC_C2_DACBFUP_MASK   EQU  0x01
DAC_C2_DACBFUP_SHIFT  EQU  0
;---------------------------------------------------------------
;DAC_SR:  DAC status register
;Writing 0 clears a field; writing 1 has no effect.
;7-2:(reserved):read-only:0
;1:DACBFRPTF=DAC buffer read pointer top position flag
;            Indicates whether pointer is zero
;0:DACBFRPBF=DAC buffer read pointer bottom position flag
;            Indicates whether pointer is equal to DAC0_C2.DACBFUP.
DAC_SR_DACBFRPTF_MASK   EQU 0x02
DAC_SR_DACBFRPTF_SHIFT  EQU 1
DAC_SR_DACBFRPBF_MASK   EQU 0x01
DAC_SR_DACBFRPBF_SHIFT  EQU 0
;---------------------------------------------------------------
;Fast (zero wait state) GPIO (FGPIO) or (IOPORT)
;FGPIOx_PDD: Port x Data Direction Register
;Bit n:  0=Port x pin n configured as input
;        1=Port x pin n configured as output
FGPIO_BASE         EQU  0xF80FF000
;offsets for PDOR, PSOR, PCOR, PTOR, PDIR, and PDDR defined
;  with GPIO EQUates
;offsets for Ports A-E defined with GPIO EQUates
;Port A
FGPIOA_BASE        EQU  0xF80FF000
FGPIOA_PDOR        EQU  (FGPIOA_BASE + GPIO_PDOR_OFFSET)
FGPIOA_PSOR        EQU  (FGPIOA_BASE + GPIO_PSOR_OFFSET)
FGPIOA_PCOR        EQU  (FGPIOA_BASE + GPIO_PCOR_OFFSET)
FGPIOA_PTOR        EQU  (FGPIOA_BASE + GPIO_PTOR_OFFSET)
FGPIOA_PDIR        EQU  (FGPIOA_BASE + GPIO_PDIR_OFFSET)
FGPIOA_PDDR        EQU  (FGPIOA_BASE + GPIO_PDDR_OFFSET)
;Port B
FGPIOB_BASE        EQU  0xF80FF040
FGPIOB_PDOR        EQU  (FGPIOB_BASE + GPIO_PDOR_OFFSET)
FGPIOB_PSOR        EQU  (FGPIOB_BASE + GPIO_PSOR_OFFSET)
FGPIOB_PCOR        EQU  (FGPIOB_BASE + GPIO_PCOR_OFFSET)
FGPIOB_PTOR        EQU  (FGPIOB_BASE + GPIO_PTOR_OFFSET)
FGPIOB_PDIR        EQU  (FGPIOB_BASE + GPIO_PDIR_OFFSET)
FGPIOB_PDDR        EQU  (FGPIOB_BASE + GPIO_PDDR_OFFSET)
;Port C
FGPIOC_BASE        EQU  0xF80FF080
FGPIOC_PDOR        EQU  (FGPIOC_BASE + GPIO_PDOR_OFFSET)
FGPIOC_PSOR        EQU  (FGPIOC_BASE + GPIO_PSOR_OFFSET)
FGPIOC_PCOR        EQU  (FGPIOC_BASE + GPIO_PCOR_OFFSET)
FGPIOC_PTOR        EQU  (FGPIOC_BASE + GPIO_PTOR_OFFSET)
FGPIOC_PDIR        EQU  (FGPIOC_BASE + GPIO_PDIR_OFFSET)
FGPIOC_PDDR        EQU  (FGPIOC_BASE + GPIO_PDDR_OFFSET)
;Port D
FGPIOD_BASE        EQU  0xF80FF0C0
FGPIOD_PDOR        EQU  (FGPIOD_BASE + GPIO_PDOR_OFFSET)
FGPIOD_PSOR        EQU  (FGPIOD_BASE + GPIO_PSOR_OFFSET)
FGPIOD_PCOR        EQU  (FGPIOD_BASE + GPIO_PCOR_OFFSET)
FGPIOD_PTOR        EQU  (FGPIOD_BASE + GPIO_PTOR_OFFSET)
FGPIOD_PDIR        EQU  (FGPIOD_BASE + GPIO_PDIR_OFFSET)
FGPIOD_PDDR        EQU  (FGPIOD_BASE + GPIO_PDDR_OFFSET)
;Port E
FGPIOE_BASE        EQU  0xF80FF100
FGPIOE_PDOR        EQU  (FGPIOE_BASE + GPIO_PDOR_OFFSET)
FGPIOE_PSOR        EQU  (FGPIOE_BASE + GPIO_PSOR_OFFSET)
FGPIOE_PCOR        EQU  (FGPIOE_BASE + GPIO_PCOR_OFFSET)
FGPIOE_PTOR        EQU  (FGPIOE_BASE + GPIO_PTOR_OFFSET)
FGPIOE_PDIR        EQU  (FGPIOE_BASE + GPIO_PDIR_OFFSET)
FGPIOE_PDDR        EQU  (FGPIOE_BASE + GPIO_PDDR_OFFSET)
;---------------------------------------------------------------
;Flash Configuration Field (FCF) 0x400-0x40F
;Following Freescale startup_MKL46Z4.s
;     CMSIS Cortex-M0plus Core Device Startup File for the MKL64Z4
;     v2.2, 4/12/2013
;16-byte flash configuration field that stores default protection settings
;(loaded on reset) and security information that allows the MCU to 
;restrict acces to the FTFL module.
;FCF Backdoor Comparison Key
;8 bytes from 0x400-0x407
;-----------------------------------------------------
;FCF Backdoor Comparison Key 0
;7-0:Backdoor Key 0
FCF_BACKDOOR_KEY0  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 1
;7-0:Backdoor Key 1
FCF_BACKDOOR_KEY1  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 2
;7-0:Backdoor Key 2
FCF_BACKDOOR_KEY2  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 3
;7-0:Backdoor Key 3
FCF_BACKDOOR_KEY3  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 4
;7-0:Backdoor Key 4
FCF_BACKDOOR_KEY4  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 5
;7-0:Backdoor Key 5
FCF_BACKDOOR_KEY5  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 6
;7-0:Backdoor Key 6
FCF_BACKDOOR_KEY6  EQU  0xFF
;-----------------------------------------------------
;FCF Backdoor Comparison Key 7
;7-0:Backdoor Key 7
FCF_BACKDOOR_KEY7  EQU  0xFF
;-----------------------------------------------------
;FCF Flash nonvolatile option byte (FCF_FOPT)
;Allows user to customize operation of the MCU at boot time.
;7-6:11:(reserved)
;  5: 1:FAST_INIT=fast initialization
;4,0:11:LPBOOT=core and system clock divider:  2^(3-LPBOOT)
;  3: 1:RESET_PIN_CFG=enable reset pin following POR
;  2: 1:NMI_DIS=Enable NMI
;  1: 1:(reserved)
;  0:(see bit 4 above)
FCF_FOPT  EQU  0xFF
;-----------------------------------------------------
;FCF Program flash protection bytes (FCF_FPROT)
;Each program flash region can be protected from program and erase 
;operation by setting the associated PROT bit.  Each bit protects a 
;1/32 region of the program flash memory.
;FCF FPROT0
;7:1:FCF_PROT7=Program flash region 7/32 not protected
;6:1:FCF_PROT6=Program flash region 6/32 not protected
;5:1:FCF_PROT5=Program flash region 5/32 not protected
;4:1:FCF_PROT4=Program flash region 4/32 not protected
;3:1:FCF_PROT3=Program flash region 3/32 not protected
;2:1:FCF_PROT2=Program flash region 2/32 not protected
;1:1:FCF_PROT1=Program flash region 1/32 not protected
;0:1:FCF_PROT0=Program flash region 0/32 not protected
FCF_FPROT0  EQU  0xFF
;-----------------------------------------------------
;FCF FPROT1
;7:1:FCF_PROT15=Program flash region 15/32 not protected
;6:1:FCF_PROT14=Program flash region 14/32 not protected
;5:1:FCF_PROT13=Program flash region 13/32 not protected
;4:1:FCF_PROT12=Program flash region 12/32 not protected
;3:1:FCF_PROT11=Program flash region 11/32 not protected
;2:1:FCF_PROT10=Program flash region 10/32 not protected
;1:1:FCF_PROT9=Program flash region 9/32 not protected
;0:1:FCF_PROT8=Program flash region 8/32 not protected
FCF_FPROT1  EQU  0xFF
;-----------------------------------------------------
;FCF FPROT2
;7:1:FCF_PROT23=Program flash region 23/32 not protected
;6:1:FCF_PROT22=Program flash region 22/32 not protected
;5:1:FCF_PROT21=Program flash region 21/32 not protected
;4:1:FCF_PROT20=Program flash region 20/32 not protected
;3:1:FCF_PROT19=Program flash region 19/32 not protected
;2:1:FCF_PROT18=Program flash region 18/32 not protected
;1:1:FCF_PROT17=Program flash region 17/32 not protected
;0:1:FCF_PROT16=Program flash region 16/32 not protected
FCF_FPROT2  EQU  0xFF
;-----------------------------------------------------
;FCF FPROT3
;7:1:FCF_PROT31=Program flash region 31/32 not protected
;6:1:FCF_PROT30=Program flash region 30/32 not protected
;5:1:FCF_PROT29=Program flash region 29/32 not protected
;4:1:FCF_PROT28=Program flash region 28/32 not protected
;3:1:FCF_PROT27=Program flash region 27/32 not protected
;2:1:FCF_PROT26=Program flash region 26/32 not protected
;1:1:FCF_PROT25=Program flash region 25/32 not protected
;0:1:FCF_PROT24=Program flash region 24/32 not protected
FCF_FPROT3  EQU  0xFF
;-----------------------------------------------------
;FCF Flash security byte (FCF_FSEC)
;WARNING: If SEC field is configured as "MCU security status is 
;secure" and MEEN field is configured as "Mass erase is disabled",
;MCU's security status cannot be set back to unsecure state since 
;mass erase via the debugger is blocked !!!
;7-6:01:KEYEN=backdoor key security enable
;            :00=Backdoor key access disabled
;            :01=Backdoor key access disabled (preferred value)
;            :10=Backdoor key access enabled
;            :11=Backdoor key access disabled
;5-4:11:MEEN=mass erase enable bits
;           (does not matter if SEC unsecure)
;           :00=mass erase enabled
;           :01=mass erase enabled
;           :10=mass erase disabled
;           :11=mass erase enabled
;3-2:11:FSLACC=Freescale failure analysis access code
;             (does not matter if SEC unsecure)
;             :00=Freescale factory access granted
;             :01=Freescale factory access denied
;             :10=Freescale factory access denied
;             :11=Freescale factory access granted
;1-0:10:SEC=flash security
;          :00=MCU secure
;          :01=MCU secure
;          :10=MCU unsecure (standard value)
;          :11=MCU secure
FCF_FSEC  EQU  0x7E
;---------------------------------------------------------------
;General-purpose input and output (GPIO)
;GPIOx_PDD: Port x Data Direction Register
;Bit n:  0=Port x pin n configured as input
;        1=Port x pin n configured as output
GPIO_BASE         EQU  0x400FF000
GPIO_PDOR_OFFSET  EQU  0x00
GPIO_PSOR_OFFSET  EQU  0x04
GPIO_PCOR_OFFSET  EQU  0x08
GPIO_PTOR_OFFSET  EQU  0x0C
GPIO_PDIR_OFFSET  EQU  0x10
GPIO_PDDR_OFFSET  EQU  0x14
GPIOA_OFFSET      EQU  0x00
GPIOB_OFFSET      EQU  0x40
GPIOC_OFFSET      EQU  0x80
GPIOD_OFFSET      EQU  0xC0
GPIOE_OFFSET      EQU  0x0100
;Port A
GPIOA_BASE        EQU  0x400FF000
GPIOA_PDOR        EQU  (GPIOA_BASE + GPIO_PDOR_OFFSET)
GPIOA_PSOR        EQU  (GPIOA_BASE + GPIO_PSOR_OFFSET)
GPIOA_PCOR        EQU  (GPIOA_BASE + GPIO_PCOR_OFFSET)
GPIOA_PTOR        EQU  (GPIOA_BASE + GPIO_PTOR_OFFSET)
GPIOA_PDIR        EQU  (GPIOA_BASE + GPIO_PDIR_OFFSET)
GPIOA_PDDR        EQU  (GPIOA_BASE + GPIO_PDDR_OFFSET)
;Port B
GPIOB_BASE         EQU  0x400FF040
GPIOB_PDOR         EQU  (GPIOB_BASE + GPIO_PDOR_OFFSET)
GPIOB_PSOR         EQU  (GPIOB_BASE + GPIO_PSOR_OFFSET)
GPIOB_PCOR         EQU  (GPIOB_BASE + GPIO_PCOR_OFFSET)
GPIOB_PTOR         EQU  (GPIOB_BASE + GPIO_PTOR_OFFSET)
GPIOB_PDIR         EQU  (GPIOB_BASE + GPIO_PDIR_OFFSET)
GPIOB_PDDR         EQU  (GPIOB_BASE + GPIO_PDDR_OFFSET)
;Port C
GPIOC_BASE         EQU  0x400FF080
GPIOC_PDOR         EQU  (GPIOC_BASE + GPIO_PDOR_OFFSET)
GPIOC_PSOR         EQU  (GPIOC_BASE + GPIO_PSOR_OFFSET)
GPIOC_PCOR         EQU  (GPIOC_BASE + GPIO_PCOR_OFFSET)
GPIOC_PTOR         EQU  (GPIOC_BASE + GPIO_PTOR_OFFSET)
GPIOC_PDIR         EQU  (GPIOC_BASE + GPIO_PDIR_OFFSET)
GPIOC_PDDR         EQU  (GPIOC_BASE + GPIO_PDDR_OFFSET)
;Port D
GPIOD_BASE         EQU  0x400FF0C0
GPIOD_PDOR         EQU  (GPIOD_BASE + GPIO_PDOR_OFFSET)
GPIOD_PSOR         EQU  (GPIOD_BASE + GPIO_PSOR_OFFSET)
GPIOD_PCOR         EQU  (GPIOD_BASE + GPIO_PCOR_OFFSET)
GPIOD_PTOR         EQU  (GPIOD_BASE + GPIO_PTOR_OFFSET)
GPIOD_PDIR         EQU  (GPIOD_BASE + GPIO_PDIR_OFFSET)
GPIOD_PDDR         EQU  (GPIOD_BASE + GPIO_PDDR_OFFSET)
;Port E
GPIOE_BASE         EQU  0x400FF100
GPIOE_PDOR         EQU  (GPIOE_BASE + GPIO_PDOR_OFFSET)
GPIOE_PSOR         EQU  (GPIOE_BASE + GPIO_PSOR_OFFSET)
GPIOE_PCOR         EQU  (GPIOE_BASE + GPIO_PCOR_OFFSET)
GPIOE_PTOR         EQU  (GPIOE_BASE + GPIO_PTOR_OFFSET)
GPIOE_PDIR         EQU  (GPIOE_BASE + GPIO_PDIR_OFFSET)
GPIOE_PDDR         EQU  (GPIOE_BASE + GPIO_PDDR_OFFSET)
;---------------------------------------------------------------
;IOPORT:  GPIO alias for zero wait state access to GPIO
;See FGPIO
;---------------------------------------------------------------
;LCD Controller (SLCD)
LCD_BASE             EQU  0x40053000
LCD_GCR_OFFSET       EQU  0x00
LCD_AR_OFFSET        EQU  0x04
LCD_FDCR_OFFSET      EQU  0x08
LCD_FDSR_OFFSET      EQU  0x0C
LCD_PENL_OFFSET      EQU  0x10
LCD_PENH_OFFSET      EQU  0x14
LCD_BPENL_OFFSET     EQU  0x18
LCD_BPENH_OFFSET     EQU  0x1C
LCD_WF_OFFSET        EQU  0x20  ;WF.D[16] or WF.B[64]
LCD_WF3TO0_OFFSET    EQU  0x20
LCD_WF7TO4_OFFSET    EQU  0x24
LCD_WF11TO8_OFFSET   EQU  0x28
LCD_WF15TO12_OFFSET  EQU  0x2C
LCD_WF19TO16_OFFSET  EQU  0x30
LCD_WF23TO20_OFFSET  EQU  0x34
LCD_WF27TO24_OFFSET  EQU  0x38
LCD_WF31TO28_OFFSET  EQU  0x3C
LCD_WF35TO32_OFFSET  EQU  0x40
LCD_WF39TO36_OFFSET  EQU  0x44
LCD_WF43TO40_OFFSET  EQU  0x48
LCD_WF47TO44_OFFSET  EQU  0x4C
LCD_WF51TO48_OFFSET  EQU  0x50
LCD_WF55TO52_OFFSET  EQU  0x54
LCD_WF59TO56_OFFSET  EQU  0x58
LCD_WF63TO60_OFFSET  EQU  0x5C
LCD_GCR              EQU  (LCD_BASE + LCD_GCR_OFFSET)
LCD_AR               EQU  (LCD_BASE + LCD_AR_OFFSET)
LCD_FDCR             EQU  (LCD_BASE + LCD_FDCR_OFFSET)
LCD_FDSR             EQU  (LCD_BASE + LCD_FDSR_OFFSET)
LCD_PENL             EQU  (LCD_BASE + LCD_PENL_OFFSET)
LCD_PENH             EQU  (LCD_BASE + LCD_PENH_OFFSET)
LCD_BPENL            EQU  (LCD_BASE + LCD_BPENL_OFFSET)
LCD_BPENH            EQU  (LCD_BASE + LCD_BPENH_OFFSET)
LCD_WF               EQU  (LCD_BASE + LCD_WF_OFFSET)  ;WF.D[16] or WF.B[64]
LCD_WF3TO0           EQU  (LCD_BASE + LCD_WF3TO0_OFFSET)
LCD_WF7TO4           EQU  (LCD_BASE + LCD_WF7TO4_OFFSET)
LCD_WF11TO8          EQU  (LCD_BASE + LCD_WF11TO8_OFFSET)
LCD_WF15TO12         EQU  (LCD_BASE + LCD_WF15TO12_OFFSET)
LCD_WF19TO16         EQU  (LCD_BASE + LCD_WF19TO16_OFFSET)
LCD_WF23TO20         EQU  (LCD_BASE + LCD_WF23TO20_OFFSET)
LCD_WF27TO24         EQU  (LCD_BASE + LCD_WF27TO24_OFFSET)
LCD_WF31TO28         EQU  (LCD_BASE + LCD_WF31TO28_OFFSET)
LCD_WF35TO32         EQU  (LCD_BASE + LCD_WF35TO32_OFFSET)
LCD_WF39TO36         EQU  (LCD_BASE + LCD_WF39TO36_OFFSET)
LCD_WF43TO40         EQU  (LCD_BASE + LCD_WF43TO40_OFFSET)
LCD_WF47TO44         EQU  (LCD_BASE + LCD_WF47TO44_OFFSET)
LCD_WF51TO48         EQU  (LCD_BASE + LCD_WF51TO48_OFFSET)
LCD_WF55TO52         EQU  (LCD_BASE + LCD_WF55TO52_OFFSET)
LCD_WF59TO56         EQU  (LCD_BASE + LCD_WF59TO56_OFFSET)
LCD_WF63TO60         EQU  (LCD_BASE + LCD_WF63TO60_OFFSET)
;---------------------------------------------------------------
;LCD_GCR:  LCD general control register:  (POR:  0x08300003)
;   31:  RVEN:  regulated voltage enable:  (POR:  0)
;30-28:  (reserved):read-only:000
;27-24:  RVTRIM:  regulated voltage trim:  (1000)
;   23:  CPSEL:  charge pump select: (0)
;                0:  resister network
;                1:  charge pump
;   22:  (reserved):read-only:0
;21-20:  LADJ:  load adjust:  (11)
;          CPSEL = 0:  adjust resistor bias network
;            00:  low load (LCD glass <= 2000 pF)
;                 LCD or GPIO for pins VLL1, VLL2, VCAP1, or VCAP2
;            01:  low laod (LCD glass <= 2000 pF)
;                 LCD or GPIO for pins VLL1, VLL2, VCAP1, or VCAP2
;            10:  high load (LCD glass <= 8000 pF)
;                 LCD or GPIO for pins VCAP1 or VCAP2
;            11:  high load (LCD glass <= 8000 pF)
;                 LCD or GPIO for pins VCAP1 or VCAP2
;          CPSEL = 1:  adjust clock source for charge pump
;            00:  fastest clock (LCD glass <= 8000 pF [4000 pF if FFR])
;            01:  intermediate clock (LCD glass <= 4000 pF [2000 pF if FFR])
;            10:  intermediate clock (LCD glass <= 2000 pF [1000 pF if FFR])
;            11:  slowest clock (LCD glass <= 1000 pF [500 pF if FFR])
;   19:  (reserved):read-only:0
;   18:  (reserved):read-only:0
;   17:  VSUPPLY:  voltage supply control:  (0)
;                  0:  VLL3 internally from VDD
;                  1:  VLL3 externally from VDD or VLL internally from VIREG
;   16:  (reserved):read-only:0
;   15:  PADSAFE:  pad safe state enable:  (0)
;   14:  FDCIEN:  LCD fault detection complete interrupt enable:  (0)
;13-12:  ATLDIV:  LCD alternate clock divider = 8^ALTDIV:  (00)
;   11:  ALTSOURCE:  alternate clock source select = ALTSOURCE + 1:  (0)
;   10:  FFR:  fast frame rate select:  (0)
;              0:  standard frequency, [23.3, 73.1]
;              1:  fast frequency = std. x 2, [46.6, 146.2]
;    9:  LCDDOZE:  LCD doze enable:  (0)
;    8:  LCDSTP:  LCD stop:  (0)
;    7:  LCDEN:  LCD driver enable:  (0)
;    6:  SOURCE:  LCD clock source select:  (0)
;                 0:  Default clock (SIM_SOPT1.OSC32KSEL)
;                 1:  Alternate clock (LCD_GCR.ALTSOURCE)
;  5-3:  LCLK:  LCD clock prescaler:  (000)
;               frequency = SOURCE / ((DUTY + 1) x 8 x (4 +LCLK) x Y)
;  2-0:  DUTY:  LCD duty select:  (011)
;               000, 001, 010, 011, 111:  1 / (DUTY + 1) duty cycle
LCD_GCR_DUTY_MASK        EQU  0x7
LCD_GCR_DUTY_SHIFT       EQU  0
LCD_GCR_LCLK_MASK        EQU  0x38
LCD_GCR_LCLK_SHIFT       EQU  3
LCD_GCR_SOURCE_MASK      EQU  0x40
LCD_GCR_SOURCE_SHIFT     EQU  6
LCD_GCR_LCDEN_MASK       EQU  0x80
LCD_GCR_LCDEN_SHIFT      EQU  7
LCD_GCR_LCDSTP_MASK      EQU  0x100
LCD_GCR_LCDSTP_SHIFT     EQU  8
LCD_GCR_LCDDOZE_MASK     EQU  0x200
LCD_GCR_LCDDOZE_SHIFT    EQU  9
LCD_GCR_FFR_MASK         EQU  0x400
LCD_GCR_FFR_SHIFT        EQU  10
LCD_GCR_ALTSOURCE_MASK   EQU  0x800
LCD_GCR_ALTSOURCE_SHIFT  EQU  11
LCD_GCR_ALTDIV_MASK      EQU  0x3000
LCD_GCR_ALTDIV_SHIFT     EQU  12
LCD_GCR_FDCIEN_MASK      EQU  0x4000
LCD_GCR_FDCIEN_SHIFT     EQU  14
LCD_GCR_PADSAFE_MASK     EQU  0x8000
LCD_GCR_PADSAFE_SHIFT    EQU  15
LCD_GCR_VSUPPLY_MASK     EQU  0x20000
LCD_GCR_VSUPPLY_SHIFT    EQU  17
LCD_GCR_LADJ_MASK        EQU  0x300000
LCD_GCR_LADJ_SHIFT       EQU  20
LCD_GCR_CPSEL_MASK       EQU  0x800000
LCD_GCR_CPSEL_SHIFT      EQU  23
LCD_GCR_RVTRIM_MASK      EQU  0xF000000
LCD_GCR_RVTRIM_SHIFT     EQU  24
LCD_GCR_RVEN_MASK        EQU  0x80000000
LCD_GCR_RVEN_SHIFT       EQU  31
;---------------------------------------------------------------
;LCD_AR:  LCD auxiliary register:  (POR:  0x00000000)
;31-16:  (reserved):read-only:0x0000
;   15:  (reserved):read-only:0
; 14-8:  (reserved):read-only:0000000
;    7:  BLINK:  blink command:  (0)
;    6:  ALT:  alternate display mode:  (0)
;    5:  BLANK:  blank display mode:  (0)
;    4:  (reserved:read-only:0
;    3:  BMODE:  blink mode:  (0)
;                0:  display blank during blink period
;                1:  display alternate display during blink period (LCD_GCR.DUTY < 5)
;  2-0:  BRATE:  blink-rate configuration:  (000)
;                Blink rate = LCD clock / (2 ^ (12 + BRATE))
LCD_AR_BRATE_MASK   EQU  0x7
LCD_AR_BRATE_SHIFT  EQU  0
LCD_AR_BMODE_MASK   EQU  0x8
LCD_AR_BMODE_SHIFT  EQU  3
LCD_AR_BLANK_MASK   EQU  0x20
LCD_AR_BLANK_SHIFT  EQU  5
LCD_AR_ALT_MASK     EQU  0x40
LCD_AR_ALT_SHIFT    EQU  6
LCD_AR_BLINK_MASK   EQU  0x80
LCD_AR_BLINK_SHIFT  EQU  7
;---------------------------------------------------------------
;LCD_FDCR:  LCD fault detect control register:  (POR:  0x00000000)
;31-16:  (reserved):read-only:0x0000
;   15:  (reserved):read-only:0
;14-12:  FDPRS:  fault detect clock prescaler (000)
;                Fault detect sample clock = Bus clock / (2 ^ FDPRS)
; 11-9:  FDSWW:  fault detect sample window width:  (000)
;                Window width = 4 x (2 ^ FDSWW)
;    8:  (reserved):read-only:0
;    7:  FDEN:  fault detect enable:  (0)
;    6:  FDBPEN:  fault detect back plane enable:  (0)
;  5-0:  BDPINID:  fault detect pin ID:  (000000)
LCD_FDCR_FDPINID_MASK   EQU  0x3F
LCD_FDCR_FDPINID_SHIFT  EQU  0
LCD_FDCR_FDBPEN_MASK    EQU  0x40
LCD_FDCR_FDBPEN_SHIFT   EQU  6
LCD_FDCR_FDEN_MASK      EQU  0x80
LCD_FDCR_FDEN_SHIFT     EQU  7
LCD_FDCR_FDSWW_MASK     EQU  0xE00
LCD_FDCR_FDSWW_SHIFT    EQU  9
LCD_FDCR_FDPRS_MASK     EQU  0x7000
LCD_FDCR_FDPRS_SHIFT    EQU  12
;---------------------------------------------------------------
;LCD_FDSR:  LCD fault detect status register:  (POR:  0x00000000)
;31-16:  (reserved):read-only:0x0000
;   15:  FDCF:  fault detection complete flag:  (0)
;         read:0=fault detection not completed
;              1=fault detection completed
;         write:0=(no effect)
;               1=clear
; 14-8:  (reserved):read-only:0000000
;  7-0:  FDCNT:  fault detect counter:  (0x00)
LCD_FDSR_FDCNT_MASK   EQU  0xFF
LCD_FDSR_FDCNT_SHIFT  EQU  0
LCD_FDSR_FDCF_MASK    EQU  0x8000
LCD_FDSR_FDCF_SHIFT   EQU  15
;---------------------------------------------------------------
;LCD_PENn:  LCD pen enable register:  (POR:  0x00000000)
;31-0:  PEN:  LCD pin enable
;       bit n enables LCD operation on LCD pin n
LCD_PEN_PEN_MASK   EQU  0xFFFFFFFF
LCD_PEN_PEN_SHIFT  EQU  0
;---------------------------------------------------------------
;LCD_BPENn:  LCD back plane enable register:  (POR:  0x00000000)
;31-0:  BPEN:  back plane enable
;       bit n enables front'/back plane operation on LCD pin n
LCD_BPEN_BPEN_MASK   EQU  0xFFFFFFFF
LCD_BPEN_BPEN_SHIFT  EQU  0
;---------------------------------------------------------------
;LCD_WFyTOx:  LCD waveform register:  (POR:  0x00000000)
;May be written with 8-, 16-, or 32-bit writes
;y = x + 3
;31-24:  WFy [WF(x+3)]
;23-16:  WF(y-1) [WF(x+2)]
; 15-8:  WF(y-2) [WF(x+1)]
;  7-0:  WF(y-3) [WFx]
;        Each byte WFn (n in {x, x+1, x+2, y}) controls an LCD pen
;          bit 7:segment/phase H
;          bit 6:segment/phase G
;          bit 5:segment/phase F
;          bit 4:segment/phase E
;          bit 3:segment/phase D
;          bit 2:segment/phase C
;          bit 1:segment/phase B
;          bit 0:segment/phase A:
;                value 0:  segment off or phase deactivtated
;                value 1:  segment on or phase activated
;---------------------------------------------------------------
;Custom WFn register mapping not in C MKL46Z4.h
LCD_WF0_REG        EQU  LCD_WF3TO0
LCD_WF1_REG        EQU  LCD_WF3TO0
LCD_WF2_REG        EQU  LCD_WF3TO0
LCD_WF3_REG        EQU  LCD_WF3TO0
LCD_WF4_REG        EQU  LCD_WF7TO4
LCD_WF5_REG        EQU  LCD_WF7TO4
LCD_WF6_REG        EQU  LCD_WF7TO4
LCD_WF7_REG        EQU  LCD_WF7TO4
LCD_WF8_REG        EQU  LCD_WF11TO8
LCD_WF9_REG        EQU  LCD_WF11TO8
LCD_WF10_REG       EQU  LCD_WF11TO8
LCD_WF11_REG       EQU  LCD_WF11TO8
LCD_WF12_REG       EQU  LCD_WF15TO12
LCD_WF13_REG       EQU  LCD_WF15TO12
LCD_WF14_REG       EQU  LCD_WF15TO12
LCD_WF15_REG       EQU  LCD_WF15TO12
LCD_WF16_REG       EQU  LCD_WF19TO16
LCD_WF17_REG       EQU  LCD_WF19TO16
LCD_WF18_REG       EQU  LCD_WF19TO16
LCD_WF19_REG       EQU  LCD_WF19TO16
LCD_WF20_REG       EQU  LCD_WF23TO20
LCD_WF21_REG       EQU  LCD_WF23TO20
LCD_WF22_REG       EQU  LCD_WF23TO20
LCD_WF23_REG       EQU  LCD_WF23TO20
LCD_WF24_REG       EQU  LCD_WF27TO24
LCD_WF25_REG       EQU  LCD_WF27TO24
LCD_WF26_REG       EQU  LCD_WF27TO24
LCD_WF27_REG       EQU  LCD_WF27TO24
LCD_WF28_REG       EQU  LCD_WF31TO28
LCD_WF29_REG       EQU  LCD_WF31TO28
LCD_WF30_REG       EQU  LCD_WF31TO28
LCD_WF31_REG       EQU  LCD_WF31TO28
LCD_WF32_REG       EQU  LCD_WF35TO32
LCD_WF33_REG       EQU  LCD_WF35TO32
LCD_WF34_REG       EQU  LCD_WF35TO32
LCD_WF35_REG       EQU  LCD_WF35TO32
LCD_WF36_REG       EQU  LCD_WF39TO36
LCD_WF37_REG       EQU  LCD_WF39TO36
LCD_WF38_REG       EQU  LCD_WF39TO36
LCD_WF39_REG       EQU  LCD_WF39TO36
LCD_WF40_REG       EQU  LCD_WF43TO40
LCD_WF41_REG       EQU  LCD_WF43TO40
LCD_WF42_REG       EQU  LCD_WF43TO40
LCD_WF43_REG       EQU  LCD_WF43TO40
LCD_WF44_REG       EQU  LCD_WF47TO44
LCD_WF45_REG       EQU  LCD_WF47TO44
LCD_WF46_REG       EQU  LCD_WF47TO44
LCD_WF47_REG       EQU  LCD_WF47TO44
LCD_WF48_REG       EQU  LCD_WF51TO48
LCD_WF49_REG       EQU  LCD_WF51TO48
LCD_WF50_REG       EQU  LCD_WF51TO48
LCD_WF51_REG       EQU  LCD_WF51TO48
LCD_WF52_REG       EQU  LCD_WF55TO52
LCD_WF53_REG       EQU  LCD_WF55TO52
LCD_WF54_REG       EQU  LCD_WF55TO52
LCD_WF55_REG       EQU  LCD_WF55TO52
LCD_WF56_REG       EQU  LCD_WF59TO56
LCD_WF57_REG       EQU  LCD_WF59TO56
LCD_WF58_REG       EQU  LCD_WF59TO56
LCD_WF59_REG       EQU  LCD_WF59TO56
LCD_WF60_REG       EQU  LCD_WF63TO60
LCD_WF61_REG       EQU  LCD_WF63TO60
LCD_WF62_REG       EQU  LCD_WF63TO60
LCD_WF63_REG       EQU  LCD_WF63TO60
;---------------------------------------------------------------
;/* WF Bit Fields */ from C MKL46Z4.h
LCD_WF_WF0_MASK    EQU  0xFF
LCD_WF_WF0_SHIFT   EQU  0
LCD_WF_WF60_MASK   EQU  0xFF
LCD_WF_WF60_SHIFT  EQU  0
LCD_WF_WF56_MASK   EQU  0xFF
LCD_WF_WF56_SHIFT  EQU  0
LCD_WF_WF52_MASK   EQU  0xFF
LCD_WF_WF52_SHIFT  EQU  0
LCD_WF_WF4_MASK    EQU  0xFF
LCD_WF_WF4_SHIFT   EQU  0
LCD_WF_WF48_MASK   EQU  0xFF
LCD_WF_WF48_SHIFT  EQU  0
LCD_WF_WF44_MASK   EQU  0xFF
LCD_WF_WF44_SHIFT  EQU  0
LCD_WF_WF40_MASK   EQU  0xFF
LCD_WF_WF40_SHIFT  EQU  0
LCD_WF_WF8_MASK    EQU  0xFF
LCD_WF_WF8_SHIFT   EQU  0
LCD_WF_WF36_MASK   EQU  0xFF
LCD_WF_WF36_SHIFT  EQU  0
LCD_WF_WF32_MASK   EQU  0xFF
LCD_WF_WF32_SHIFT  EQU  0
LCD_WF_WF28_MASK   EQU  0xFF
LCD_WF_WF28_SHIFT  EQU  0
LCD_WF_WF12_MASK   EQU  0xFF
LCD_WF_WF12_SHIFT  EQU  0
LCD_WF_WF24_MASK   EQU  0xFF
LCD_WF_WF24_SHIFT  EQU  0
LCD_WF_WF20_MASK   EQU  0xFF
LCD_WF_WF20_SHIFT  EQU  0
LCD_WF_WF16_MASK   EQU  0xFF
LCD_WF_WF16_SHIFT  EQU  0
LCD_WF_WF5_MASK    EQU  0xFF00
LCD_WF_WF5_SHIFT   EQU  8
LCD_WF_WF49_MASK   EQU  0xFF00
LCD_WF_WF49_SHIFT  EQU  8
LCD_WF_WF45_MASK   EQU  0xFF00
LCD_WF_WF45_SHIFT  EQU  8
LCD_WF_WF61_MASK   EQU  0xFF00
LCD_WF_WF61_SHIFT  EQU  8
LCD_WF_WF25_MASK   EQU  0xFF00
LCD_WF_WF25_SHIFT  EQU  8
LCD_WF_WF17_MASK   EQU  0xFF00
LCD_WF_WF17_SHIFT  EQU  8
LCD_WF_WF41_MASK   EQU  0xFF00
LCD_WF_WF41_SHIFT  EQU  8
LCD_WF_WF13_MASK   EQU  0xFF00
LCD_WF_WF13_SHIFT  EQU  8
LCD_WF_WF57_MASK   EQU  0xFF00
LCD_WF_WF57_SHIFT  EQU  8
LCD_WF_WF53_MASK   EQU  0xFF00
LCD_WF_WF53_SHIFT  EQU  8
LCD_WF_WF37_MASK   EQU  0xFF00
LCD_WF_WF37_SHIFT  EQU  8
LCD_WF_WF9_MASK    EQU  0xFF00
LCD_WF_WF9_SHIFT   EQU  8
LCD_WF_WF1_MASK    EQU  0xFF00
LCD_WF_WF1_SHIFT   EQU  8
LCD_WF_WF29_MASK   EQU  0xFF00
LCD_WF_WF29_SHIFT  EQU  8
LCD_WF_WF33_MASK   EQU  0xFF00
LCD_WF_WF33_SHIFT  EQU  8
LCD_WF_WF21_MASK   EQU  0xFF00
LCD_WF_WF21_SHIFT  EQU  8
LCD_WF_WF26_MASK   EQU  0xFF0000
LCD_WF_WF26_SHIFT  EQU  16
LCD_WF_WF46_MASK   EQU  0xFF0000
LCD_WF_WF46_SHIFT  EQU  16
LCD_WF_WF6_MASK    EQU  0xFF0000
LCD_WF_WF6_SHIFT   EQU  16
LCD_WF_WF42_MASK   EQU  0xFF0000
LCD_WF_WF42_SHIFT  EQU  16
LCD_WF_WF18_MASK   EQU  0xFF0000
LCD_WF_WF18_SHIFT  EQU  16
LCD_WF_WF38_MASK   EQU  0xFF0000
LCD_WF_WF38_SHIFT  EQU  16
LCD_WF_WF22_MASK   EQU  0xFF0000
LCD_WF_WF22_SHIFT  EQU  16
LCD_WF_WF34_MASK   EQU  0xFF0000
LCD_WF_WF34_SHIFT  EQU  16
LCD_WF_WF50_MASK   EQU  0xFF0000
LCD_WF_WF50_SHIFT  EQU  16
LCD_WF_WF14_MASK   EQU  0xFF0000
LCD_WF_WF14_SHIFT  EQU  16
LCD_WF_WF54_MASK   EQU  0xFF0000
LCD_WF_WF54_SHIFT  EQU  16
LCD_WF_WF2_MASK    EQU  0xFF0000
LCD_WF_WF2_SHIFT   EQU  16
LCD_WF_WF58_MASK   EQU  0xFF0000
LCD_WF_WF58_SHIFT  EQU  16
LCD_WF_WF30_MASK   EQU  0xFF0000
LCD_WF_WF30_SHIFT  EQU  16
LCD_WF_WF62_MASK   EQU  0xFF0000
LCD_WF_WF62_SHIFT  EQU  16
LCD_WF_WF10_MASK   EQU  0xFF0000
LCD_WF_WF10_SHIFT  EQU  16
LCD_WF_WF63_MASK   EQU  0xFF000000
LCD_WF_WF63_SHIFT  EQU  24
LCD_WF_WF59_MASK   EQU  0xFF000000
LCD_WF_WF59_SHIFT  EQU  24
LCD_WF_WF55_MASK   EQU  0xFF000000
LCD_WF_WF55_SHIFT  EQU  24
LCD_WF_WF3_MASK    EQU  0xFF000000
LCD_WF_WF3_SHIFT   EQU  24
LCD_WF_WF51_MASK   EQU  0xFF000000
LCD_WF_WF51_SHIFT  EQU  24
LCD_WF_WF47_MASK   EQU  0xFF000000
LCD_WF_WF47_SHIFT  EQU  24
LCD_WF_WF43_MASK   EQU  0xFF000000
LCD_WF_WF43_SHIFT  EQU  24
LCD_WF_WF7_MASK    EQU  0xFF000000
LCD_WF_WF7_SHIFT   EQU  24
LCD_WF_WF39_MASK   EQU  0xFF000000
LCD_WF_WF39_SHIFT  EQU  24
LCD_WF_WF35_MASK   EQU  0xFF000000
LCD_WF_WF35_SHIFT  EQU  24
LCD_WF_WF31_MASK   EQU  0xFF000000
LCD_WF_WF31_SHIFT  EQU  24
LCD_WF_WF11_MASK   EQU  0xFF000000
LCD_WF_WF11_SHIFT  EQU  24
LCD_WF_WF27_MASK   EQU  0xFF000000
LCD_WF_WF27_SHIFT  EQU  24
LCD_WF_WF23_MASK   EQU  0xFF000000
LCD_WF_WF23_SHIFT  EQU  24
LCD_WF_WF19_MASK   EQU  0xFF000000
LCD_WF_WF19_SHIFT  EQU  24
LCD_WF_WF15_MASK   EQU  0xFF000000
LCD_WF_WF15_SHIFT  EQU  24
;---------------------------------------------------------------
;WFn Custom bit field names (not in C MKL46Z4.h)
;Each byte WFn (n in {x, x+1, x+2, y}) controls an LCD pen
;          bit 7:segment/phase H
;          bit 6:segment/phase G
;          bit 5:segment/phase F
;          bit 4:segment/phase E
;          bit 3:segment/phase D
;          bit 2:segment/phase C
;          bit 1:segment/phase B
;          bit 0:segment/phase A:
;                value 0:  segment off or phase deactivtated
;                value 1:  segment on or phase activated
LCD_WF_A_MASK   EQU  0x01
LCD_WF_A_SHIFT  EQU  0
LCD_WF_B_MASK   EQU  0x02
LCD_WF_B_SHIFT  EQU  1
LCD_WF_C_MASK   EQU  0x04
LCD_WF_C_SHIFT  EQU  2
LCD_WF_D_MASK   EQU  0x08
LCD_WF_D_SHIFT  EQU  3
LCD_WF_E_MASK   EQU  0x10
LCD_WF_E_SHIFT  EQU  4
LCD_WF_F_MASK   EQU  0x20
LCD_WF_F_SHIFT  EQU  5
LCD_WF_G_MASK   EQU  0x40
LCD_WF_G_SHIFT  EQU  6
LCD_WF_H_MASK   EQU  0x80
LCD_WF_H_SHIFT  EQU  7
;---------------------------------------------------------------
;/* WF8B Bit Fields */
LCD_WF8B_BPALCD0_MASK    EQU  0x1
LCD_WF8B_BPALCD0_SHIFT   EQU  0
LCD_WF8B_BPALCD63_MASK   EQU  0x1
LCD_WF8B_BPALCD63_SHIFT  EQU  0
LCD_WF8B_BPALCD62_MASK   EQU  0x1
LCD_WF8B_BPALCD62_SHIFT  EQU  0
LCD_WF8B_BPALCD61_MASK   EQU  0x1
LCD_WF8B_BPALCD61_SHIFT  EQU  0
LCD_WF8B_BPALCD60_MASK   EQU  0x1
LCD_WF8B_BPALCD60_SHIFT  EQU  0
LCD_WF8B_BPALCD59_MASK   EQU  0x1
LCD_WF8B_BPALCD59_SHIFT  EQU  0
LCD_WF8B_BPALCD58_MASK   EQU  0x1
LCD_WF8B_BPALCD58_SHIFT  EQU  0
LCD_WF8B_BPALCD57_MASK   EQU  0x1
LCD_WF8B_BPALCD57_SHIFT  EQU  0
LCD_WF8B_BPALCD1_MASK    EQU  0x1
LCD_WF8B_BPALCD1_SHIFT   EQU  0
LCD_WF8B_BPALCD56_MASK   EQU  0x1
LCD_WF8B_BPALCD56_SHIFT  EQU  0
LCD_WF8B_BPALCD55_MASK   EQU  0x1
LCD_WF8B_BPALCD55_SHIFT  EQU  0
LCD_WF8B_BPALCD54_MASK   EQU  0x1
LCD_WF8B_BPALCD54_SHIFT  EQU  0
LCD_WF8B_BPALCD53_MASK   EQU  0x1
LCD_WF8B_BPALCD53_SHIFT  EQU  0
LCD_WF8B_BPALCD52_MASK   EQU  0x1
LCD_WF8B_BPALCD52_SHIFT  EQU  0
LCD_WF8B_BPALCD51_MASK   EQU  0x1
LCD_WF8B_BPALCD51_SHIFT  EQU  0
LCD_WF8B_BPALCD50_MASK   EQU  0x1
LCD_WF8B_BPALCD50_SHIFT  EQU  0
LCD_WF8B_BPALCD2_MASK    EQU  0x1
LCD_WF8B_BPALCD2_SHIFT   EQU  0
LCD_WF8B_BPALCD49_MASK   EQU  0x1
LCD_WF8B_BPALCD49_SHIFT  EQU  0
LCD_WF8B_BPALCD48_MASK   EQU  0x1
LCD_WF8B_BPALCD48_SHIFT  EQU  0
LCD_WF8B_BPALCD47_MASK   EQU  0x1
LCD_WF8B_BPALCD47_SHIFT  EQU  0
LCD_WF8B_BPALCD46_MASK   EQU  0x1
LCD_WF8B_BPALCD46_SHIFT  EQU  0
LCD_WF8B_BPALCD45_MASK   EQU  0x1
LCD_WF8B_BPALCD45_SHIFT  EQU  0
LCD_WF8B_BPALCD44_MASK   EQU  0x1
LCD_WF8B_BPALCD44_SHIFT  EQU  0
LCD_WF8B_BPALCD43_MASK   EQU  0x1
LCD_WF8B_BPALCD43_SHIFT  EQU  0
LCD_WF8B_BPALCD3_MASK    EQU  0x1
LCD_WF8B_BPALCD3_SHIFT   EQU  0
LCD_WF8B_BPALCD42_MASK   EQU  0x1
LCD_WF8B_BPALCD42_SHIFT  EQU  0
LCD_WF8B_BPALCD41_MASK   EQU  0x1
LCD_WF8B_BPALCD41_SHIFT  EQU  0
LCD_WF8B_BPALCD40_MASK   EQU  0x1
LCD_WF8B_BPALCD40_SHIFT  EQU  0
LCD_WF8B_BPALCD39_MASK   EQU  0x1
LCD_WF8B_BPALCD39_SHIFT  EQU  0
LCD_WF8B_BPALCD38_MASK   EQU  0x1
LCD_WF8B_BPALCD38_SHIFT  EQU  0
LCD_WF8B_BPALCD37_MASK   EQU  0x1
LCD_WF8B_BPALCD37_SHIFT  EQU  0
LCD_WF8B_BPALCD36_MASK   EQU  0x1
LCD_WF8B_BPALCD36_SHIFT  EQU  0
LCD_WF8B_BPALCD4_MASK    EQU  0x1
LCD_WF8B_BPALCD4_SHIFT   EQU  0
LCD_WF8B_BPALCD35_MASK   EQU  0x1
LCD_WF8B_BPALCD35_SHIFT  EQU  0
LCD_WF8B_BPALCD34_MASK   EQU  0x1
LCD_WF8B_BPALCD34_SHIFT  EQU  0
LCD_WF8B_BPALCD33_MASK   EQU  0x1
LCD_WF8B_BPALCD33_SHIFT  EQU  0
LCD_WF8B_BPALCD32_MASK   EQU  0x1
LCD_WF8B_BPALCD32_SHIFT  EQU  0
LCD_WF8B_BPALCD31_MASK   EQU  0x1
LCD_WF8B_BPALCD31_SHIFT  EQU  0
LCD_WF8B_BPALCD30_MASK   EQU  0x1
LCD_WF8B_BPALCD30_SHIFT  EQU  0
LCD_WF8B_BPALCD29_MASK   EQU  0x1
LCD_WF8B_BPALCD29_SHIFT  EQU  0
LCD_WF8B_BPALCD5_MASK    EQU  0x1
LCD_WF8B_BPALCD5_SHIFT   EQU  0
LCD_WF8B_BPALCD28_MASK   EQU  0x1
LCD_WF8B_BPALCD28_SHIFT  EQU  0
LCD_WF8B_BPALCD27_MASK   EQU  0x1
LCD_WF8B_BPALCD27_SHIFT  EQU  0
LCD_WF8B_BPALCD26_MASK   EQU  0x1
LCD_WF8B_BPALCD26_SHIFT  EQU  0
LCD_WF8B_BPALCD25_MASK   EQU  0x1
LCD_WF8B_BPALCD25_SHIFT  EQU  0
LCD_WF8B_BPALCD24_MASK   EQU  0x1
LCD_WF8B_BPALCD24_SHIFT  EQU  0
LCD_WF8B_BPALCD23_MASK   EQU  0x1
LCD_WF8B_BPALCD23_SHIFT  EQU  0
LCD_WF8B_BPALCD22_MASK   EQU  0x1
LCD_WF8B_BPALCD22_SHIFT  EQU  0
LCD_WF8B_BPALCD6_MASK    EQU  0x1
LCD_WF8B_BPALCD6_SHIFT   EQU  0
LCD_WF8B_BPALCD21_MASK   EQU  0x1
LCD_WF8B_BPALCD21_SHIFT  EQU  0
LCD_WF8B_BPALCD20_MASK   EQU  0x1
LCD_WF8B_BPALCD20_SHIFT  EQU  0
LCD_WF8B_BPALCD19_MASK   EQU  0x1
LCD_WF8B_BPALCD19_SHIFT  EQU  0
LCD_WF8B_BPALCD18_MASK   EQU  0x1
LCD_WF8B_BPALCD18_SHIFT  EQU  0
LCD_WF8B_BPALCD17_MASK   EQU  0x1
LCD_WF8B_BPALCD17_SHIFT  EQU  0
LCD_WF8B_BPALCD16_MASK   EQU  0x1
LCD_WF8B_BPALCD16_SHIFT  EQU  0
LCD_WF8B_BPALCD15_MASK   EQU  0x1
LCD_WF8B_BPALCD15_SHIFT  EQU  0
LCD_WF8B_BPALCD7_MASK    EQU  0x1
LCD_WF8B_BPALCD7_SHIFT   EQU  0
LCD_WF8B_BPALCD14_MASK   EQU  0x1
LCD_WF8B_BPALCD14_SHIFT  EQU  0
LCD_WF8B_BPALCD13_MASK   EQU  0x1
LCD_WF8B_BPALCD13_SHIFT  EQU  0
LCD_WF8B_BPALCD12_MASK   EQU  0x1
LCD_WF8B_BPALCD12_SHIFT  EQU  0
LCD_WF8B_BPALCD11_MASK   EQU  0x1
LCD_WF8B_BPALCD11_SHIFT  EQU  0
LCD_WF8B_BPALCD10_MASK   EQU  0x1
LCD_WF8B_BPALCD10_SHIFT  EQU  0
LCD_WF8B_BPALCD9_MASK    EQU  0x1
LCD_WF8B_BPALCD9_SHIFT   EQU  0
LCD_WF8B_BPALCD8_MASK    EQU  0x1
LCD_WF8B_BPALCD8_SHIFT   EQU  0
LCD_WF8B_BPBLCD1_MASK    EQU  0x2
LCD_WF8B_BPBLCD1_SHIFT   EQU  1
LCD_WF8B_BPBLCD32_MASK   EQU  0x2
LCD_WF8B_BPBLCD32_SHIFT  EQU  1
LCD_WF8B_BPBLCD30_MASK   EQU  0x2
LCD_WF8B_BPBLCD30_SHIFT  EQU  1
LCD_WF8B_BPBLCD60_MASK   EQU  0x2
LCD_WF8B_BPBLCD60_SHIFT  EQU  1
LCD_WF8B_BPBLCD24_MASK   EQU  0x2
LCD_WF8B_BPBLCD24_SHIFT  EQU  1
LCD_WF8B_BPBLCD28_MASK   EQU  0x2
LCD_WF8B_BPBLCD28_SHIFT  EQU  1
LCD_WF8B_BPBLCD23_MASK   EQU  0x2
LCD_WF8B_BPBLCD23_SHIFT  EQU  1
LCD_WF8B_BPBLCD48_MASK   EQU  0x2
LCD_WF8B_BPBLCD48_SHIFT  EQU  1
LCD_WF8B_BPBLCD10_MASK   EQU  0x2
LCD_WF8B_BPBLCD10_SHIFT  EQU  1
LCD_WF8B_BPBLCD15_MASK   EQU  0x2
LCD_WF8B_BPBLCD15_SHIFT  EQU  1
LCD_WF8B_BPBLCD36_MASK   EQU  0x2
LCD_WF8B_BPBLCD36_SHIFT  EQU  1
LCD_WF8B_BPBLCD44_MASK   EQU  0x2
LCD_WF8B_BPBLCD44_SHIFT  EQU  1
LCD_WF8B_BPBLCD62_MASK   EQU  0x2
LCD_WF8B_BPBLCD62_SHIFT  EQU  1
LCD_WF8B_BPBLCD53_MASK   EQU  0x2
LCD_WF8B_BPBLCD53_SHIFT  EQU  1
LCD_WF8B_BPBLCD22_MASK   EQU  0x2
LCD_WF8B_BPBLCD22_SHIFT  EQU  1
LCD_WF8B_BPBLCD47_MASK   EQU  0x2
LCD_WF8B_BPBLCD47_SHIFT  EQU  1
LCD_WF8B_BPBLCD33_MASK   EQU  0x2
LCD_WF8B_BPBLCD33_SHIFT  EQU  1
LCD_WF8B_BPBLCD2_MASK    EQU  0x2
LCD_WF8B_BPBLCD2_SHIFT   EQU  1
LCD_WF8B_BPBLCD49_MASK   EQU  0x2
LCD_WF8B_BPBLCD49_SHIFT  EQU  1
LCD_WF8B_BPBLCD0_MASK    EQU  0x2
LCD_WF8B_BPBLCD0_SHIFT   EQU  1
LCD_WF8B_BPBLCD55_MASK   EQU  0x2
LCD_WF8B_BPBLCD55_SHIFT  EQU  1
LCD_WF8B_BPBLCD56_MASK   EQU  0x2
LCD_WF8B_BPBLCD56_SHIFT  EQU  1
LCD_WF8B_BPBLCD21_MASK   EQU  0x2
LCD_WF8B_BPBLCD21_SHIFT  EQU  1
LCD_WF8B_BPBLCD6_MASK    EQU  0x2
LCD_WF8B_BPBLCD6_SHIFT   EQU  1
LCD_WF8B_BPBLCD29_MASK   EQU  0x2
LCD_WF8B_BPBLCD29_SHIFT  EQU  1
LCD_WF8B_BPBLCD25_MASK   EQU  0x2
LCD_WF8B_BPBLCD25_SHIFT  EQU  1
LCD_WF8B_BPBLCD8_MASK    EQU  0x2
LCD_WF8B_BPBLCD8_SHIFT   EQU  1
LCD_WF8B_BPBLCD54_MASK   EQU  0x2
LCD_WF8B_BPBLCD54_SHIFT  EQU  1
LCD_WF8B_BPBLCD38_MASK   EQU  0x2
LCD_WF8B_BPBLCD38_SHIFT  EQU  1
LCD_WF8B_BPBLCD43_MASK   EQU  0x2
LCD_WF8B_BPBLCD43_SHIFT  EQU  1
LCD_WF8B_BPBLCD20_MASK   EQU  0x2
LCD_WF8B_BPBLCD20_SHIFT  EQU  1
LCD_WF8B_BPBLCD9_MASK    EQU  0x2
LCD_WF8B_BPBLCD9_SHIFT   EQU  1
LCD_WF8B_BPBLCD7_MASK    EQU  0x2
LCD_WF8B_BPBLCD7_SHIFT   EQU  1
LCD_WF8B_BPBLCD50_MASK   EQU  0x2
LCD_WF8B_BPBLCD50_SHIFT  EQU  1
LCD_WF8B_BPBLCD40_MASK   EQU  0x2
LCD_WF8B_BPBLCD40_SHIFT  EQU  1
LCD_WF8B_BPBLCD63_MASK   EQU  0x2
LCD_WF8B_BPBLCD63_SHIFT  EQU  1
LCD_WF8B_BPBLCD26_MASK   EQU  0x2
LCD_WF8B_BPBLCD26_SHIFT  EQU  1
LCD_WF8B_BPBLCD12_MASK   EQU  0x2
LCD_WF8B_BPBLCD12_SHIFT  EQU  1
LCD_WF8B_BPBLCD19_MASK   EQU  0x2
LCD_WF8B_BPBLCD19_SHIFT  EQU  1
LCD_WF8B_BPBLCD34_MASK   EQU  0x2
LCD_WF8B_BPBLCD34_SHIFT  EQU  1
LCD_WF8B_BPBLCD39_MASK   EQU  0x2
LCD_WF8B_BPBLCD39_SHIFT  EQU  1
LCD_WF8B_BPBLCD59_MASK   EQU  0x2
LCD_WF8B_BPBLCD59_SHIFT  EQU  1
LCD_WF8B_BPBLCD61_MASK   EQU  0x2
LCD_WF8B_BPBLCD61_SHIFT  EQU  1
LCD_WF8B_BPBLCD37_MASK   EQU  0x2
LCD_WF8B_BPBLCD37_SHIFT  EQU  1
LCD_WF8B_BPBLCD31_MASK   EQU  0x2
LCD_WF8B_BPBLCD31_SHIFT  EQU  1
LCD_WF8B_BPBLCD58_MASK   EQU  0x2
LCD_WF8B_BPBLCD58_SHIFT  EQU  1
LCD_WF8B_BPBLCD18_MASK   EQU  0x2
LCD_WF8B_BPBLCD18_SHIFT  EQU  1
LCD_WF8B_BPBLCD45_MASK   EQU  0x2
LCD_WF8B_BPBLCD45_SHIFT  EQU  1
LCD_WF8B_BPBLCD27_MASK   EQU  0x2
LCD_WF8B_BPBLCD27_SHIFT  EQU  1
LCD_WF8B_BPBLCD14_MASK   EQU  0x2
LCD_WF8B_BPBLCD14_SHIFT  EQU  1
LCD_WF8B_BPBLCD51_MASK   EQU  0x2
LCD_WF8B_BPBLCD51_SHIFT  EQU  1
LCD_WF8B_BPBLCD52_MASK   EQU  0x2
LCD_WF8B_BPBLCD52_SHIFT  EQU  1
LCD_WF8B_BPBLCD4_MASK    EQU  0x2
LCD_WF8B_BPBLCD4_SHIFT   EQU  1
LCD_WF8B_BPBLCD35_MASK   EQU  0x2
LCD_WF8B_BPBLCD35_SHIFT  EQU  1
LCD_WF8B_BPBLCD17_MASK   EQU  0x2
LCD_WF8B_BPBLCD17_SHIFT  EQU  1
LCD_WF8B_BPBLCD41_MASK   EQU  0x2
LCD_WF8B_BPBLCD41_SHIFT  EQU  1
LCD_WF8B_BPBLCD11_MASK   EQU  0x2
LCD_WF8B_BPBLCD11_SHIFT  EQU  1
LCD_WF8B_BPBLCD46_MASK   EQU  0x2
LCD_WF8B_BPBLCD46_SHIFT  EQU  1
LCD_WF8B_BPBLCD57_MASK   EQU  0x2
LCD_WF8B_BPBLCD57_SHIFT  EQU  1
LCD_WF8B_BPBLCD42_MASK   EQU  0x2
LCD_WF8B_BPBLCD42_SHIFT  EQU  1
LCD_WF8B_BPBLCD5_MASK    EQU  0x2
LCD_WF8B_BPBLCD5_SHIFT   EQU  1
LCD_WF8B_BPBLCD3_MASK    EQU  0x2
LCD_WF8B_BPBLCD3_SHIFT   EQU  1
LCD_WF8B_BPBLCD16_MASK   EQU  0x2
LCD_WF8B_BPBLCD16_SHIFT  EQU  1
LCD_WF8B_BPBLCD13_MASK   EQU  0x2
LCD_WF8B_BPBLCD13_SHIFT  EQU  1
LCD_WF8B_BPCLCD10_MASK   EQU  0x4
LCD_WF8B_BPCLCD10_SHIFT  EQU  2
LCD_WF8B_BPCLCD55_MASK   EQU  0x4
LCD_WF8B_BPCLCD55_SHIFT  EQU  2
LCD_WF8B_BPCLCD2_MASK    EQU  0x4
LCD_WF8B_BPCLCD2_SHIFT   EQU  2
LCD_WF8B_BPCLCD23_MASK   EQU  0x4
LCD_WF8B_BPCLCD23_SHIFT  EQU  2
LCD_WF8B_BPCLCD48_MASK   EQU  0x4
LCD_WF8B_BPCLCD48_SHIFT  EQU  2
LCD_WF8B_BPCLCD24_MASK   EQU  0x4
LCD_WF8B_BPCLCD24_SHIFT  EQU  2
LCD_WF8B_BPCLCD60_MASK   EQU  0x4
LCD_WF8B_BPCLCD60_SHIFT  EQU  2
LCD_WF8B_BPCLCD47_MASK   EQU  0x4
LCD_WF8B_BPCLCD47_SHIFT  EQU  2
LCD_WF8B_BPCLCD22_MASK   EQU  0x4
LCD_WF8B_BPCLCD22_SHIFT  EQU  2
LCD_WF8B_BPCLCD8_MASK    EQU  0x4
LCD_WF8B_BPCLCD8_SHIFT   EQU  2
LCD_WF8B_BPCLCD21_MASK   EQU  0x4
LCD_WF8B_BPCLCD21_SHIFT  EQU  2
LCD_WF8B_BPCLCD49_MASK   EQU  0x4
LCD_WF8B_BPCLCD49_SHIFT  EQU  2
LCD_WF8B_BPCLCD25_MASK   EQU  0x4
LCD_WF8B_BPCLCD25_SHIFT  EQU  2
LCD_WF8B_BPCLCD1_MASK    EQU  0x4
LCD_WF8B_BPCLCD1_SHIFT   EQU  2
LCD_WF8B_BPCLCD20_MASK   EQU  0x4
LCD_WF8B_BPCLCD20_SHIFT  EQU  2
LCD_WF8B_BPCLCD50_MASK   EQU  0x4
LCD_WF8B_BPCLCD50_SHIFT  EQU  2
LCD_WF8B_BPCLCD19_MASK   EQU  0x4
LCD_WF8B_BPCLCD19_SHIFT  EQU  2
LCD_WF8B_BPCLCD26_MASK   EQU  0x4
LCD_WF8B_BPCLCD26_SHIFT  EQU  2
LCD_WF8B_BPCLCD59_MASK   EQU  0x4
LCD_WF8B_BPCLCD59_SHIFT  EQU  2
LCD_WF8B_BPCLCD61_MASK   EQU  0x4
LCD_WF8B_BPCLCD61_SHIFT  EQU  2
LCD_WF8B_BPCLCD46_MASK   EQU  0x4
LCD_WF8B_BPCLCD46_SHIFT  EQU  2
LCD_WF8B_BPCLCD18_MASK   EQU  0x4
LCD_WF8B_BPCLCD18_SHIFT  EQU  2
LCD_WF8B_BPCLCD5_MASK    EQU  0x4
LCD_WF8B_BPCLCD5_SHIFT   EQU  2
LCD_WF8B_BPCLCD63_MASK   EQU  0x4
LCD_WF8B_BPCLCD63_SHIFT  EQU  2
LCD_WF8B_BPCLCD27_MASK   EQU  0x4
LCD_WF8B_BPCLCD27_SHIFT  EQU  2
LCD_WF8B_BPCLCD17_MASK   EQU  0x4
LCD_WF8B_BPCLCD17_SHIFT  EQU  2
LCD_WF8B_BPCLCD51_MASK   EQU  0x4
LCD_WF8B_BPCLCD51_SHIFT  EQU  2
LCD_WF8B_BPCLCD9_MASK    EQU  0x4
LCD_WF8B_BPCLCD9_SHIFT   EQU  2
LCD_WF8B_BPCLCD54_MASK   EQU  0x4
LCD_WF8B_BPCLCD54_SHIFT  EQU  2
LCD_WF8B_BPCLCD15_MASK   EQU  0x4
LCD_WF8B_BPCLCD15_SHIFT  EQU  2
LCD_WF8B_BPCLCD16_MASK   EQU  0x4
LCD_WF8B_BPCLCD16_SHIFT  EQU  2
LCD_WF8B_BPCLCD14_MASK   EQU  0x4
LCD_WF8B_BPCLCD14_SHIFT  EQU  2
LCD_WF8B_BPCLCD32_MASK   EQU  0x4
LCD_WF8B_BPCLCD32_SHIFT  EQU  2
LCD_WF8B_BPCLCD28_MASK   EQU  0x4
LCD_WF8B_BPCLCD28_SHIFT  EQU  2
LCD_WF8B_BPCLCD53_MASK   EQU  0x4
LCD_WF8B_BPCLCD53_SHIFT  EQU  2
LCD_WF8B_BPCLCD33_MASK   EQU  0x4
LCD_WF8B_BPCLCD33_SHIFT  EQU  2
LCD_WF8B_BPCLCD0_MASK    EQU  0x4
LCD_WF8B_BPCLCD0_SHIFT   EQU  2
LCD_WF8B_BPCLCD43_MASK   EQU  0x4
LCD_WF8B_BPCLCD43_SHIFT  EQU  2
LCD_WF8B_BPCLCD7_MASK    EQU  0x4
LCD_WF8B_BPCLCD7_SHIFT   EQU  2
LCD_WF8B_BPCLCD4_MASK    EQU  0x4
LCD_WF8B_BPCLCD4_SHIFT   EQU  2
LCD_WF8B_BPCLCD34_MASK   EQU  0x4
LCD_WF8B_BPCLCD34_SHIFT  EQU  2
LCD_WF8B_BPCLCD29_MASK   EQU  0x4
LCD_WF8B_BPCLCD29_SHIFT  EQU  2
LCD_WF8B_BPCLCD45_MASK   EQU  0x4
LCD_WF8B_BPCLCD45_SHIFT  EQU  2
LCD_WF8B_BPCLCD57_MASK   EQU  0x4
LCD_WF8B_BPCLCD57_SHIFT  EQU  2
LCD_WF8B_BPCLCD42_MASK   EQU  0x4
LCD_WF8B_BPCLCD42_SHIFT  EQU  2
LCD_WF8B_BPCLCD35_MASK   EQU  0x4
LCD_WF8B_BPCLCD35_SHIFT  EQU  2
LCD_WF8B_BPCLCD13_MASK   EQU  0x4
LCD_WF8B_BPCLCD13_SHIFT  EQU  2
LCD_WF8B_BPCLCD36_MASK   EQU  0x4
LCD_WF8B_BPCLCD36_SHIFT  EQU  2
LCD_WF8B_BPCLCD30_MASK   EQU  0x4
LCD_WF8B_BPCLCD30_SHIFT  EQU  2
LCD_WF8B_BPCLCD52_MASK   EQU  0x4
LCD_WF8B_BPCLCD52_SHIFT  EQU  2
LCD_WF8B_BPCLCD58_MASK   EQU  0x4
LCD_WF8B_BPCLCD58_SHIFT  EQU  2
LCD_WF8B_BPCLCD41_MASK   EQU  0x4
LCD_WF8B_BPCLCD41_SHIFT  EQU  2
LCD_WF8B_BPCLCD37_MASK   EQU  0x4
LCD_WF8B_BPCLCD37_SHIFT  EQU  2
LCD_WF8B_BPCLCD3_MASK    EQU  0x4
LCD_WF8B_BPCLCD3_SHIFT   EQU  2
LCD_WF8B_BPCLCD12_MASK   EQU  0x4
LCD_WF8B_BPCLCD12_SHIFT  EQU  2
LCD_WF8B_BPCLCD11_MASK   EQU  0x4
LCD_WF8B_BPCLCD11_SHIFT  EQU  2
LCD_WF8B_BPCLCD38_MASK   EQU  0x4
LCD_WF8B_BPCLCD38_SHIFT  EQU  2
LCD_WF8B_BPCLCD44_MASK   EQU  0x4
LCD_WF8B_BPCLCD44_SHIFT  EQU  2
LCD_WF8B_BPCLCD31_MASK   EQU  0x4
LCD_WF8B_BPCLCD31_SHIFT  EQU  2
LCD_WF8B_BPCLCD40_MASK   EQU  0x4
LCD_WF8B_BPCLCD40_SHIFT  EQU  2
LCD_WF8B_BPCLCD62_MASK   EQU  0x4
LCD_WF8B_BPCLCD62_SHIFT  EQU  2
LCD_WF8B_BPCLCD56_MASK   EQU  0x4
LCD_WF8B_BPCLCD56_SHIFT  EQU  2
LCD_WF8B_BPCLCD39_MASK   EQU  0x4
LCD_WF8B_BPCLCD39_SHIFT  EQU  2
LCD_WF8B_BPCLCD6_MASK    EQU  0x4
LCD_WF8B_BPCLCD6_SHIFT   EQU  2
LCD_WF8B_BPDLCD47_MASK   EQU  0x8
LCD_WF8B_BPDLCD47_SHIFT  EQU  3
LCD_WF8B_BPDLCD23_MASK   EQU  0x8
LCD_WF8B_BPDLCD23_SHIFT  EQU  3
LCD_WF8B_BPDLCD48_MASK   EQU  0x8
LCD_WF8B_BPDLCD48_SHIFT  EQU  3
LCD_WF8B_BPDLCD24_MASK   EQU  0x8
LCD_WF8B_BPDLCD24_SHIFT  EQU  3
LCD_WF8B_BPDLCD15_MASK   EQU  0x8
LCD_WF8B_BPDLCD15_SHIFT  EQU  3
LCD_WF8B_BPDLCD22_MASK   EQU  0x8
LCD_WF8B_BPDLCD22_SHIFT  EQU  3
LCD_WF8B_BPDLCD60_MASK   EQU  0x8
LCD_WF8B_BPDLCD60_SHIFT  EQU  3
LCD_WF8B_BPDLCD10_MASK   EQU  0x8
LCD_WF8B_BPDLCD10_SHIFT  EQU  3
LCD_WF8B_BPDLCD21_MASK   EQU  0x8
LCD_WF8B_BPDLCD21_SHIFT  EQU  3
LCD_WF8B_BPDLCD49_MASK   EQU  0x8
LCD_WF8B_BPDLCD49_SHIFT  EQU  3
LCD_WF8B_BPDLCD1_MASK    EQU  0x8
LCD_WF8B_BPDLCD1_SHIFT   EQU  3
LCD_WF8B_BPDLCD25_MASK   EQU  0x8
LCD_WF8B_BPDLCD25_SHIFT  EQU  3
LCD_WF8B_BPDLCD20_MASK   EQU  0x8
LCD_WF8B_BPDLCD20_SHIFT  EQU  3
LCD_WF8B_BPDLCD2_MASK    EQU  0x8
LCD_WF8B_BPDLCD2_SHIFT   EQU  3
LCD_WF8B_BPDLCD55_MASK   EQU  0x8
LCD_WF8B_BPDLCD55_SHIFT  EQU  3
LCD_WF8B_BPDLCD59_MASK   EQU  0x8
LCD_WF8B_BPDLCD59_SHIFT  EQU  3
LCD_WF8B_BPDLCD5_MASK    EQU  0x8
LCD_WF8B_BPDLCD5_SHIFT   EQU  3
LCD_WF8B_BPDLCD19_MASK   EQU  0x8
LCD_WF8B_BPDLCD19_SHIFT  EQU  3
LCD_WF8B_BPDLCD6_MASK    EQU  0x8
LCD_WF8B_BPDLCD6_SHIFT   EQU  3
LCD_WF8B_BPDLCD26_MASK   EQU  0x8
LCD_WF8B_BPDLCD26_SHIFT  EQU  3
LCD_WF8B_BPDLCD0_MASK    EQU  0x8
LCD_WF8B_BPDLCD0_SHIFT   EQU  3
LCD_WF8B_BPDLCD50_MASK   EQU  0x8
LCD_WF8B_BPDLCD50_SHIFT  EQU  3
LCD_WF8B_BPDLCD46_MASK   EQU  0x8
LCD_WF8B_BPDLCD46_SHIFT  EQU  3
LCD_WF8B_BPDLCD18_MASK   EQU  0x8
LCD_WF8B_BPDLCD18_SHIFT  EQU  3
LCD_WF8B_BPDLCD61_MASK   EQU  0x8
LCD_WF8B_BPDLCD61_SHIFT  EQU  3
LCD_WF8B_BPDLCD9_MASK    EQU  0x8
LCD_WF8B_BPDLCD9_SHIFT   EQU  3
LCD_WF8B_BPDLCD17_MASK   EQU  0x8
LCD_WF8B_BPDLCD17_SHIFT  EQU  3
LCD_WF8B_BPDLCD27_MASK   EQU  0x8
LCD_WF8B_BPDLCD27_SHIFT  EQU  3
LCD_WF8B_BPDLCD53_MASK   EQU  0x8
LCD_WF8B_BPDLCD53_SHIFT  EQU  3
LCD_WF8B_BPDLCD51_MASK   EQU  0x8
LCD_WF8B_BPDLCD51_SHIFT  EQU  3
LCD_WF8B_BPDLCD54_MASK   EQU  0x8
LCD_WF8B_BPDLCD54_SHIFT  EQU  3
LCD_WF8B_BPDLCD13_MASK   EQU  0x8
LCD_WF8B_BPDLCD13_SHIFT  EQU  3
LCD_WF8B_BPDLCD16_MASK   EQU  0x8
LCD_WF8B_BPDLCD16_SHIFT  EQU  3
LCD_WF8B_BPDLCD32_MASK   EQU  0x8
LCD_WF8B_BPDLCD32_SHIFT  EQU  3
LCD_WF8B_BPDLCD14_MASK   EQU  0x8
LCD_WF8B_BPDLCD14_SHIFT  EQU  3
LCD_WF8B_BPDLCD28_MASK   EQU  0x8
LCD_WF8B_BPDLCD28_SHIFT  EQU  3
LCD_WF8B_BPDLCD43_MASK   EQU  0x8
LCD_WF8B_BPDLCD43_SHIFT  EQU  3
LCD_WF8B_BPDLCD4_MASK    EQU  0x8
LCD_WF8B_BPDLCD4_SHIFT   EQU  3
LCD_WF8B_BPDLCD45_MASK   EQU  0x8
LCD_WF8B_BPDLCD45_SHIFT  EQU  3
LCD_WF8B_BPDLCD8_MASK    EQU  0x8
LCD_WF8B_BPDLCD8_SHIFT   EQU  3
LCD_WF8B_BPDLCD62_MASK   EQU  0x8
LCD_WF8B_BPDLCD62_SHIFT  EQU  3
LCD_WF8B_BPDLCD33_MASK   EQU  0x8
LCD_WF8B_BPDLCD33_SHIFT  EQU  3
LCD_WF8B_BPDLCD34_MASK   EQU  0x8
LCD_WF8B_BPDLCD34_SHIFT  EQU  3
LCD_WF8B_BPDLCD29_MASK   EQU  0x8
LCD_WF8B_BPDLCD29_SHIFT  EQU  3
LCD_WF8B_BPDLCD58_MASK   EQU  0x8
LCD_WF8B_BPDLCD58_SHIFT  EQU  3
LCD_WF8B_BPDLCD57_MASK   EQU  0x8
LCD_WF8B_BPDLCD57_SHIFT  EQU  3
LCD_WF8B_BPDLCD42_MASK   EQU  0x8
LCD_WF8B_BPDLCD42_SHIFT  EQU  3
LCD_WF8B_BPDLCD35_MASK   EQU  0x8
LCD_WF8B_BPDLCD35_SHIFT  EQU  3
LCD_WF8B_BPDLCD52_MASK   EQU  0x8
LCD_WF8B_BPDLCD52_SHIFT  EQU  3
LCD_WF8B_BPDLCD7_MASK    EQU  0x8
LCD_WF8B_BPDLCD7_SHIFT   EQU  3
LCD_WF8B_BPDLCD36_MASK   EQU  0x8
LCD_WF8B_BPDLCD36_SHIFT  EQU  3
LCD_WF8B_BPDLCD30_MASK   EQU  0x8
LCD_WF8B_BPDLCD30_SHIFT  EQU  3
LCD_WF8B_BPDLCD41_MASK   EQU  0x8
LCD_WF8B_BPDLCD41_SHIFT  EQU  3
LCD_WF8B_BPDLCD37_MASK   EQU  0x8
LCD_WF8B_BPDLCD37_SHIFT  EQU  3
LCD_WF8B_BPDLCD44_MASK   EQU  0x8
LCD_WF8B_BPDLCD44_SHIFT  EQU  3
LCD_WF8B_BPDLCD63_MASK   EQU  0x8
LCD_WF8B_BPDLCD63_SHIFT  EQU  3
LCD_WF8B_BPDLCD38_MASK   EQU  0x8
LCD_WF8B_BPDLCD38_SHIFT  EQU  3
LCD_WF8B_BPDLCD56_MASK   EQU  0x8
LCD_WF8B_BPDLCD56_SHIFT  EQU  3
LCD_WF8B_BPDLCD40_MASK   EQU  0x8
LCD_WF8B_BPDLCD40_SHIFT  EQU  3
LCD_WF8B_BPDLCD31_MASK   EQU  0x8
LCD_WF8B_BPDLCD31_SHIFT  EQU  3
LCD_WF8B_BPDLCD12_MASK   EQU  0x8
LCD_WF8B_BPDLCD12_SHIFT  EQU  3
LCD_WF8B_BPDLCD39_MASK   EQU  0x8
LCD_WF8B_BPDLCD39_SHIFT  EQU  3
LCD_WF8B_BPDLCD3_MASK    EQU  0x8
LCD_WF8B_BPDLCD3_SHIFT   EQU  3
LCD_WF8B_BPDLCD11_MASK   EQU  0x8
LCD_WF8B_BPDLCD11_SHIFT  EQU  3
LCD_WF8B_BPELCD12_MASK   EQU  0x10
LCD_WF8B_BPELCD12_SHIFT  EQU  4
LCD_WF8B_BPELCD39_MASK   EQU  0x10
LCD_WF8B_BPELCD39_SHIFT  EQU  4
LCD_WF8B_BPELCD3_MASK    EQU  0x10
LCD_WF8B_BPELCD3_SHIFT   EQU  4
LCD_WF8B_BPELCD38_MASK   EQU  0x10
LCD_WF8B_BPELCD38_SHIFT  EQU  4
LCD_WF8B_BPELCD40_MASK   EQU  0x10
LCD_WF8B_BPELCD40_SHIFT  EQU  4
LCD_WF8B_BPELCD37_MASK   EQU  0x10
LCD_WF8B_BPELCD37_SHIFT  EQU  4
LCD_WF8B_BPELCD41_MASK   EQU  0x10
LCD_WF8B_BPELCD41_SHIFT  EQU  4
LCD_WF8B_BPELCD36_MASK   EQU  0x10
LCD_WF8B_BPELCD36_SHIFT  EQU  4
LCD_WF8B_BPELCD8_MASK    EQU  0x10
LCD_WF8B_BPELCD8_SHIFT   EQU  4
LCD_WF8B_BPELCD35_MASK   EQU  0x10
LCD_WF8B_BPELCD35_SHIFT  EQU  4
LCD_WF8B_BPELCD42_MASK   EQU  0x10
LCD_WF8B_BPELCD42_SHIFT  EQU  4
LCD_WF8B_BPELCD34_MASK   EQU  0x10
LCD_WF8B_BPELCD34_SHIFT  EQU  4
LCD_WF8B_BPELCD33_MASK   EQU  0x10
LCD_WF8B_BPELCD33_SHIFT  EQU  4
LCD_WF8B_BPELCD11_MASK   EQU  0x10
LCD_WF8B_BPELCD11_SHIFT  EQU  4
LCD_WF8B_BPELCD43_MASK   EQU  0x10
LCD_WF8B_BPELCD43_SHIFT  EQU  4
LCD_WF8B_BPELCD32_MASK   EQU  0x10
LCD_WF8B_BPELCD32_SHIFT  EQU  4
LCD_WF8B_BPELCD31_MASK   EQU  0x10
LCD_WF8B_BPELCD31_SHIFT  EQU  4
LCD_WF8B_BPELCD44_MASK   EQU  0x10
LCD_WF8B_BPELCD44_SHIFT  EQU  4
LCD_WF8B_BPELCD30_MASK   EQU  0x10
LCD_WF8B_BPELCD30_SHIFT  EQU  4
LCD_WF8B_BPELCD29_MASK   EQU  0x10
LCD_WF8B_BPELCD29_SHIFT  EQU  4
LCD_WF8B_BPELCD7_MASK    EQU  0x10
LCD_WF8B_BPELCD7_SHIFT   EQU  4
LCD_WF8B_BPELCD45_MASK   EQU  0x10
LCD_WF8B_BPELCD45_SHIFT  EQU  4
LCD_WF8B_BPELCD28_MASK   EQU  0x10
LCD_WF8B_BPELCD28_SHIFT  EQU  4
LCD_WF8B_BPELCD2_MASK    EQU  0x10
LCD_WF8B_BPELCD2_SHIFT   EQU  4
LCD_WF8B_BPELCD27_MASK   EQU  0x10
LCD_WF8B_BPELCD27_SHIFT  EQU  4
LCD_WF8B_BPELCD46_MASK   EQU  0x10
LCD_WF8B_BPELCD46_SHIFT  EQU  4
LCD_WF8B_BPELCD26_MASK   EQU  0x10
LCD_WF8B_BPELCD26_SHIFT  EQU  4
LCD_WF8B_BPELCD10_MASK   EQU  0x10
LCD_WF8B_BPELCD10_SHIFT  EQU  4
LCD_WF8B_BPELCD13_MASK   EQU  0x10
LCD_WF8B_BPELCD13_SHIFT  EQU  4
LCD_WF8B_BPELCD25_MASK   EQU  0x10
LCD_WF8B_BPELCD25_SHIFT  EQU  4
LCD_WF8B_BPELCD5_MASK    EQU  0x10
LCD_WF8B_BPELCD5_SHIFT   EQU  4
LCD_WF8B_BPELCD24_MASK   EQU  0x10
LCD_WF8B_BPELCD24_SHIFT  EQU  4
LCD_WF8B_BPELCD47_MASK   EQU  0x10
LCD_WF8B_BPELCD47_SHIFT  EQU  4
LCD_WF8B_BPELCD23_MASK   EQU  0x10
LCD_WF8B_BPELCD23_SHIFT  EQU  4
LCD_WF8B_BPELCD22_MASK   EQU  0x10
LCD_WF8B_BPELCD22_SHIFT  EQU  4
LCD_WF8B_BPELCD48_MASK   EQU  0x10
LCD_WF8B_BPELCD48_SHIFT  EQU  4
LCD_WF8B_BPELCD21_MASK   EQU  0x10
LCD_WF8B_BPELCD21_SHIFT  EQU  4
LCD_WF8B_BPELCD49_MASK   EQU  0x10
LCD_WF8B_BPELCD49_SHIFT  EQU  4
LCD_WF8B_BPELCD20_MASK   EQU  0x10
LCD_WF8B_BPELCD20_SHIFT  EQU  4
LCD_WF8B_BPELCD19_MASK   EQU  0x10
LCD_WF8B_BPELCD19_SHIFT  EQU  4
LCD_WF8B_BPELCD9_MASK    EQU  0x10
LCD_WF8B_BPELCD9_SHIFT   EQU  4
LCD_WF8B_BPELCD50_MASK   EQU  0x10
LCD_WF8B_BPELCD50_SHIFT  EQU  4
LCD_WF8B_BPELCD18_MASK   EQU  0x10
LCD_WF8B_BPELCD18_SHIFT  EQU  4
LCD_WF8B_BPELCD6_MASK    EQU  0x10
LCD_WF8B_BPELCD6_SHIFT   EQU  4
LCD_WF8B_BPELCD17_MASK   EQU  0x10
LCD_WF8B_BPELCD17_SHIFT  EQU  4
LCD_WF8B_BPELCD51_MASK   EQU  0x10
LCD_WF8B_BPELCD51_SHIFT  EQU  4
LCD_WF8B_BPELCD16_MASK   EQU  0x10
LCD_WF8B_BPELCD16_SHIFT  EQU  4
LCD_WF8B_BPELCD56_MASK   EQU  0x10
LCD_WF8B_BPELCD56_SHIFT  EQU  4
LCD_WF8B_BPELCD57_MASK   EQU  0x10
LCD_WF8B_BPELCD57_SHIFT  EQU  4
LCD_WF8B_BPELCD52_MASK   EQU  0x10
LCD_WF8B_BPELCD52_SHIFT  EQU  4
LCD_WF8B_BPELCD1_MASK    EQU  0x10
LCD_WF8B_BPELCD1_SHIFT   EQU  4
LCD_WF8B_BPELCD58_MASK   EQU  0x10
LCD_WF8B_BPELCD58_SHIFT  EQU  4
LCD_WF8B_BPELCD59_MASK   EQU  0x10
LCD_WF8B_BPELCD59_SHIFT  EQU  4
LCD_WF8B_BPELCD53_MASK   EQU  0x10
LCD_WF8B_BPELCD53_SHIFT  EQU  4
LCD_WF8B_BPELCD14_MASK   EQU  0x10
LCD_WF8B_BPELCD14_SHIFT  EQU  4
LCD_WF8B_BPELCD0_MASK    EQU  0x10
LCD_WF8B_BPELCD0_SHIFT   EQU  4
LCD_WF8B_BPELCD60_MASK   EQU  0x10
LCD_WF8B_BPELCD60_SHIFT  EQU  4
LCD_WF8B_BPELCD15_MASK   EQU  0x10
LCD_WF8B_BPELCD15_SHIFT  EQU  4
LCD_WF8B_BPELCD61_MASK   EQU  0x10
LCD_WF8B_BPELCD61_SHIFT  EQU  4
LCD_WF8B_BPELCD54_MASK   EQU  0x10
LCD_WF8B_BPELCD54_SHIFT  EQU  4
LCD_WF8B_BPELCD62_MASK   EQU  0x10
LCD_WF8B_BPELCD62_SHIFT  EQU  4
LCD_WF8B_BPELCD63_MASK   EQU  0x10
LCD_WF8B_BPELCD63_SHIFT  EQU  4
LCD_WF8B_BPELCD55_MASK   EQU  0x10
LCD_WF8B_BPELCD55_SHIFT  EQU  4
LCD_WF8B_BPELCD4_MASK    EQU  0x10
LCD_WF8B_BPELCD4_SHIFT   EQU  4
LCD_WF8B_BPFLCD13_MASK   EQU  0x20
LCD_WF8B_BPFLCD13_SHIFT  EQU  5
LCD_WF8B_BPFLCD39_MASK   EQU  0x20
LCD_WF8B_BPFLCD39_SHIFT  EQU  5
LCD_WF8B_BPFLCD55_MASK   EQU  0x20
LCD_WF8B_BPFLCD55_SHIFT  EQU  5
LCD_WF8B_BPFLCD47_MASK   EQU  0x20
LCD_WF8B_BPFLCD47_SHIFT  EQU  5
LCD_WF8B_BPFLCD63_MASK   EQU  0x20
LCD_WF8B_BPFLCD63_SHIFT  EQU  5
LCD_WF8B_BPFLCD43_MASK   EQU  0x20
LCD_WF8B_BPFLCD43_SHIFT  EQU  5
LCD_WF8B_BPFLCD5_MASK    EQU  0x20
LCD_WF8B_BPFLCD5_SHIFT   EQU  5
LCD_WF8B_BPFLCD62_MASK   EQU  0x20
LCD_WF8B_BPFLCD62_SHIFT  EQU  5
LCD_WF8B_BPFLCD14_MASK   EQU  0x20
LCD_WF8B_BPFLCD14_SHIFT  EQU  5
LCD_WF8B_BPFLCD24_MASK   EQU  0x20
LCD_WF8B_BPFLCD24_SHIFT  EQU  5
LCD_WF8B_BPFLCD54_MASK   EQU  0x20
LCD_WF8B_BPFLCD54_SHIFT  EQU  5
LCD_WF8B_BPFLCD15_MASK   EQU  0x20
LCD_WF8B_BPFLCD15_SHIFT  EQU  5
LCD_WF8B_BPFLCD32_MASK   EQU  0x20
LCD_WF8B_BPFLCD32_SHIFT  EQU  5
LCD_WF8B_BPFLCD61_MASK   EQU  0x20
LCD_WF8B_BPFLCD61_SHIFT  EQU  5
LCD_WF8B_BPFLCD25_MASK   EQU  0x20
LCD_WF8B_BPFLCD25_SHIFT  EQU  5
LCD_WF8B_BPFLCD60_MASK   EQU  0x20
LCD_WF8B_BPFLCD60_SHIFT  EQU  5
LCD_WF8B_BPFLCD41_MASK   EQU  0x20
LCD_WF8B_BPFLCD41_SHIFT  EQU  5
LCD_WF8B_BPFLCD33_MASK   EQU  0x20
LCD_WF8B_BPFLCD33_SHIFT  EQU  5
LCD_WF8B_BPFLCD53_MASK   EQU  0x20
LCD_WF8B_BPFLCD53_SHIFT  EQU  5
LCD_WF8B_BPFLCD59_MASK   EQU  0x20
LCD_WF8B_BPFLCD59_SHIFT  EQU  5
LCD_WF8B_BPFLCD0_MASK    EQU  0x20
LCD_WF8B_BPFLCD0_SHIFT   EQU  5
LCD_WF8B_BPFLCD46_MASK   EQU  0x20
LCD_WF8B_BPFLCD46_SHIFT  EQU  5
LCD_WF8B_BPFLCD58_MASK   EQU  0x20
LCD_WF8B_BPFLCD58_SHIFT  EQU  5
LCD_WF8B_BPFLCD26_MASK   EQU  0x20
LCD_WF8B_BPFLCD26_SHIFT  EQU  5
LCD_WF8B_BPFLCD36_MASK   EQU  0x20
LCD_WF8B_BPFLCD36_SHIFT  EQU  5
LCD_WF8B_BPFLCD10_MASK   EQU  0x20
LCD_WF8B_BPFLCD10_SHIFT  EQU  5
LCD_WF8B_BPFLCD52_MASK   EQU  0x20
LCD_WF8B_BPFLCD52_SHIFT  EQU  5
LCD_WF8B_BPFLCD57_MASK   EQU  0x20
LCD_WF8B_BPFLCD57_SHIFT  EQU  5
LCD_WF8B_BPFLCD27_MASK   EQU  0x20
LCD_WF8B_BPFLCD27_SHIFT  EQU  5
LCD_WF8B_BPFLCD11_MASK   EQU  0x20
LCD_WF8B_BPFLCD11_SHIFT  EQU  5
LCD_WF8B_BPFLCD56_MASK   EQU  0x20
LCD_WF8B_BPFLCD56_SHIFT  EQU  5
LCD_WF8B_BPFLCD1_MASK    EQU  0x20
LCD_WF8B_BPFLCD1_SHIFT   EQU  5
LCD_WF8B_BPFLCD8_MASK    EQU  0x20
LCD_WF8B_BPFLCD8_SHIFT   EQU  5
LCD_WF8B_BPFLCD40_MASK   EQU  0x20
LCD_WF8B_BPFLCD40_SHIFT  EQU  5
LCD_WF8B_BPFLCD51_MASK   EQU  0x20
LCD_WF8B_BPFLCD51_SHIFT  EQU  5
LCD_WF8B_BPFLCD16_MASK   EQU  0x20
LCD_WF8B_BPFLCD16_SHIFT  EQU  5
LCD_WF8B_BPFLCD45_MASK   EQU  0x20
LCD_WF8B_BPFLCD45_SHIFT  EQU  5
LCD_WF8B_BPFLCD6_MASK    EQU  0x20
LCD_WF8B_BPFLCD6_SHIFT   EQU  5
LCD_WF8B_BPFLCD17_MASK   EQU  0x20
LCD_WF8B_BPFLCD17_SHIFT  EQU  5
LCD_WF8B_BPFLCD28_MASK   EQU  0x20
LCD_WF8B_BPFLCD28_SHIFT  EQU  5
LCD_WF8B_BPFLCD42_MASK   EQU  0x20
LCD_WF8B_BPFLCD42_SHIFT  EQU  5
LCD_WF8B_BPFLCD29_MASK   EQU  0x20
LCD_WF8B_BPFLCD29_SHIFT  EQU  5
LCD_WF8B_BPFLCD50_MASK   EQU  0x20
LCD_WF8B_BPFLCD50_SHIFT  EQU  5
LCD_WF8B_BPFLCD18_MASK   EQU  0x20
LCD_WF8B_BPFLCD18_SHIFT  EQU  5
LCD_WF8B_BPFLCD34_MASK   EQU  0x20
LCD_WF8B_BPFLCD34_SHIFT  EQU  5
LCD_WF8B_BPFLCD19_MASK   EQU  0x20
LCD_WF8B_BPFLCD19_SHIFT  EQU  5
LCD_WF8B_BPFLCD2_MASK    EQU  0x20
LCD_WF8B_BPFLCD2_SHIFT   EQU  5
LCD_WF8B_BPFLCD9_MASK    EQU  0x20
LCD_WF8B_BPFLCD9_SHIFT   EQU  5
LCD_WF8B_BPFLCD3_MASK    EQU  0x20
LCD_WF8B_BPFLCD3_SHIFT   EQU  5
LCD_WF8B_BPFLCD37_MASK   EQU  0x20
LCD_WF8B_BPFLCD37_SHIFT  EQU  5
LCD_WF8B_BPFLCD49_MASK   EQU  0x20
LCD_WF8B_BPFLCD49_SHIFT  EQU  5
LCD_WF8B_BPFLCD20_MASK   EQU  0x20
LCD_WF8B_BPFLCD20_SHIFT  EQU  5
LCD_WF8B_BPFLCD44_MASK   EQU  0x20
LCD_WF8B_BPFLCD44_SHIFT  EQU  5
LCD_WF8B_BPFLCD30_MASK   EQU  0x20
LCD_WF8B_BPFLCD30_SHIFT  EQU  5
LCD_WF8B_BPFLCD21_MASK   EQU  0x20
LCD_WF8B_BPFLCD21_SHIFT  EQU  5
LCD_WF8B_BPFLCD35_MASK   EQU  0x20
LCD_WF8B_BPFLCD35_SHIFT  EQU  5
LCD_WF8B_BPFLCD4_MASK    EQU  0x20
LCD_WF8B_BPFLCD4_SHIFT   EQU  5
LCD_WF8B_BPFLCD31_MASK   EQU  0x20
LCD_WF8B_BPFLCD31_SHIFT  EQU  5
LCD_WF8B_BPFLCD48_MASK   EQU  0x20
LCD_WF8B_BPFLCD48_SHIFT  EQU  5
LCD_WF8B_BPFLCD7_MASK    EQU  0x20
LCD_WF8B_BPFLCD7_SHIFT   EQU  5
LCD_WF8B_BPFLCD22_MASK   EQU  0x20
LCD_WF8B_BPFLCD22_SHIFT  EQU  5
LCD_WF8B_BPFLCD38_MASK   EQU  0x20
LCD_WF8B_BPFLCD38_SHIFT  EQU  5
LCD_WF8B_BPFLCD12_MASK   EQU  0x20
LCD_WF8B_BPFLCD12_SHIFT  EQU  5
LCD_WF8B_BPFLCD23_MASK   EQU  0x20
LCD_WF8B_BPFLCD23_SHIFT  EQU  5
LCD_WF8B_BPGLCD14_MASK   EQU  0x40
LCD_WF8B_BPGLCD14_SHIFT  EQU  6
LCD_WF8B_BPGLCD55_MASK   EQU  0x40
LCD_WF8B_BPGLCD55_SHIFT  EQU  6
LCD_WF8B_BPGLCD63_MASK   EQU  0x40
LCD_WF8B_BPGLCD63_SHIFT  EQU  6
LCD_WF8B_BPGLCD15_MASK   EQU  0x40
LCD_WF8B_BPGLCD15_SHIFT  EQU  6
LCD_WF8B_BPGLCD62_MASK   EQU  0x40
LCD_WF8B_BPGLCD62_SHIFT  EQU  6
LCD_WF8B_BPGLCD54_MASK   EQU  0x40
LCD_WF8B_BPGLCD54_SHIFT  EQU  6
LCD_WF8B_BPGLCD61_MASK   EQU  0x40
LCD_WF8B_BPGLCD61_SHIFT  EQU  6
LCD_WF8B_BPGLCD60_MASK   EQU  0x40
LCD_WF8B_BPGLCD60_SHIFT  EQU  6
LCD_WF8B_BPGLCD59_MASK   EQU  0x40
LCD_WF8B_BPGLCD59_SHIFT  EQU  6
LCD_WF8B_BPGLCD53_MASK   EQU  0x40
LCD_WF8B_BPGLCD53_SHIFT  EQU  6
LCD_WF8B_BPGLCD58_MASK   EQU  0x40
LCD_WF8B_BPGLCD58_SHIFT  EQU  6
LCD_WF8B_BPGLCD0_MASK    EQU  0x40
LCD_WF8B_BPGLCD0_SHIFT   EQU  6
LCD_WF8B_BPGLCD57_MASK   EQU  0x40
LCD_WF8B_BPGLCD57_SHIFT  EQU  6
LCD_WF8B_BPGLCD52_MASK   EQU  0x40
LCD_WF8B_BPGLCD52_SHIFT  EQU  6
LCD_WF8B_BPGLCD7_MASK    EQU  0x40
LCD_WF8B_BPGLCD7_SHIFT   EQU  6
LCD_WF8B_BPGLCD56_MASK   EQU  0x40
LCD_WF8B_BPGLCD56_SHIFT  EQU  6
LCD_WF8B_BPGLCD6_MASK    EQU  0x40
LCD_WF8B_BPGLCD6_SHIFT   EQU  6
LCD_WF8B_BPGLCD51_MASK   EQU  0x40
LCD_WF8B_BPGLCD51_SHIFT  EQU  6
LCD_WF8B_BPGLCD16_MASK   EQU  0x40
LCD_WF8B_BPGLCD16_SHIFT  EQU  6
LCD_WF8B_BPGLCD1_MASK    EQU  0x40
LCD_WF8B_BPGLCD1_SHIFT   EQU  6
LCD_WF8B_BPGLCD17_MASK   EQU  0x40
LCD_WF8B_BPGLCD17_SHIFT  EQU  6
LCD_WF8B_BPGLCD50_MASK   EQU  0x40
LCD_WF8B_BPGLCD50_SHIFT  EQU  6
LCD_WF8B_BPGLCD18_MASK   EQU  0x40
LCD_WF8B_BPGLCD18_SHIFT  EQU  6
LCD_WF8B_BPGLCD19_MASK   EQU  0x40
LCD_WF8B_BPGLCD19_SHIFT  EQU  6
LCD_WF8B_BPGLCD8_MASK    EQU  0x40
LCD_WF8B_BPGLCD8_SHIFT   EQU  6
LCD_WF8B_BPGLCD49_MASK   EQU  0x40
LCD_WF8B_BPGLCD49_SHIFT  EQU  6
LCD_WF8B_BPGLCD20_MASK   EQU  0x40
LCD_WF8B_BPGLCD20_SHIFT  EQU  6
LCD_WF8B_BPGLCD9_MASK    EQU  0x40
LCD_WF8B_BPGLCD9_SHIFT   EQU  6
LCD_WF8B_BPGLCD21_MASK   EQU  0x40
LCD_WF8B_BPGLCD21_SHIFT  EQU  6
LCD_WF8B_BPGLCD13_MASK   EQU  0x40
LCD_WF8B_BPGLCD13_SHIFT  EQU  6
LCD_WF8B_BPGLCD48_MASK   EQU  0x40
LCD_WF8B_BPGLCD48_SHIFT  EQU  6
LCD_WF8B_BPGLCD22_MASK   EQU  0x40
LCD_WF8B_BPGLCD22_SHIFT  EQU  6
LCD_WF8B_BPGLCD5_MASK    EQU  0x40
LCD_WF8B_BPGLCD5_SHIFT   EQU  6
LCD_WF8B_BPGLCD47_MASK   EQU  0x40
LCD_WF8B_BPGLCD47_SHIFT  EQU  6
LCD_WF8B_BPGLCD23_MASK   EQU  0x40
LCD_WF8B_BPGLCD23_SHIFT  EQU  6
LCD_WF8B_BPGLCD24_MASK   EQU  0x40
LCD_WF8B_BPGLCD24_SHIFT  EQU  6
LCD_WF8B_BPGLCD25_MASK   EQU  0x40
LCD_WF8B_BPGLCD25_SHIFT  EQU  6
LCD_WF8B_BPGLCD46_MASK   EQU  0x40
LCD_WF8B_BPGLCD46_SHIFT  EQU  6
LCD_WF8B_BPGLCD26_MASK   EQU  0x40
LCD_WF8B_BPGLCD26_SHIFT  EQU  6
LCD_WF8B_BPGLCD27_MASK   EQU  0x40
LCD_WF8B_BPGLCD27_SHIFT  EQU  6
LCD_WF8B_BPGLCD10_MASK   EQU  0x40
LCD_WF8B_BPGLCD10_SHIFT  EQU  6
LCD_WF8B_BPGLCD45_MASK   EQU  0x40
LCD_WF8B_BPGLCD45_SHIFT  EQU  6
LCD_WF8B_BPGLCD28_MASK   EQU  0x40
LCD_WF8B_BPGLCD28_SHIFT  EQU  6
LCD_WF8B_BPGLCD29_MASK   EQU  0x40
LCD_WF8B_BPGLCD29_SHIFT  EQU  6
LCD_WF8B_BPGLCD4_MASK    EQU  0x40
LCD_WF8B_BPGLCD4_SHIFT   EQU  6
LCD_WF8B_BPGLCD44_MASK   EQU  0x40
LCD_WF8B_BPGLCD44_SHIFT  EQU  6
LCD_WF8B_BPGLCD30_MASK   EQU  0x40
LCD_WF8B_BPGLCD30_SHIFT  EQU  6
LCD_WF8B_BPGLCD2_MASK    EQU  0x40
LCD_WF8B_BPGLCD2_SHIFT   EQU  6
LCD_WF8B_BPGLCD31_MASK   EQU  0x40
LCD_WF8B_BPGLCD31_SHIFT  EQU  6
LCD_WF8B_BPGLCD43_MASK   EQU  0x40
LCD_WF8B_BPGLCD43_SHIFT  EQU  6
LCD_WF8B_BPGLCD32_MASK   EQU  0x40
LCD_WF8B_BPGLCD32_SHIFT  EQU  6
LCD_WF8B_BPGLCD33_MASK   EQU  0x40
LCD_WF8B_BPGLCD33_SHIFT  EQU  6
LCD_WF8B_BPGLCD42_MASK   EQU  0x40
LCD_WF8B_BPGLCD42_SHIFT  EQU  6
LCD_WF8B_BPGLCD34_MASK   EQU  0x40
LCD_WF8B_BPGLCD34_SHIFT  EQU  6
LCD_WF8B_BPGLCD11_MASK   EQU  0x40
LCD_WF8B_BPGLCD11_SHIFT  EQU  6
LCD_WF8B_BPGLCD35_MASK   EQU  0x40
LCD_WF8B_BPGLCD35_SHIFT  EQU  6
LCD_WF8B_BPGLCD12_MASK   EQU  0x40
LCD_WF8B_BPGLCD12_SHIFT  EQU  6
LCD_WF8B_BPGLCD41_MASK   EQU  0x40
LCD_WF8B_BPGLCD41_SHIFT  EQU  6
LCD_WF8B_BPGLCD36_MASK   EQU  0x40
LCD_WF8B_BPGLCD36_SHIFT  EQU  6
LCD_WF8B_BPGLCD3_MASK    EQU  0x40
LCD_WF8B_BPGLCD3_SHIFT   EQU  6
LCD_WF8B_BPGLCD37_MASK   EQU  0x40
LCD_WF8B_BPGLCD37_SHIFT  EQU  6
LCD_WF8B_BPGLCD40_MASK   EQU  0x40
LCD_WF8B_BPGLCD40_SHIFT  EQU  6
LCD_WF8B_BPGLCD38_MASK   EQU  0x40
LCD_WF8B_BPGLCD38_SHIFT  EQU  6
LCD_WF8B_BPGLCD39_MASK   EQU  0x40
LCD_WF8B_BPGLCD39_SHIFT  EQU  6
LCD_WF8B_BPHLCD63_MASK   EQU  0x80
LCD_WF8B_BPHLCD63_SHIFT  EQU  7
LCD_WF8B_BPHLCD62_MASK   EQU  0x80
LCD_WF8B_BPHLCD62_SHIFT  EQU  7
LCD_WF8B_BPHLCD61_MASK   EQU  0x80
LCD_WF8B_BPHLCD61_SHIFT  EQU  7
LCD_WF8B_BPHLCD60_MASK   EQU  0x80
LCD_WF8B_BPHLCD60_SHIFT  EQU  7
LCD_WF8B_BPHLCD59_MASK   EQU  0x80
LCD_WF8B_BPHLCD59_SHIFT  EQU  7
LCD_WF8B_BPHLCD58_MASK   EQU  0x80
LCD_WF8B_BPHLCD58_SHIFT  EQU  7
LCD_WF8B_BPHLCD57_MASK   EQU  0x80
LCD_WF8B_BPHLCD57_SHIFT  EQU  7
LCD_WF8B_BPHLCD0_MASK    EQU  0x80
LCD_WF8B_BPHLCD0_SHIFT   EQU  7
LCD_WF8B_BPHLCD56_MASK   EQU  0x80
LCD_WF8B_BPHLCD56_SHIFT  EQU  7
LCD_WF8B_BPHLCD55_MASK   EQU  0x80
LCD_WF8B_BPHLCD55_SHIFT  EQU  7
LCD_WF8B_BPHLCD54_MASK   EQU  0x80
LCD_WF8B_BPHLCD54_SHIFT  EQU  7
LCD_WF8B_BPHLCD53_MASK   EQU  0x80
LCD_WF8B_BPHLCD53_SHIFT  EQU  7
LCD_WF8B_BPHLCD52_MASK   EQU  0x80
LCD_WF8B_BPHLCD52_SHIFT  EQU  7
LCD_WF8B_BPHLCD51_MASK   EQU  0x80
LCD_WF8B_BPHLCD51_SHIFT  EQU  7
LCD_WF8B_BPHLCD50_MASK   EQU  0x80
LCD_WF8B_BPHLCD50_SHIFT  EQU  7
LCD_WF8B_BPHLCD1_MASK    EQU  0x80
LCD_WF8B_BPHLCD1_SHIFT   EQU  7
LCD_WF8B_BPHLCD49_MASK   EQU  0x80
LCD_WF8B_BPHLCD49_SHIFT  EQU  7
LCD_WF8B_BPHLCD48_MASK   EQU  0x80
LCD_WF8B_BPHLCD48_SHIFT  EQU  7
LCD_WF8B_BPHLCD47_MASK   EQU  0x80
LCD_WF8B_BPHLCD47_SHIFT  EQU  7
LCD_WF8B_BPHLCD46_MASK   EQU  0x80
LCD_WF8B_BPHLCD46_SHIFT  EQU  7
LCD_WF8B_BPHLCD45_MASK   EQU  0x80
LCD_WF8B_BPHLCD45_SHIFT  EQU  7
LCD_WF8B_BPHLCD44_MASK   EQU  0x80
LCD_WF8B_BPHLCD44_SHIFT  EQU  7
LCD_WF8B_BPHLCD43_MASK   EQU  0x80
LCD_WF8B_BPHLCD43_SHIFT  EQU  7
LCD_WF8B_BPHLCD2_MASK    EQU  0x80
LCD_WF8B_BPHLCD2_SHIFT   EQU  7
LCD_WF8B_BPHLCD42_MASK   EQU  0x80
LCD_WF8B_BPHLCD42_SHIFT  EQU  7
LCD_WF8B_BPHLCD41_MASK   EQU  0x80
LCD_WF8B_BPHLCD41_SHIFT  EQU  7
LCD_WF8B_BPHLCD40_MASK   EQU  0x80
LCD_WF8B_BPHLCD40_SHIFT  EQU  7
LCD_WF8B_BPHLCD39_MASK   EQU  0x80
LCD_WF8B_BPHLCD39_SHIFT  EQU  7
LCD_WF8B_BPHLCD38_MASK   EQU  0x80
LCD_WF8B_BPHLCD38_SHIFT  EQU  7
LCD_WF8B_BPHLCD37_MASK   EQU  0x80
LCD_WF8B_BPHLCD37_SHIFT  EQU  7
LCD_WF8B_BPHLCD36_MASK   EQU  0x80
LCD_WF8B_BPHLCD36_SHIFT  EQU  7
LCD_WF8B_BPHLCD3_MASK    EQU  0x80
LCD_WF8B_BPHLCD3_SHIFT   EQU  7
LCD_WF8B_BPHLCD35_MASK   EQU  0x80
LCD_WF8B_BPHLCD35_SHIFT  EQU  7
LCD_WF8B_BPHLCD34_MASK   EQU  0x80
LCD_WF8B_BPHLCD34_SHIFT  EQU  7
LCD_WF8B_BPHLCD33_MASK   EQU  0x80
LCD_WF8B_BPHLCD33_SHIFT  EQU  7
LCD_WF8B_BPHLCD32_MASK   EQU  0x80
LCD_WF8B_BPHLCD32_SHIFT  EQU  7
LCD_WF8B_BPHLCD31_MASK   EQU  0x80
LCD_WF8B_BPHLCD31_SHIFT  EQU  7
LCD_WF8B_BPHLCD30_MASK   EQU  0x80
LCD_WF8B_BPHLCD30_SHIFT  EQU  7
LCD_WF8B_BPHLCD29_MASK   EQU  0x80
LCD_WF8B_BPHLCD29_SHIFT  EQU  7
LCD_WF8B_BPHLCD4_MASK    EQU  0x80
LCD_WF8B_BPHLCD4_SHIFT   EQU  7
LCD_WF8B_BPHLCD28_MASK   EQU  0x80
LCD_WF8B_BPHLCD28_SHIFT  EQU  7
LCD_WF8B_BPHLCD27_MASK   EQU  0x80
LCD_WF8B_BPHLCD27_SHIFT  EQU  7
LCD_WF8B_BPHLCD26_MASK   EQU  0x80
LCD_WF8B_BPHLCD26_SHIFT  EQU  7
LCD_WF8B_BPHLCD25_MASK   EQU  0x80
LCD_WF8B_BPHLCD25_SHIFT  EQU  7
LCD_WF8B_BPHLCD24_MASK   EQU  0x80
LCD_WF8B_BPHLCD24_SHIFT  EQU  7
LCD_WF8B_BPHLCD23_MASK   EQU  0x80
LCD_WF8B_BPHLCD23_SHIFT  EQU  7
LCD_WF8B_BPHLCD22_MASK   EQU  0x80
LCD_WF8B_BPHLCD22_SHIFT  EQU  7
LCD_WF8B_BPHLCD5_MASK    EQU  0x80
LCD_WF8B_BPHLCD5_SHIFT   EQU  7
LCD_WF8B_BPHLCD21_MASK   EQU  0x80
LCD_WF8B_BPHLCD21_SHIFT  EQU  7
LCD_WF8B_BPHLCD20_MASK   EQU  0x80
LCD_WF8B_BPHLCD20_SHIFT  EQU  7
LCD_WF8B_BPHLCD19_MASK   EQU  0x80
LCD_WF8B_BPHLCD19_SHIFT  EQU  7
LCD_WF8B_BPHLCD18_MASK   EQU  0x80
LCD_WF8B_BPHLCD18_SHIFT  EQU  7
LCD_WF8B_BPHLCD17_MASK   EQU  0x80
LCD_WF8B_BPHLCD17_SHIFT  EQU  7
LCD_WF8B_BPHLCD16_MASK   EQU  0x80
LCD_WF8B_BPHLCD16_SHIFT  EQU  7
LCD_WF8B_BPHLCD15_MASK   EQU  0x80
LCD_WF8B_BPHLCD15_SHIFT  EQU  7
LCD_WF8B_BPHLCD6_MASK    EQU  0x80
LCD_WF8B_BPHLCD6_SHIFT   EQU  7
LCD_WF8B_BPHLCD14_MASK   EQU  0x80
LCD_WF8B_BPHLCD14_SHIFT  EQU  7
LCD_WF8B_BPHLCD13_MASK   EQU  0x80
LCD_WF8B_BPHLCD13_SHIFT  EQU  7
LCD_WF8B_BPHLCD12_MASK   EQU  0x80
LCD_WF8B_BPHLCD12_SHIFT  EQU  7
LCD_WF8B_BPHLCD11_MASK   EQU  0x80
LCD_WF8B_BPHLCD11_SHIFT  EQU  7
LCD_WF8B_BPHLCD10_MASK   EQU  0x80
LCD_WF8B_BPHLCD10_SHIFT  EQU  7
LCD_WF8B_BPHLCD9_MASK    EQU  0x80
LCD_WF8B_BPHLCD9_SHIFT   EQU  7
LCD_WF8B_BPHLCD8_MASK    EQU  0x80
LCD_WF8B_BPHLCD8_SHIFT   EQU  7
LCD_WF8B_BPHLCD7_MASK    EQU  0x80
LCD_WF8B_BPHLCD7_SHIFT   EQU  7
;---------------------------------------------------------------
;Multipurpose clock generator (MCG)
MCG_BASE          EQU  0x40064000
MCG_C1_OFFSET     EQU  0x00
MCG_C2_OFFSET     EQU  0x01
MCG_C4_OFFSET     EQU  0x03
MCG_C5_OFFSET     EQU  0x04
MCG_C6_OFFSET     EQU  0x05
MCG_S_OFFSET      EQU  0x06
MCG_C1            EQU  (MCG_BASE + MCG_C1_OFFSET)
MCG_C2            EQU  (MCG_BASE + MCG_C2_OFFSET)
MCG_C4            EQU  (MCG_BASE + MCG_C4_OFFSET)
MCG_C5            EQU  (MCG_BASE + MCG_C5_OFFSET)
MCG_C6            EQU  (MCG_BASE + MCG_C6_OFFSET)
MCG_S             EQU  (MCG_BASE + MCG_S_OFFSET)
;---------------------------------------------------------------
;MCG_C1 (0x04)
;7-6:CLKS=clock source select (00)
;        :00=output of FLL of PLL (depends on MCG_C6.PLLS)
;        :01=internal reference clock
;        :10=external reference clock
;        :11=(reserved)
;5-3:FRDIV=FLL external reference divider (000)
;    (depends on MCG_C2.RANGE0)
;         :first divider is for RANGE0=0
;         :second divider is for all other RANGE0 values
;         :000=  1 or   32
;         :001=  2 or   64
;         :010=  4 or  128
;         :011=  8 or  256
;         :100= 16 or  512
;         :101= 32 or 1024
;         :110= 64 or 1280
;         :111=128 or 1536
;  2:IREFS=internal reference select (for FLL) (1)
;         :0=external reference clock
;         :1=slow internal reference clock
;  1:IRCLKEN=internal reference clock (MCGIRCLK) enable (0)
;  0:IREFSTEN=internal reference stop enable (0)
MCG_C1_CLKS_MASK       EQU 0xC0
MCG_C1_CLKS_SHIFT      EQU 6
MCG_C1_FRDIV_MASK      EQU 0x38
MCG_C1_FRDIV_SHIFT     EQU 3
MCG_C1_IREFS_MASK      EQU 0x04
MCG_C1_IREFS_SHIFT     EQU 2
MCG_C1_IRCLKEN_MASK    EQU 0x02
MCG_C1_IRCLKEN_SHIFT   EQU 1
MCG_C1_IREFSTEN_MASK   EQU 0x01
MCG_C1_IREFSTEN_SHIFT  EQU 0
;---------------------------------------------------------------
;MCG_C2 (0xC0)
;  7:LOCRE0=loss of clock reset enable (1)
;          :0=interrupt request on loss of OCS0 external reference clock
;          :1=reset request on loss of OCS0 external reference clock
;  6:FCFTRIM=fast internal reference clock fine trim (1)
;5-4:RANGE0=frequency range select (00)
;          :00=low frequency range for crystal oscillator
;          :01=high frequency range for crystal oscillator
;          :1X=very high frequency range for crystal oscillator
;  3:HGO0=high gain oscillator select (0)
;        :0=low-power operation
;        :1=high-gain operation
;  2:EREFS0=external reference select (0)
;          :0=external reference clock
;          :1=oscillator
;  1:LP=low power select (0)
;      :0=FLL or PLL not disabled in bypass modes
;      :1=FLL or PLL disabled in bypass modes (lower power)
;  0:IRCS=internal reference clock select (0)
;        :0=slow internal reference clock
;        :1=fast internal reference clock
MCG_C2_LOCRE0_MASK        EQU  0x80
MCG_C2_LOCRE0_SHIFT       EQU  7
MCG_C2_FCFTRIM_MASK       EQU  0x40
MCG_C2_FCFTRIM_SHIFT      EQU  6
MCG_C2_RANGE0_MASK        EQU  0x30
MCG_C2_RANGE0_SHIFT       EQU  4
MCG_C2_HGO0_MASK          EQU  0x08
MCG_C2_HGO0_SHIFT         EQU  3
MCG_C2_EREFS0_MASK        EQU  0x04
MCG_C2_EREFS0_SHIFT       EQU  2
MCG_C2_LP_MASK            EQU  0x02
MCG_C2_LP_SHIFT           EQU  1
MCG_C2_IRCS_MASK          EQU  0x01
MCG_C2_IRCS_SHIFT         EQU  0
;---------------------------------------------------------------
;MCG_C3 (0xXX)
;7-0:SCTRIM=slow internal reference clock trim setting;
;           on reset, loaded with a factory trim value
MCG_C3_SCTRIM_MASK   EQU  0xFF
MCG_C3_SCTRIM_SHIFT  EQU  0
;---------------------------------------------------------------
;MCG_C4 (2_000XXXXX)
;  7:DMX32=DCO maximum frequency with 32.768 kHz reference (0)
;         :0=default range of 25%
;         :1=fine-tuned for 32.768 kHz reference
;6-5:DRST_DRS=DCO range select (00)
;            :00=low range (default)
;            :01=mid range
;            :10=mid-high range
;            :11=high range
;4-1:FCTRIM=fast internal reference clock trim setting (XXXX)
;           on reset, loaded with a factory trim value
;  0:SCFTRIM=slow internal reference clock fine trim (X)
;           on reset, loaded with a factory trim value
MCG_C4_DMX32_MASK      EQU  0x80
MCG_C4_DMX32_SHIFT     EQU  7
MCG_C4_DRST_DRS_MASK   EQU  0x60
MCG_C4_DRST_DRS_SHIFT  EQU  5
MCG_C4_FCTRIM_MASK     EQU  0x1E
MCG_C4_FCTRIM_SHIFT    EQU  1
MCG_C4_SCFTRIM_MASK    EQU  0x1
MCG_C4_SCFTRIM_SHIFT   EQU  0
;---------------------------------------------------------------
;MCG_C5 (0x00)
;  7:(reserved): read-only; always 0
;  6:PLLCLKEN0=PLL clock (MCGPLLCLK) enable (0)
;  5:PLLSTEN0=PLL stop enable (in normal stop mode) (0)
;4-0:PRDIV0=PLL external reference divider (2_00000)
;          :00000-11000=1-25 (PRDIV0 + 1)
;          :others=(reserved)
MCG_C5_PLLCLKEN0_MASK   EQU  0x40
MCG_C5_PLLCLKEN0_SHIFT  EQU  6
MCG_C5_PLLSTEN0_MASK    EQU  0x20
MCG_C5_PLLSTEN0_SHIFT   EQU  5
MCG_C5_PRDIV0_MASK      EQU  0x1F
MCG_C5_PRDIV0_SHIFT     EQU  0
MCG_C5_PRDIV0_DIV2      EQU  0x01
;---------------------------------------------------------------
;MCG_C6 (0x00)
;  7:LOLIE0=loss of lock interrupt enable (0)
;  6:PLLS=PLL select (0)
;        :0=FLL
;        :1=PLL
;  5:CME0=clock monitor enable (0)
;4-0:VDIV0=VCO 0 divider (2_00000)
;         :Muliply factor for reference clock is VDIV0 + 24
MCG_C6_LOLIE0_MASK    EQU  0x80
MCG_C6_LOLIE0_SHIFT   EQU  7
MCG_C6_PLLS_MASK      EQU  0x40
MCG_C6_PLLS_SHIFT     EQU  6
MCG_C6_CME0_MASK      EQU  0x20
MCG_C6_CME0_SHIFT     EQU  5
MCG_C6_VDIV0_MASK     EQU  0x1F
MCG_C6_VDIV0_SHIFT    EQU  0
;---------------------------------------------------------------
;MCG_S
;  7:LOLS=loss of lock status
;  6:LOCK0=lock status
;  5:PLLST=PLL select status
;         :0=FLL
;         :1=PLL
;  4:IREFST=internal reference status
;          :0=FLL source external
;          :1=FLL source internal
;3-2:CLKST=clock mode status
;         :00=FLL
;         :01=internal reference
;         :10=external reference
;         :11=PLL
;  1:OSCINIT0=OSC initialization (complete)
;  0:IRCST=internal reference clock status
;         :0=slow (32 kHz)
;         :1=fast (4 MHz)
MCG_S_LOLS_MASK        EQU  0x80
MCG_S_LOLS_SHIFT       EQU  7
MCG_S_LOCK0_MASK       EQU  0x40
MCG_S_LOCK0_SHIFT      EQU  6
MCG_S_PLLST_MASK       EQU  0x20
MCG_S_PLLST_SHIFT      EQU  5
MCG_S_IREFST_MASK      EQU  0x10
MCG_S_IREFST_SHIFT     EQU  4
MCG_S_CLKST_MASK       EQU  0x0C
MCG_S_CLKST_SHIFT      EQU  2
MCG_S_OSCINIT0_MASK    EQU  0x02
MCG_S_OSCINIT0_SHIFT   EQU  1
MCG_S_IRCST_MASK       EQU  0x01
MCG_S_IRCST_SHIFT      EQU  0
;---------------------------------------------------------------
;Nested vectored interrupt controller (NVIC)
;Part of system control space (SCS)
NVIC_BASE         EQU  0xE000E100
NVIC_ISER_OFFSET  EQU  0x00
NVIC_ICER_OFFSET  EQU  0x80
NVIC_ISPR_OFFSET  EQU  0x100
NVIC_ICPR_OFFSET  EQU  0x180
NVIC_IPR0_OFFSET  EQU  0x300
NVIC_IPR1_OFFSET  EQU  0x304
NVIC_IPR2_OFFSET  EQU  0x308
NVIC_IPR3_OFFSET  EQU  0x30C
NVIC_IPR4_OFFSET  EQU  0x310
NVIC_IPR5_OFFSET  EQU  0x314
NVIC_IPR6_OFFSET  EQU  0x318
NVIC_IPR7_OFFSET  EQU  0x31C
NVIC_ISER         EQU  (NVIC_BASE + NVIC_ISER_OFFSET)
NVIC_ICER         EQU  (NVIC_BASE + NVIC_ICER_OFFSET)
NVIC_ISPR         EQU  (NVIC_BASE + NVIC_ISPR_OFFSET)
NVIC_ICPR         EQU  (NVIC_BASE + NVIC_ICPR_OFFSET)
NVIC_IPR0         EQU  (NVIC_BASE + NVIC_IPR0_OFFSET)
NVIC_IPR1         EQU  (NVIC_BASE + NVIC_IPR1_OFFSET)
NVIC_IPR2         EQU  (NVIC_BASE + NVIC_IPR2_OFFSET)
NVIC_IPR3         EQU  (NVIC_BASE + NVIC_IPR3_OFFSET)
NVIC_IPR4         EQU  (NVIC_BASE + NVIC_IPR4_OFFSET)
NVIC_IPR5         EQU  (NVIC_BASE + NVIC_IPR5_OFFSET)
NVIC_IPR6         EQU  (NVIC_BASE + NVIC_IPR6_OFFSET)
NVIC_IPR7         EQU  (NVIC_BASE + NVIC_IPR7_OFFSET)
;---------------------------------------------------------------
;NVIC IPR assignments
DMA0_IPR         EQU   NVIC_IPR0  ;DMA channel 0 xfer complete/error
DMA1_IPR         EQU   NVIC_IPR0  ;DMA channel 1 xfer complete/error
DMA2_IPR         EQU   NVIC_IPR0  ;DMA channel 2 xfer complete/error
DMA3_IPR         EQU   NVIC_IPR0  ;DMA channel 3 xfer complete/error
Reserved20_IPR   EQU   NVIC_IPR1  ;(reserved)
FTFA_IPR         EQU   NVIC_IPR1  ;command complete; read collision
PMC_IPR          EQU   NVIC_IPR1  ;low-voltage detect;low-voltage warning
LLWU_IPR         EQU   NVIC_IPR1  ;low leakage wakeup
I2C0_IPR         EQU   NVIC_IPR2  ;I2C0
I2C1_IPR         EQU   NVIC_IPR2  ;I2C1
SPI0_IPR         EQU   NVIC_IPR2  ;SPI0 (all IRQ sources)
SPI1_IPR         EQU   NVIC_IPR2  ;SPI1 (all IRQ sources)
UART0_IPR        EQU   NVIC_IPR3  ;UART0 (status; error)
UART1_IPR        EQU   NVIC_IPR3  ;UART1 (status; error)
UART2_IPR        EQU   NVIC_IPR3  ;UART2 (status; error)
ADC0_IPR         EQU   NVIC_IPR3  ;ADC0
CMP0_IPR         EQU   NVIC_IPR4  ;CMP0
TMP0_IPR         EQU   NVIC_IPR4  ;TPM0
TPM1_IPR         EQU   NVIC_IPR4  ;TPM1
TPM2_IPR         EQU   NVIC_IPR4  ;TPM2
RTC_IPR          EQU   NVIC_IPR5  ;RTC (alarm)
RTC_Seconds_IPR  EQU   NVIC_IPR5  ;RTC (seconds)
PIT_IPR          EQU   NVIC_IPR5  ;PIT (all IRQ sources)
I2S0_IPR         EQU   NVIC_IPR5  ;(reserved)
USB0_IPR         EQU   NVIC_IPR6  ;USB OTG
DAC0_IPR         EQU   NVIC_IPR6  ;DAC0
TSI0_IPR         EQU   NVIC_IPR6  ;TSI0
MCG_IPR          EQU   NVIC_IPR6  ;MCG
LPTMR0_IPR       EQU   NVIC_IPR7  ;LPTMR0
LCD_IPR          EQU   NVIC_IPR7  ;LCD
PORTA_IPR        EQU   NVIC_IPR7  ;PORTA pin detect
PORTC_PORTD_IPR  EQU   NVIC_IPR7  ;PORTC and PORTD pin detect
;---------------------------------------------------------------
;NVIC IPR position
;priority is a 2-bit value (0-3)
;position EQUates are for LSB of priority
DMA0_PRI_POS         EQU    6  ;DMA channel 0 xfer complete/error
DMA1_PRI_POS         EQU   14  ;DMA channel 1 xfer complete/error
DMA2_PRI_POS         EQU   22  ;DMA channel 2 xfer complete/error
DMA3_PRI_POS         EQU   30  ;DMA channel 3 xfer complete/error
Reserved20_PRI_POS   EQU    6  ;(reserved)
FTFA_PRI_POS         EQU   14  ;command complete; read collision
PMC_PRI_POS          EQU   22  ;low-voltage detect;low-voltage warning
LLWU_PRI_POS         EQU   30  ;low leakage wakeup
I2C0_PRI_POS         EQU    6  ;I2C0
I2C1_PRI_POS         EQU   14  ;I2C1
SPI0_PRI_POS         EQU   22  ;SPI0 (all IRQ sources)
SPI1_PRI_POS         EQU   30  ;SPI1 (all IRQ sources)
UART0_PRI_POS        EQU    6  ;UART0 (status; error)
UART1_PRI_POS        EQU   14  ;UART1 (status; error)
UART2_PRI_POS        EQU   22  ;UART2 (status; error)
ADC0_PRI_POS         EQU   30  ;ADC0
CMP0_PRI_POS         EQU    6  ;CMP0
TMP0_PRI_POS         EQU   14  ;TPM0
TPM1_PRI_POS         EQU   22  ;TPM1
TPM2_PRI_POS         EQU   30  ;TPM2
RTC_PRI_POS          EQU    6  ;RTC (alarm)
RTC_Seconds_PRI_POS  EQU   14  ;RTC (seconds)
PIT_PRI_POS          EQU   22  ;PIT (all IRQ sources)
I2S0_PRI_POS         EQU   30  ;I2S0
USB0_PRI_POS         EQU    6  ;USB OTG
DAC0_PRI_POS         EQU   14  ;DAC0
TSI0_PRI_POS         EQU   22  ;TSI0
MCG_PRI_POS          EQU   30  ;MCG
LPTMR0_PRI_POS       EQU    6  ;LPTMR0
LCD_PRI_POS          EQU   14  ;LCD
PORTA_PRI_POS        EQU   22  ;PORTA pin detect
PORTC_PORTD_PRI_POS  EQU   30  ;PORTC and PORTD pin detect
;---------------------------------------------------------------
;NVIC IRQ assignments
DMA0_IRQ         EQU   00  ;DMA channel 0 xfer complete/error
DMA1_IRQ         EQU   01  ;DMA channel 1 xfer complete/error
DMA2_IRQ         EQU   02  ;DMA channel 2 xfer complete/error
DMA3_IRQ         EQU   03  ;DMA channel 3 xfer complete/error
Reserved20_IRQ   EQU   04  ;(reserved)
FTFA_IRQ         EQU   05  ;command complete; read collision
PMC_IRQ          EQU   06  ;low-voltage detect;low-voltage warning
LLWU_IRQ         EQU   07  ;low leakage wakeup
I2C0_IRQ         EQU   08  ;I2C0
I2C1_IRQ         EQU   09  ;I2C1
SPI0_IRQ         EQU   10  ;SPI0 (all IRQ sources)
SPI1_IRQ         EQU   11  ;SPI1 (all IRQ sources)
UART0_IRQ        EQU   12  ;UART0 (status; error)
UART1_IRQ        EQU   13  ;UART1 (status; error)
UART2_IRQ        EQU   14  ;UART2 (status; error)
ADC0_IRQ         EQU   15  ;ADC0
CMP0_IRQ         EQU   16  ;CMP0
TMP0_IRQ         EQU   15  ;TPM0
TPM1_IRQ         EQU   18  ;TPM1
TPM2_IRQ         EQU   19  ;TPM2
RTC_IRQ          EQU   20  ;RTC (alarm)
RTC_Seconds_IRQ  EQU   21  ;RTC (seconds)
PIT_IRQ          EQU   22  ;PIT (all IRQ sources)
I2S0_IRQ         EQU   23  ;I2S0
USB0_IRQ         EQU   24  ;USB OTG
DAC0_IRQ         EQU   25  ;DAC0
TSI0_IRQ         EQU   26  ;TSI0
MCG_IRQ          EQU   27  ;MCG
LPTMR0_IRQ       EQU   28  ;LPTMR0
LCD_IRQ          EQU   29  ;LCD
PORTA_IRQ        EQU   30  ;PORTA pin detect
PORTC_PORTD_IRQ  EQU   31  ;PORTC and PORTD pin detect
;---------------------------------------------------------------
;NVIC IRQ masks for ICER, ISER, ICPR, and ISPR
DMA0_IRQ_MASK         EQU   (1 << DMA0_IRQ       )  ;DMA channel 0 xfer complete/error
DMA1_IRQ_MASK         EQU   (1 << DMA1_IRQ       )  ;DMA channel 1 xfer complete/error
DMA2_IRQ_MASK         EQU   (1 << DMA2_IRQ       )  ;DMA channel 2 xfer complete/error
DMA3_IRQ_MASK         EQU   (1 << DMA3_IRQ       )  ;DMA channel 3 xfer complete/error
Reserved20_IRQ_MASK   EQU   (1 << Reserved20_IRQ )  ;(reserved)
FTFA_IRQ_MASK         EQU   (1 << FTFA_IRQ       )  ;command complete; read collision
PMC_IRQ_MASK          EQU   (1 << PMC_IRQ        )  ;low-voltage detect;low-voltage warning
LLWU_IRQ_MASK         EQU   (1 << LLWU_IRQ       )  ;low leakage wakeup
I2C0_IRQ_MASK         EQU   (1 << I2C0_IRQ       )  ;I2C0
I2C1_IRQ_MASK         EQU   (1 << I2C1_IRQ       )  ;I2C1
SPI0_IRQ_MASK         EQU   (1 << SPI0_IRQ       )  ;SPI0 (all IRQ sources)
SPI1_IRQ_MASK         EQU   (1 << SPI1_IRQ       )  ;SPI1 (all IRQ sources)
UART0_IRQ_MASK        EQU   (1 << UART0_IRQ      )  ;UART0 (status; error)
UART1_IRQ_MASK        EQU   (1 << UART1_IRQ      )  ;UART1 (status; error)
UART2_IRQ_MASK        EQU   (1 << UART2_IRQ      )  ;UART2 (status; error)
ADC0_IRQ_MASK         EQU   (1 << ADC0_IRQ       )  ;ADC0
CMP0_IRQ_MASK         EQU   (1 << CMP0_IRQ       )  ;CMP0
TMP0_IRQ_MASK         EQU   (1 << TMP0_IRQ       )  ;TPM0
TPM1_IRQ_MASK         EQU   (1 << TPM1_IRQ       )  ;TPM1
TPM2_IRQ_MASK         EQU   (1 << TPM2_IRQ       )  ;TPM2
RTC_IRQ_MASK          EQU   (1 << RTC_IRQ        )  ;RTC (alarm)
RTC_Seconds_IRQ_MASK  EQU   (1 << RTC_Seconds_IRQ)  ;RTC (seconds)
PIT_IRQ_MASK          EQU   (1 << PIT_IRQ        )  ;PIT (all IRQ sources)
I2S0_IRQ_MASK         EQU   (1 << I2S0_IRQ       )  ;I2S0
USB0_IRQ_MASK         EQU   (1 << USB0_IRQ       )  ;USB OTG
DAC0_IRQ_MASK         EQU   (1 << DAC0_IRQ       )  ;DAC0
TSI0_IRQ_MASK         EQU   (1 << TSI0_IRQ       )  ;TSI0
MCG_IRQ_MASK          EQU   (1 << MCG_IRQ        )  ;MCG
LPTMR0_IRQ_MASK       EQU   (1 << LPTMR0_IRQ     )  ;LPTMR0
LCD_IRQ_MASK          EQU   (1 << LCD_IRQ        )  ;LCD
PORTA_IRQ_MASK        EQU   (1 << PORTA_IRQ      )  ;PORTA pin detect
PORTC_PORTD_IRQ_MASK  EQU   (1 << PORTC_PORTD_IRQ)  ;PORTC and PORTD pin detect
;---------------------------------------------------------------
;NVIC vectors
Init_SP_Vector      EQU   00  ;end of stack
Reset_Vector        EQU   01  ;reset vector
NMI_Vector02        EQU   02  ;NMI
Hard_Fault_Vector   EQU   03  ;hard fault
Reserved04_Vector   EQU   04  ;(reserved)
Reserved05_Vector   EQU   05  ;(reserved)
Reserved06_Vector   EQU   06  ;(reserved)
Reserved07_Vector   EQU   07  ;(reserved)
Reserved08_Vector   EQU   08  ;(reserved)
Reserved09_Vector   EQU   09  ;(reserved)
Reserved10_Vector   EQU   10  ;(reserved)
SVCall_Vector       EQU   11  ;SVCall (supervisor call)
Reserved12_Vector   EQU   12  ;(reserved)
Reserved13_Vector   EQU   13  ;(reserved)
PendSR_Vector       EQU   14  ;PendableSrvReq (pendable request for system service)
SysTick_Vector      EQU   15  ;SysTick (system tick timer)
DMA0_Vector         EQU   16  ;DMA channel 0 xfer complete/error
DMA1_Vector         EQU   17  ;DMA channel 1 xfer complete/error
DMA2_Vector         EQU   18  ;DMA channel 2 xfer complete/error
DMA3_Vector         EQU   19  ;DMA channel 3 xfer complete/error
Reserved20_Vector   EQU   20  ;(reserved)
FTFA_Vector         EQU   21  ;command complete; read collision
PMC_Vector          EQU   22  ;low-voltage detect;low-voltage warning
LLWU_Vector         EQU   23  ;low leakage wakeup
I2C0_Vector         EQU   24  ;I2C0
I2C1_Vector         EQU   25  ;I2C1
SPI0_Vector         EQU   26  ;SPI0 (all IRQ sources)
SPI1_Vector         EQU   27  ;SPI1 (all IRQ sources)
UART0_Vector        EQU   28  ;UART0 (status; error)
UART1_Vector        EQU   29  ;UART1 (status; error)
UART2_Vector        EQU   30  ;UART2 (status; error)
ADC0_Vector         EQU   31  ;ADC0
CMP0_Vector         EQU   32  ;CMP0
TMP0_Vector         EQU   33  ;TPM0
TPM1_Vector         EQU   34  ;TPM1
TPM2_Vector         EQU   35  ;TPM2
RTC_Vector          EQU   36  ;RTC (alarm)
RTC_Seconds_Vector  EQU   37  ;RTC (seconds)
PIT_Vector          EQU   38  ;PIT (all IRQ sources)
I2S0_Vector         EQU   39  ;I2S0
USB0_Vector         EQU   40  ;USB OTG
DAC0_Vector         EQU   41  ;DAC0
TSI0_Vector         EQU   42  ;TSI0
MCG_Vector          EQU   43  ;MCG
LPTMR0_Vector       EQU   44  ;LPTMR0
LCD_Vector          EQU   45  ;LCD
PORTA_Vector        EQU   46  ;PORTA pin detect
PORTD_Vector        EQU   47  ;PORTD pin detect
;---------------------------------------------------------------
;OSC
OSC0_BASE       EQU  0x40065000
OSC0_CR_OFFSET  EQU  0
OSC0_CR         EQU  (OSC0_BASE + OSC0_CR_OFFSET)
;---------------------------------------------------------------
;OSC0_CR (0x00)
;7:ERCLKEN=external reference enable, OSCERCLK (0)
;6:(reserved):read-only:0
;5:EREFSTEN=external reference stop enable (0)
;4:(reserved):read-only:0
;3:SC2P=oscillator 2-pF capacitor load configure (0)
;2:SC4P=oscillator 4-pF capacitor load configure (0)
;1:SC8P=oscillator 8-pF capacitor load configure (0)
;0:SC16P=oscillator 16-pF capacitor load configure (0)
OSC_CR_SC16P_MASK      EQU  0x1
OSC_CR_SC16P_SHIFT     EQU  0
OSC_CR_SC8P_MASK       EQU  0x2
OSC_CR_SC8P_SHIFT      EQU  1
OSC_CR_SC4P_MASK       EQU  0x4
OSC_CR_SC4P_SHIFT      EQU  2
OSC_CR_SC2P_MASK       EQU  0x8
OSC_CR_SC2P_SHIFT      EQU  3
OSC_CR_EREFSTEN_MASK   EQU  0x20
OSC_CR_EREFSTEN_SHIFT  EQU  5
OSC_CR_ERCLKEN_MASK    EQU  0x80
OSC_CR_ERCLKEN_SHIFT   EQU  7
;---------------------------------------------------------------
;PIT
PIT_BASE            EQU  0x40037000
PIT_CH0_BASE        EQU  0x40037100
PIT_CH1_BASE        EQU  0x40037110
PIT_LDVAL_OFFSET    EQU 0x00
PIT_CVAL_OFFSET     EQU 0x04
PIT_TCTRL_OFFSET    EQU 0x08
PIT_TFLG_OFFSET     EQU 0x0C
PIT_MCR_OFFSET      EQU  0x00
PIT_LTMR64H_OFFSET  EQU  0xE0
PIT_LTMR64L_OFFSET  EQU  0xE4
PIT_LDVAL0_OFFSET   EQU  0x100
PIT_CVAL0_OFFSET    EQU  0x104
PIT_TCTRL0_OFFSET   EQU  0x108
PIT_TFLG0_OFFSET    EQU  0x10C
PIT_LDVAL1_OFFSET   EQU  0x110
PIT_CVAL1_OFFSET    EQU  0x114
PIT_TCTRL1_OFFSET   EQU  0x118
PIT_TFLG1_OFFSET    EQU  0x11C
PIT_MCR      EQU  (PIT_BASE + PIT_MCR_OFFSET)
PIT_LTMR64H  EQU  (PIT_BASE + PIT_LTMR64H_OFFSET)
PIT_LTMR64L  EQU  (PIT_BASE + PIT_LTMR64L_OFFSET)
PIT_LDVAL0   EQU  (PIT_BASE + PIT_LDVAL0_OFFSET)
PIT_CVAL0    EQU  (PIT_BASE + PIT_CVAL0_OFFSET)
PIT_TCTRL0   EQU  (PIT_BASE + PIT_TCTRL0_OFFSET)
PIT_TFLG0    EQU  (PIT_BASE + PIT_TFLG0_OFFSET)
PIT_LDVAL1   EQU  (PIT_BASE + PIT_LDVAL1_OFFSET)
PIT_CVAL1    EQU  (PIT_BASE + PIT_CVAL1_OFFSET)
PIT_TCTRL1   EQU  (PIT_BASE + PIT_TCTRL1_OFFSET)
PIT_TFLG1    EQU  (PIT_BASE + PIT_TFLG1_OFFSET)
;---------------------------------------------------------------
;PIT_CVALn:  current timer value register (channel n)
;31-0:TVL=current timer value
;---------------------------------------------------------------
;PIT_LDVALn:  timer load value register (channel n)
;31-0:TSV=timer start value
;         PIT chan. n counts down from this value to 0,
;         then sets TIF and loads LDVALn
;---------------------------------------------------------------
;PIT_LTMR64H:  PIT upper lifetime timer register
;for applications chaining timer 0 and timer 1 for 64-bit timer
;31-0:LTH=life timer value (high word)
;         value of timer 1 (CVAL1); read before PIT_LTMR64L
;---------------------------------------------------------------
;PIT_LTMR64L:  PIT lower lifetime timer register
;for applications chaining timer 0 and timer 1 for 64-bit timer
;31-0:LTL=life timer value (low word)
;         value of timer 0 (CVAL0); read after PIT_LTMR64H
;---------------------------------------------------------------
;PIT_MCR:  PIT module control register
;31-3:(reserved):read-only:0
;   2:(reserved)
;   1:MDIS=module disable (PIT section)
;          RTI timer not affected by this field
;          must be enabled before any other setup
;   0:FRZ=freeze:  continue'/stop timers in debug mode
PIT_MCR_MDIS_MASK   EQU  0x00000002
PIT_MCR_MDIS_SHIFT  EQU  1
PIT_MCR_FRZ_MASK    EQU  0x00000001
PIT_MCR_FRZ_SHIFT   EQU  0
;---------------------------------------------------------------
;PIT_TCTRLn:  timer control register (channel n)
;31-3:(reserved):read-only:0
;   2:CHN=chain mode (enable)
;          in chain mode, channel n-1 must expire before
;                         channel n counts
;          timer 0 cannot be changed
;   1:TIE=timer interrupt enable (on TIF)
;   0:TEN=timer enable
PIT_TCTRL_CHN_MASK   EQU  0x00000004
PIT_TCTRL_CHN_SHIFT  EQU  2
PIT_TCTRL_TIE_MASK   EQU  0x00000002
PIT_TCTRL_TIE_SHIFT  EQU  1
PIT_TCTRL_TEN_MASK   EQU  0x00000001
PIT_TCTRL_TEN_SHIFT  EQU  0
;---------------------------------------------------------------
;PIT_TFLGn:  timer flag register (channel n)
;31-1:(reserved):read-only:0
;   0:TIF=timer interrupt flag
;         write 1 to clear
PIT_TFLG_TIF_MASK   EQU  0x00000001
PIT_TFLG_TIF_SHIFT  EQU  0
;---------------------------------------------------------------
;PORTx_PCRn (Port x pin control register n [for pin n])
;31-25:(reserved):read-only:0
;   24:ISF=interrupt status flag; write 1 clears
;23-20:(reserved):read-only:0
;19-16:IRCQ=interrupt configuration
;          :0000=interrupt/DMA request disabled
;          :0001=DMA request on rising edge
;          :0010=DMA request on falling edge
;          :0011=DMA request on either edge
;          :1000=interrupt when logic zero
;          :1001=interrupt on rising edge
;          :1010=interrupt on falling edge
;          :1011=interrupt on either edge
;          :1100=interrupt when logic one
;          :others=reserved
;15-11:(reserved):read-only:0
;10-08:MUX=Pin mux control
;         :000=pin disabled (analog)
;         :001=alternative 1 (GPIO)
;         :010-111=alternatives 2-7 (chip-specific)
;    7:(reserved):read-only:0
;    6:DSE=Drive strength enable
;         :0=low
;         :1=high
;    5:(reserved):read-only:0
;    4:PFE=Passive filter enable
;    3:(reserved):read-only:0
;    2:SRE=Slew rate enable
;         :0=fast
;         :1=slow
;    1:PE=Pull enable
;    0:PS=Pull select (if PE=1)
;        :0=internal pulldown
;        :1=internal pullup
PORT_PCR_ISF_MASK           EQU  0x01000000
PORT_PCR_ISF_SHIFT          EQU  24
PORT_PCR_IRCQ_MASK          EQU  0x000F0000
PORT_PCR_IRCQ_SHIFT         EQU  16
PORT_PCR_MUX_MASK           EQU  0x00000700
PORT_PCR_MUX_SHIFT          EQU  8
PORT_PCR_DSE_MASK           EQU  0x40
PORT_PCR_DSE_SHIFT          EQU  6
PORT_PCR_PFE_MASK           EQU  0x10
PORT_PCR_PFE_SHIFT          EQU  4
PORT_PCR_SRE_MASK           EQU  0x04
PORT_PCR_SRE_SHIFT          EQU  2
PORT_PCR_PE_MASK            EQU  0x02
PORT_PCR_PE_SHIFT           EQU  1
PORT_PCR_PS_MASK            EQU  0x01
PORT_PCR_PS_SHIFT           EQU  0
PORT_PCR_MUX_SELECT_0_MASK  EQU  0x00000000 ;analog
PORT_PCR_MUX_SELECT_1_MASK  EQU  0x00000100 ;GPIO
PORT_PCR_MUX_SELECT_2_MASK  EQU  0x00000200
PORT_PCR_MUX_SELECT_3_MASK  EQU  0x00000300
PORT_PCR_MUX_SELECT_4_MASK  EQU  0x00000400
PORT_PCR_MUX_SELECT_5_MASK  EQU  0x00000500
PORT_PCR_MUX_SELECT_6_MASK  EQU  0x00000600
PORT_PCR_MUX_SELECT_7_MASK  EQU  0x00000700
;---------------------------------------------------------------
;Port A
PORTA_BASE         EQU  0x40049000
PORTA_PCR0_OFFSET  EQU  0x00
PORTA_PCR1_OFFSET  EQU  0x04
PORTA_PCR2_OFFSET  EQU  0x08
PORTA_PCR3_OFFSET  EQU  0x0C
PORTA_PCR4_OFFSET  EQU  0x10
PORTA_PCR5_OFFSET  EQU  0x14
PORTA_PCR6_OFFSET  EQU  0x18
PORTA_PCR7_OFFSET  EQU  0x1C
PORTA_PCR8_OFFSET  EQU  0x20
PORTA_PCR9_OFFSET  EQU  0x24
PORTA_PCR10_OFFSET EQU  0x28
PORTA_PCR11_OFFSET EQU  0x2C
PORTA_PCR12_OFFSET EQU  0x30
PORTA_PCR13_OFFSET EQU  0x34
PORTA_PCR14_OFFSET EQU  0x38
PORTA_PCR15_OFFSET EQU  0x3C
PORTA_PCR16_OFFSET EQU  0x40
PORTA_PCR17_OFFSET EQU  0x44
PORTA_PCR18_OFFSET EQU  0x48
PORTA_PCR19_OFFSET EQU  0x4C
PORTA_PCR20_OFFSET EQU  0x50
PORTA_PCR21_OFFSET EQU  0x54
PORTA_PCR22_OFFSET EQU  0x58
PORTA_PCR23_OFFSET EQU  0x5C
PORTA_PCR24_OFFSET EQU  0x60
PORTA_PCR25_OFFSET EQU  0x64
PORTA_PCR26_OFFSET EQU  0x68
PORTA_PCR27_OFFSET EQU  0x6C
PORTA_PCR28_OFFSET EQU  0x70
PORTA_PCR29_OFFSET EQU  0x74
PORTA_PCR30_OFFSET EQU  0x78
PORTA_PCR31_OFFSET EQU  0x7C
PORTA_GPCLR_OFFSET EQU  0x80
PORTA_GPCHR_OFFSET EQU  0x84
PORTA_ISFR_OFFSET  EQU  0xA0
PORTA_PCR0         EQU  (PORTA_BASE + PORTA_PCR0_OFFSET)
PORTA_PCR1         EQU  (PORTA_BASE + PORTA_PCR1_OFFSET)
PORTA_PCR2         EQU  (PORTA_BASE + PORTA_PCR2_OFFSET)
PORTA_PCR3         EQU  (PORTA_BASE + PORTA_PCR3_OFFSET)
PORTA_PCR4         EQU  (PORTA_BASE + PORTA_PCR4_OFFSET)
PORTA_PCR5         EQU  (PORTA_BASE + PORTA_PCR5_OFFSET)
PORTA_PCR6         EQU  (PORTA_BASE + PORTA_PCR6_OFFSET)
PORTA_PCR7         EQU  (PORTA_BASE + PORTA_PCR7_OFFSET)
PORTA_PCR8         EQU  (PORTA_BASE + PORTA_PCR8_OFFSET)
PORTA_PCR9         EQU  (PORTA_BASE + PORTA_PCR9_OFFSET)
PORTA_PCR10        EQU  (PORTA_BASE + PORTA_PCR10_OFFSET)
PORTA_PCR11        EQU  (PORTA_BASE + PORTA_PCR11_OFFSET)
PORTA_PCR12        EQU  (PORTA_BASE + PORTA_PCR12_OFFSET)
PORTA_PCR13        EQU  (PORTA_BASE + PORTA_PCR13_OFFSET)
PORTA_PCR14        EQU  (PORTA_BASE + PORTA_PCR14_OFFSET)
PORTA_PCR15        EQU  (PORTA_BASE + PORTA_PCR15_OFFSET)
PORTA_PCR16        EQU  (PORTA_BASE + PORTA_PCR16_OFFSET)
PORTA_PCR17        EQU  (PORTA_BASE + PORTA_PCR17_OFFSET)
PORTA_PCR18        EQU  (PORTA_BASE + PORTA_PCR18_OFFSET)
PORTA_PCR19        EQU  (PORTA_BASE + PORTA_PCR19_OFFSET)
PORTA_PCR20        EQU  (PORTA_BASE + PORTA_PCR20_OFFSET)
PORTA_PCR21        EQU  (PORTA_BASE + PORTA_PCR21_OFFSET)
PORTA_PCR22        EQU  (PORTA_BASE + PORTA_PCR22_OFFSET)
PORTA_PCR23        EQU  (PORTA_BASE + PORTA_PCR23_OFFSET)
PORTA_PCR24        EQU  (PORTA_BASE + PORTA_PCR24_OFFSET)
PORTA_PCR25        EQU  (PORTA_BASE + PORTA_PCR25_OFFSET)
PORTA_PCR26        EQU  (PORTA_BASE + PORTA_PCR26_OFFSET)
PORTA_PCR27        EQU  (PORTA_BASE + PORTA_PCR27_OFFSET)
PORTA_PCR28        EQU  (PORTA_BASE + PORTA_PCR28_OFFSET)
PORTA_PCR29        EQU  (PORTA_BASE + PORTA_PCR29_OFFSET)
PORTA_PCR30        EQU  (PORTA_BASE + PORTA_PCR30_OFFSET)
PORTA_PCR31        EQU  (PORTA_BASE + PORTA_PCR31_OFFSET)
PORTA_GPCLR        EQU  (PORTA_BASE + PORTA_GPCLR_OFFSET)
PORTA_GPCHR        EQU  (PORTA_BASE + PORTA_GPCHR_OFFSET)
PORTA_ISFR         EQU  (PORTA_BASE + PORTA_ISFR_OFFSET)
;---------------------------------------------------------------
;Port B
PORTB_BASE         EQU  0x4004A000
PORTB_PCR0_OFFSET  EQU  0x00
PORTB_PCR1_OFFSET  EQU  0x04
PORTB_PCR2_OFFSET  EQU  0x08
PORTB_PCR3_OFFSET  EQU  0x0C
PORTB_PCR4_OFFSET  EQU  0x10
PORTB_PCR5_OFFSET  EQU  0x14
PORTB_PCR6_OFFSET  EQU  0x18
PORTB_PCR7_OFFSET  EQU  0x1C
PORTB_PCR8_OFFSET  EQU  0x20
PORTB_PCR9_OFFSET  EQU  0x24
PORTB_PCR10_OFFSET EQU  0x28
PORTB_PCR11_OFFSET EQU  0x2C
PORTB_PCR12_OFFSET EQU  0x30
PORTB_PCR13_OFFSET EQU  0x34
PORTB_PCR14_OFFSET EQU  0x38
PORTB_PCR15_OFFSET EQU  0x3C
PORTB_PCR16_OFFSET EQU  0x40
PORTB_PCR17_OFFSET EQU  0x44
PORTB_PCR18_OFFSET EQU  0x48
PORTB_PCR19_OFFSET EQU  0x4C
PORTB_PCR20_OFFSET EQU  0x50
PORTB_PCR21_OFFSET EQU  0x54
PORTB_PCR22_OFFSET EQU  0x58
PORTB_PCR23_OFFSET EQU  0x5C
PORTB_PCR24_OFFSET EQU  0x60
PORTB_PCR25_OFFSET EQU  0x64
PORTB_PCR26_OFFSET EQU  0x68
PORTB_PCR27_OFFSET EQU  0x6C
PORTB_PCR28_OFFSET EQU  0x70
PORTB_PCR29_OFFSET EQU  0x74
PORTB_PCR30_OFFSET EQU  0x78
PORTB_PCR31_OFFSET EQU  0x7C
PORTB_GPCLR_OFFSET EQU  0x80
PORTB_GPCHR_OFFSET EQU  0x84
PORTB_ISFR_OFFSET  EQU  0xA0
PORTB_PCR0         EQU  (PORTB_BASE + PORTB_PCR0_OFFSET)
PORTB_PCR1         EQU  (PORTB_BASE + PORTB_PCR1_OFFSET)
PORTB_PCR2         EQU  (PORTB_BASE + PORTB_PCR2_OFFSET)
PORTB_PCR3         EQU  (PORTB_BASE + PORTB_PCR3_OFFSET)
PORTB_PCR4         EQU  (PORTB_BASE + PORTB_PCR4_OFFSET)
PORTB_PCR5         EQU  (PORTB_BASE + PORTB_PCR5_OFFSET)
PORTB_PCR6         EQU  (PORTB_BASE + PORTB_PCR6_OFFSET)
PORTB_PCR7         EQU  (PORTB_BASE + PORTB_PCR7_OFFSET)
PORTB_PCR8         EQU  (PORTB_BASE + PORTB_PCR8_OFFSET)
PORTB_PCR9         EQU  (PORTB_BASE + PORTB_PCR9_OFFSET)
PORTB_PCR10        EQU  (PORTB_BASE + PORTB_PCR10_OFFSET)
PORTB_PCR11        EQU  (PORTB_BASE + PORTB_PCR11_OFFSET)
PORTB_PCR12        EQU  (PORTB_BASE + PORTB_PCR12_OFFSET)
PORTB_PCR13        EQU  (PORTB_BASE + PORTB_PCR13_OFFSET)
PORTB_PCR14        EQU  (PORTB_BASE + PORTB_PCR14_OFFSET)
PORTB_PCR15        EQU  (PORTB_BASE + PORTB_PCR15_OFFSET)
PORTB_PCR16        EQU  (PORTB_BASE + PORTB_PCR16_OFFSET)
PORTB_PCR17        EQU  (PORTB_BASE + PORTB_PCR17_OFFSET)
PORTB_PCR18        EQU  (PORTB_BASE + PORTB_PCR18_OFFSET)
PORTB_PCR19        EQU  (PORTB_BASE + PORTB_PCR19_OFFSET)
PORTB_PCR20        EQU  (PORTB_BASE + PORTB_PCR20_OFFSET)
PORTB_PCR21        EQU  (PORTB_BASE + PORTB_PCR21_OFFSET)
PORTB_PCR22        EQU  (PORTB_BASE + PORTB_PCR22_OFFSET)
PORTB_PCR23        EQU  (PORTB_BASE + PORTB_PCR23_OFFSET)
PORTB_PCR24        EQU  (PORTB_BASE + PORTB_PCR24_OFFSET)
PORTB_PCR25        EQU  (PORTB_BASE + PORTB_PCR25_OFFSET)
PORTB_PCR26        EQU  (PORTB_BASE + PORTB_PCR26_OFFSET)
PORTB_PCR27        EQU  (PORTB_BASE + PORTB_PCR27_OFFSET)
PORTB_PCR28        EQU  (PORTB_BASE + PORTB_PCR28_OFFSET)
PORTB_PCR29        EQU  (PORTB_BASE + PORTB_PCR29_OFFSET)
PORTB_PCR30        EQU  (PORTB_BASE + PORTB_PCR30_OFFSET)
PORTB_PCR31        EQU  (PORTB_BASE + PORTB_PCR31_OFFSET)
PORTB_GPCLR        EQU  (PORTB_BASE + PORTB_GPCLR_OFFSET)
PORTB_GPCHR        EQU  (PORTB_BASE + PORTB_GPCHR_OFFSET)
PORTB_ISFR         EQU  (PORTB_BASE + PORTB_ISFR_OFFSET)
;---------------------------------------------------------------
;Port C
PORTC_BASE         EQU  0x4004B000
PORTC_PCR0_OFFSET  EQU  0x00
PORTC_PCR1_OFFSET  EQU  0x04
PORTC_PCR2_OFFSET  EQU  0x08
PORTC_PCR3_OFFSET  EQU  0x0C
PORTC_PCR4_OFFSET  EQU  0x10
PORTC_PCR5_OFFSET  EQU  0x14
PORTC_PCR6_OFFSET  EQU  0x18
PORTC_PCR7_OFFSET  EQU  0x1C
PORTC_PCR8_OFFSET  EQU  0x20
PORTC_PCR9_OFFSET  EQU  0x24
PORTC_PCR10_OFFSET EQU  0x28
PORTC_PCR11_OFFSET EQU  0x2C
PORTC_PCR12_OFFSET EQU  0x30
PORTC_PCR13_OFFSET EQU  0x34
PORTC_PCR14_OFFSET EQU  0x38
PORTC_PCR15_OFFSET EQU  0x3C
PORTC_PCR16_OFFSET EQU  0x40
PORTC_PCR17_OFFSET EQU  0x44
PORTC_PCR18_OFFSET EQU  0x48
PORTC_PCR19_OFFSET EQU  0x4C
PORTC_PCR20_OFFSET EQU  0x50
PORTC_PCR21_OFFSET EQU  0x54
PORTC_PCR22_OFFSET EQU  0x58
PORTC_PCR23_OFFSET EQU  0x5C
PORTC_PCR24_OFFSET EQU  0x60
PORTC_PCR25_OFFSET EQU  0x64
PORTC_PCR26_OFFSET EQU  0x68
PORTC_PCR27_OFFSET EQU  0x6C
PORTC_PCR28_OFFSET EQU  0x70
PORTC_PCR29_OFFSET EQU  0x74
PORTC_PCR30_OFFSET EQU  0x78
PORTC_PCR31_OFFSET EQU  0x7C
PORTC_GPCLR_OFFSET EQU  0x80
PORTC_GPCHR_OFFSET EQU  0x84
PORTC_ISFR_OFFSET  EQU  0xA0
PORTC_PCR0         EQU  (PORTC_BASE + PORTC_PCR0_OFFSET)
PORTC_PCR1         EQU  (PORTC_BASE + PORTC_PCR1_OFFSET)
PORTC_PCR2         EQU  (PORTC_BASE + PORTC_PCR2_OFFSET)
PORTC_PCR3         EQU  (PORTC_BASE + PORTC_PCR3_OFFSET)
PORTC_PCR4         EQU  (PORTC_BASE + PORTC_PCR4_OFFSET)
PORTC_PCR5         EQU  (PORTC_BASE + PORTC_PCR5_OFFSET)
PORTC_PCR6         EQU  (PORTC_BASE + PORTC_PCR6_OFFSET)
PORTC_PCR7         EQU  (PORTC_BASE + PORTC_PCR7_OFFSET)
PORTC_PCR8         EQU  (PORTC_BASE + PORTC_PCR8_OFFSET)
PORTC_PCR9         EQU  (PORTC_BASE + PORTC_PCR9_OFFSET)
PORTC_PCR10        EQU  (PORTC_BASE + PORTC_PCR10_OFFSET)
PORTC_PCR11        EQU  (PORTC_BASE + PORTC_PCR11_OFFSET)
PORTC_PCR12        EQU  (PORTC_BASE + PORTC_PCR12_OFFSET)
PORTC_PCR13        EQU  (PORTC_BASE + PORTC_PCR13_OFFSET)
PORTC_PCR14        EQU  (PORTC_BASE + PORTC_PCR14_OFFSET)
PORTC_PCR15        EQU  (PORTC_BASE + PORTC_PCR15_OFFSET)
PORTC_PCR16        EQU  (PORTC_BASE + PORTC_PCR16_OFFSET)
PORTC_PCR17        EQU  (PORTC_BASE + PORTC_PCR17_OFFSET)
PORTC_PCR18        EQU  (PORTC_BASE + PORTC_PCR18_OFFSET)
PORTC_PCR19        EQU  (PORTC_BASE + PORTC_PCR19_OFFSET)
PORTC_PCR20        EQU  (PORTC_BASE + PORTC_PCR20_OFFSET)
PORTC_PCR21        EQU  (PORTC_BASE + PORTC_PCR21_OFFSET)
PORTC_PCR22        EQU  (PORTC_BASE + PORTC_PCR22_OFFSET)
PORTC_PCR23        EQU  (PORTC_BASE + PORTC_PCR23_OFFSET)
PORTC_PCR24        EQU  (PORTC_BASE + PORTC_PCR24_OFFSET)
PORTC_PCR25        EQU  (PORTC_BASE + PORTC_PCR25_OFFSET)
PORTC_PCR26        EQU  (PORTC_BASE + PORTC_PCR26_OFFSET)
PORTC_PCR27        EQU  (PORTC_BASE + PORTC_PCR27_OFFSET)
PORTC_PCR28        EQU  (PORTC_BASE + PORTC_PCR28_OFFSET)
PORTC_PCR29        EQU  (PORTC_BASE + PORTC_PCR29_OFFSET)
PORTC_PCR30        EQU  (PORTC_BASE + PORTC_PCR30_OFFSET)
PORTC_PCR31        EQU  (PORTC_BASE + PORTC_PCR31_OFFSET)
PORTC_GPCLR        EQU  (PORTC_BASE + PORTC_GPCLR_OFFSET)
PORTC_GPCHR        EQU  (PORTC_BASE + PORTC_GPCHR_OFFSET)
PORTC_ISFR         EQU  (PORTC_BASE + PORTC_ISFR_OFFSET)
;---------------------------------------------------------------
;Port D
PORTD_BASE         EQU  0x4004C000
PORTD_PCR0_OFFSET  EQU  0x00
PORTD_PCR1_OFFSET  EQU  0x04
PORTD_PCR2_OFFSET  EQU  0x08
PORTD_PCR3_OFFSET  EQU  0x0C
PORTD_PCR4_OFFSET  EQU  0x10
PORTD_PCR5_OFFSET  EQU  0x14
PORTD_PCR6_OFFSET  EQU  0x18
PORTD_PCR7_OFFSET  EQU  0x1C
PORTD_PCR8_OFFSET  EQU  0x20
PORTD_PCR9_OFFSET  EQU  0x24
PORTD_PCR10_OFFSET EQU  0x28
PORTD_PCR11_OFFSET EQU  0x2C
PORTD_PCR12_OFFSET EQU  0x30
PORTD_PCR13_OFFSET EQU  0x34
PORTD_PCR14_OFFSET EQU  0x38
PORTD_PCR15_OFFSET EQU  0x3C
PORTD_PCR16_OFFSET EQU  0x40
PORTD_PCR17_OFFSET EQU  0x44
PORTD_PCR18_OFFSET EQU  0x48
PORTD_PCR19_OFFSET EQU  0x4C
PORTD_PCR20_OFFSET EQU  0x50
PORTD_PCR21_OFFSET EQU  0x54
PORTD_PCR22_OFFSET EQU  0x58
PORTD_PCR23_OFFSET EQU  0x5C
PORTD_PCR24_OFFSET EQU  0x60
PORTD_PCR25_OFFSET EQU  0x64
PORTD_PCR26_OFFSET EQU  0x68
PORTD_PCR27_OFFSET EQU  0x6C
PORTD_PCR28_OFFSET EQU  0x70
PORTD_PCR29_OFFSET EQU  0x74
PORTD_PCR30_OFFSET EQU  0x78
PORTD_PCR31_OFFSET EQU  0x7C
PORTD_GPCLR_OFFSET EQU  0x80
PORTD_GPCHR_OFFSET EQU  0x84
PORTD_ISFR_OFFSET  EQU  0xA0
PORTD_PCR0         EQU  (PORTD_BASE + PORTD_PCR0_OFFSET)
PORTD_PCR1         EQU  (PORTD_BASE + PORTD_PCR1_OFFSET)
PORTD_PCR2         EQU  (PORTD_BASE + PORTD_PCR2_OFFSET)
PORTD_PCR3         EQU  (PORTD_BASE + PORTD_PCR3_OFFSET)
PORTD_PCR4         EQU  (PORTD_BASE + PORTD_PCR4_OFFSET)
PORTD_PCR5         EQU  (PORTD_BASE + PORTD_PCR5_OFFSET)
PORTD_PCR6         EQU  (PORTD_BASE + PORTD_PCR6_OFFSET)
PORTD_PCR7         EQU  (PORTD_BASE + PORTD_PCR7_OFFSET)
PORTD_PCR8         EQU  (PORTD_BASE + PORTD_PCR8_OFFSET)
PORTD_PCR9         EQU  (PORTD_BASE + PORTD_PCR9_OFFSET)
PORTD_PCR10        EQU  (PORTD_BASE + PORTD_PCR10_OFFSET)
PORTD_PCR11        EQU  (PORTD_BASE + PORTD_PCR11_OFFSET)
PORTD_PCR12        EQU  (PORTD_BASE + PORTD_PCR12_OFFSET)
PORTD_PCR13        EQU  (PORTD_BASE + PORTD_PCR13_OFFSET)
PORTD_PCR14        EQU  (PORTD_BASE + PORTD_PCR14_OFFSET)
PORTD_PCR15        EQU  (PORTD_BASE + PORTD_PCR15_OFFSET)
PORTD_PCR16        EQU  (PORTD_BASE + PORTD_PCR16_OFFSET)
PORTD_PCR17        EQU  (PORTD_BASE + PORTD_PCR17_OFFSET)
PORTD_PCR18        EQU  (PORTD_BASE + PORTD_PCR18_OFFSET)
PORTD_PCR19        EQU  (PORTD_BASE + PORTD_PCR19_OFFSET)
PORTD_PCR20        EQU  (PORTD_BASE + PORTD_PCR20_OFFSET)
PORTD_PCR21        EQU  (PORTD_BASE + PORTD_PCR21_OFFSET)
PORTD_PCR22        EQU  (PORTD_BASE + PORTD_PCR22_OFFSET)
PORTD_PCR23        EQU  (PORTD_BASE + PORTD_PCR23_OFFSET)
PORTD_PCR24        EQU  (PORTD_BASE + PORTD_PCR24_OFFSET)
PORTD_PCR25        EQU  (PORTD_BASE + PORTD_PCR25_OFFSET)
PORTD_PCR26        EQU  (PORTD_BASE + PORTD_PCR26_OFFSET)
PORTD_PCR27        EQU  (PORTD_BASE + PORTD_PCR27_OFFSET)
PORTD_PCR28        EQU  (PORTD_BASE + PORTD_PCR28_OFFSET)
PORTD_PCR29        EQU  (PORTD_BASE + PORTD_PCR29_OFFSET)
PORTD_PCR30        EQU  (PORTD_BASE + PORTD_PCR30_OFFSET)
PORTD_PCR31        EQU  (PORTD_BASE + PORTD_PCR31_OFFSET)
PORTD_GPCLR        EQU  (PORTD_BASE + PORTD_GPCLR_OFFSET)
PORTD_GPCHR        EQU  (PORTD_BASE + PORTD_GPCHR_OFFSET)
PORTD_ISFR         EQU  (PORTD_BASE + PORTD_ISFR_OFFSET)
;---------------------------------------------------------------
;Port E
PORTE_BASE         EQU  0x4004D000
PORTE_PCR0_OFFSET  EQU  0x00
PORTE_PCR1_OFFSET  EQU  0x04
PORTE_PCR2_OFFSET  EQU  0x08
PORTE_PCR3_OFFSET  EQU  0x0C
PORTE_PCR4_OFFSET  EQU  0x10
PORTE_PCR5_OFFSET  EQU  0x14
PORTE_PCR6_OFFSET  EQU  0x18
PORTE_PCR7_OFFSET  EQU  0x1C
PORTE_PCR8_OFFSET  EQU  0x20
PORTE_PCR9_OFFSET  EQU  0x24
PORTE_PCR10_OFFSET EQU  0x28
PORTE_PCR11_OFFSET EQU  0x2C
PORTE_PCR12_OFFSET EQU  0x30
PORTE_PCR13_OFFSET EQU  0x34
PORTE_PCR14_OFFSET EQU  0x38
PORTE_PCR15_OFFSET EQU  0x3C
PORTE_PCR16_OFFSET EQU  0x40
PORTE_PCR17_OFFSET EQU  0x44
PORTE_PCR18_OFFSET EQU  0x48
PORTE_PCR19_OFFSET EQU  0x4C
PORTE_PCR20_OFFSET EQU  0x50
PORTE_PCR21_OFFSET EQU  0x54
PORTE_PCR22_OFFSET EQU  0x58
PORTE_PCR23_OFFSET EQU  0x5C
PORTE_PCR24_OFFSET EQU  0x60
PORTE_PCR25_OFFSET EQU  0x64
PORTE_PCR26_OFFSET EQU  0x68
PORTE_PCR27_OFFSET EQU  0x6C
PORTE_PCR28_OFFSET EQU  0x70
PORTE_PCR29_OFFSET EQU  0x74
PORTE_PCR30_OFFSET EQU  0x78
PORTE_PCR31_OFFSET EQU  0x7C
PORTE_GPCLR_OFFSET EQU  0x80
PORTE_GPCHR_OFFSET EQU  0x84
PORTE_ISFR_OFFSET  EQU  0xA0
PORTE_PCR0         EQU  (PORTE_BASE + PORTE_PCR0_OFFSET)
PORTE_PCR1         EQU  (PORTE_BASE + PORTE_PCR1_OFFSET)
PORTE_PCR2         EQU  (PORTE_BASE + PORTE_PCR2_OFFSET)
PORTE_PCR3         EQU  (PORTE_BASE + PORTE_PCR3_OFFSET)
PORTE_PCR4         EQU  (PORTE_BASE + PORTE_PCR4_OFFSET)
PORTE_PCR5         EQU  (PORTE_BASE + PORTE_PCR5_OFFSET)
PORTE_PCR6         EQU  (PORTE_BASE + PORTE_PCR6_OFFSET)
PORTE_PCR7         EQU  (PORTE_BASE + PORTE_PCR7_OFFSET)
PORTE_PCR8         EQU  (PORTE_BASE + PORTE_PCR8_OFFSET)
PORTE_PCR9         EQU  (PORTE_BASE + PORTE_PCR9_OFFSET)
PORTE_PCR10        EQU  (PORTE_BASE + PORTE_PCR10_OFFSET)
PORTE_PCR11        EQU  (PORTE_BASE + PORTE_PCR11_OFFSET)
PORTE_PCR12        EQU  (PORTE_BASE + PORTE_PCR12_OFFSET)
PORTE_PCR13        EQU  (PORTE_BASE + PORTE_PCR13_OFFSET)
PORTE_PCR14        EQU  (PORTE_BASE + PORTE_PCR14_OFFSET)
PORTE_PCR15        EQU  (PORTE_BASE + PORTE_PCR15_OFFSET)
PORTE_PCR16        EQU  (PORTE_BASE + PORTE_PCR16_OFFSET)
PORTE_PCR17        EQU  (PORTE_BASE + PORTE_PCR17_OFFSET)
PORTE_PCR18        EQU  (PORTE_BASE + PORTE_PCR18_OFFSET)
PORTE_PCR19        EQU  (PORTE_BASE + PORTE_PCR19_OFFSET)
PORTE_PCR20        EQU  (PORTE_BASE + PORTE_PCR20_OFFSET)
PORTE_PCR21        EQU  (PORTE_BASE + PORTE_PCR21_OFFSET)
PORTE_PCR22        EQU  (PORTE_BASE + PORTE_PCR22_OFFSET)
PORTE_PCR23        EQU  (PORTE_BASE + PORTE_PCR23_OFFSET)
PORTE_PCR24        EQU  (PORTE_BASE + PORTE_PCR24_OFFSET)
PORTE_PCR25        EQU  (PORTE_BASE + PORTE_PCR25_OFFSET)
PORTE_PCR26        EQU  (PORTE_BASE + PORTE_PCR26_OFFSET)
PORTE_PCR27        EQU  (PORTE_BASE + PORTE_PCR27_OFFSET)
PORTE_PCR28        EQU  (PORTE_BASE + PORTE_PCR28_OFFSET)
PORTE_PCR29        EQU  (PORTE_BASE + PORTE_PCR29_OFFSET)
PORTE_PCR30        EQU  (PORTE_BASE + PORTE_PCR30_OFFSET)
PORTE_PCR31        EQU  (PORTE_BASE + PORTE_PCR31_OFFSET)
PORTE_GPCLR        EQU  (PORTE_BASE + PORTE_GPCLR_OFFSET)
PORTE_GPCHR        EQU  (PORTE_BASE + PORTE_GPCHR_OFFSET)
PORTE_ISFR         EQU  (PORTE_BASE + PORTE_ISFR_OFFSET)
;---------------------------------------------------------------
;System integration module (SIM)
SIM_BASE             EQU  0x40047000
SIM_SOPT1_OFFSET     EQU  0x00
SIM_SOPT1CFG_OFFSET  EQU  0x04
SIM_SOPT2_OFFSET     EQU  0x1004
SIM_SOPT4_OFFSET     EQU  0x100C
SIM_SOPT5_OFFSET     EQU  0x1010
SIM_SOPT7_OFFSET     EQU  0x1018
SIM_SDID_OFFSET      EQU  0x1024
SIM_SCGC4_OFFSET     EQU  0x1034
SIM_SCGC5_OFFSET     EQU  0x1038
SIM_SCGC6_OFFSET     EQU  0x103C
SIM_SCGC7_OFFSET     EQU  0x1040
SIM_CLKDIV1_OFFSET   EQU  0x1044
SIM_FCFG1_OFFSET     EQU  0x104C
SIM_FCFG2_OFFSET     EQU  0x1050
SIM_UIDMH_OFFSET     EQU  0x1058
SIM_UIDML_OFFSET     EQU  0x105C
SIM_UIDL_OFFSET      EQU  0x1060
SIM_COPC_OFFSET      EQU  0x1100
SIM_SRVCOP_OFFSET    EQU  0x1104
SIM_CLKDIV1          EQU  (SIM_BASE + SIM_CLKDIV1_OFFSET)
SIM_COPC             EQU  (SIM_BASE + SIM_COPC_OFFSET)
SIM_FCFG1            EQU  (SIM_BASE + SIM_FCFG1_OFFSET)
SIM_FCFG2            EQU  (SIM_BASE + SIM_FCFG2_OFFSET)
SIM_SCGC4            EQU  (SIM_BASE + SIM_SCGC4_OFFSET) 
SIM_SCGC5            EQU  (SIM_BASE + SIM_SCGC5_OFFSET)
SIM_SCGC6            EQU  (SIM_BASE + SIM_SCGC6_OFFSET)
SIM_SCGC7            EQU  (SIM_BASE + SIM_SCGC7_OFFSET)
SIM_SDID             EQU  (SIM_BASE + SIM_SDID_OFFSET)
SIM_SOPT1            EQU  (SIM_BASE + SIM_SOPT1_OFFSET)
SIM_SOPT1CFG         EQU  (SIM_BASE + SIM_SOPT1CFG_OFFSET)
SIM_SOPT2            EQU  (SIM_BASE + SIM_SOPT2_OFFSET)
SIM_SOPT4            EQU  (SIM_BASE + SIM_SOPT4_OFFSET)
SIM_SOPT5            EQU  (SIM_BASE + SIM_SOPT5_OFFSET)
SIM_SOPT7            EQU  (SIM_BASE + SIM_SOPT7_OFFSET)
SIM_SRVCOP           EQU  (SIM_BASE + SIM_SRVCOP_OFFSET)
SIM_UIDL             EQU  (SIM_BASE + SIM_UIDL_OFFSET)
SIM_UIDMH            EQU  (SIM_BASE + SIM_UIDMH_OFFSET)
SIM_UIDML            EQU  (SIM_BASE + SIM_UIDML_OFFSET)
;---------------------------------------------------------------
;SIM_CLKDIV1
;31-28:OUTDIV1=clock 1 output divider value
;             :set divider for core/system clock,
;             :from which bus/flash clocks are derived
;             :divide by OUTDIV1 + 1
;27-19:Reserved; read-only; always 0
;18-16:OUTDIV4=clock 4 output divider value
;             :sets divider for bus and flash clocks,
;             :relative to core/system clock
;             :divide by OUTDIV4 + 1
;15-00:Reserved; read-only; always 0
SIM_CLKDIV1_OUTDIV1_MASK       EQU 0xF0000000
SIM_CLKDIV1_OUTDIV1_SHIFT      EQU 28
SIM_CLKDIV1_OUTDIV4_MASK       EQU 0x00070000
SIM_CLKDIV1_OUTDIV4_SHIFT      EQU 16
;---------------------------------------------------------------
;SIM_COPC
;31-04:Reserved; read-only; always 0
;03-02:COPT=COP watchdog timeout
;          :00=disabled
;          :01=timeout after 2^5 LPO cycles or 2^13 bus cycles
;          :10=timeout after 2^8 LPO cycles or 2^16 bus cycles
;          :11=timeout after 2^10 LPO cycles or 2^18 bus cycles
;   01:COPCLKS=COP clock select
;             :0=internal 1 kHz
;             :1=bus clock
;   00:COPW=COP windowed mode
COP_COPT_MASK      EQU  0x0000000C
COP_COPT_SHIFT     EQU  2
COP_COPCLKS_MASK   EQU  0x00000002
COP_COPCLKS_SHIFT  EQU  1
COP_COPW_MASK      EQU  0x00000001
COP_COPW_SHIFT     EQU  1
;---------------------------------------------------------------
;SIM_SCGC4
;1->31-28:Reserved; read-only; always 1
;0->27-24:Reserved; read-only; always 0
;0->   23:SPI1=SPI1 clock gate control (disabled)
;0->   22:SPI0=SPI0 clock gate control (disabled)
;0->21-20:Reserved; read-only; always 0
;0->   19:CMP=comparator clock gate control (disabled)
;0->   18:USBOTG=USB clock gate control (disabled)
;0->17-14:Reserved; read-only; always 0
;0->   13:Reserved; read-only; always 0
;0->   12:UART2=UART2 clock gate control (disabled)
;1->   11:UART1=UART1 clock gate control (disabled)
;0->   10:UART0=UART0 clock gate control (disabled)
;0->09-08:Reserved; read-only; always 0
;0->   07:I2C1=I2C1 clock gate control (disabled)
;0->   06:I2C0=I2C0 clock gate control (disabled)
;1->05-04:Reserved; read-only; always 1
;0->03-00:Reserved; read-only; always 0
SIM_SCGC4_SPI1_MASK     EQU  0x00800000
SIM_SCGC4_SPI1_SHIFT    EQU  23
SIM_SCGC4_SPI0_MASK     EQU  0x00400000
SIM_SCGC4_SPI0_SHIFT    EQU  22
SIM_SCGC4_CMP_MASK      EQU  0x00080000
SIM_SCGC4_CMP_SHIFT     EQU  19
SIM_SCGC4_USBOTG_MASK   EQU  0x00040000
SIM_SCGC4_USBOTG_SHIFT  EQU  18
SIM_SCGC4_UART2_MASK    EQU  0x00001000
SIM_SCGC4_UART2_SHIFT   EQU  12
SIM_SCGC4_UART1_MASK    EQU  0x00000800
SIM_SCGC4_UART1_SHIFT   EQU  11
SIM_SCGC4_UART0_MASK    EQU  0x00000400
SIM_SCGC4_UART0_SHIFT   EQU  10
SIM_SCGC4_I2C1_MASK     EQU  0x00000080
SIM_SCGC4_I2C1_SHIFT    EQU  7
SIM_SCGC4_I2C0_MASK     EQU  0x00000040
SIM_SCGC4_I2C0_SHIFT    EQU  6
;---------------------------------------------------------------
;SIM_SCGC5
;31-20:Reserved; read-only; always 0
;   19:SLCD=segment LCD clock gate control
;18-14:Reserved; read-only; always 0
;   13:PORTE=Port E clock gate control
;   12:PORTD=Port D clock gate control
;   11:PORTC=Port C clock gate control
;   10:PORTB=Port B clock gate control
;    9:PORTA=Port A clock gate control
;08-07:Reserved; read-only; always 1
;    6:Reserved; read-only; always 0
;    5:TSI=TSI access control
;04-02:Reserved; read-only; always 0
;    1:Reserved; read-only; always 0
;    0:LPTMR=Low power timer access control
SIM_SCGC5_SLCD_MASK    EQU  0x00080000
SIM_SCGC5_SLCD_SHIFT   EQU  19
SIM_SCGC5_PORTE_MASK   EQU  0x00002000
SIM_SCGC5_PORTE_SHIFT  EQU  13
SIM_SCGC5_PORTD_MASK   EQU  0x00001000
SIM_SCGC5_PORTD_SHIFT  EQU  12
SIM_SCGC5_PORTC_MASK   EQU  0x00000800
SIM_SCGC5_PORTC_SHIFT  EQU  11
SIM_SCGC5_PORTB_MASK   EQU  0x00000400
SIM_SCGC5_PORTB_SHIFT  EQU  10
SIM_SCGC5_PORTA_MASK   EQU  0x00000200
SIM_SCGC5_PORTA_SHIFT  EQU  9
SIM_SCGC5_TSI_MASK     EQU  0x00000020
SIM_SCGC5_TSI_SHIFT    EQU  6
SIM_SCGC5_LPTMR_MASK   EQU  0x00000001
SIM_SCGC5_LPTMR_SHIFT  EQU  0
;---------------------------------------------------------------
;SIM_SCGC6
;   31:DAC0=DAC0 clock gate control
;   30:(reserved):read-only:0
;   29:RTC=RTC access control
;   28:(reserved):read-only:0
;   27:ADC0=ADC0 clock gate control
;   26:TPM2=TPM2 clock gate control
;   25:TPM1=TMP1 clock gate control
;   24:TPM0=TMP0 clock gate control
;   23:PIT=PIT clock gate control
;22-16:(reserved)
;   15:(reserved)
;14-02:(reserved)
;    1:DMAMUX=DMA mux clock gate control
;    0:FTF=flash memory clock gate control
SIM_SCGC6_DAC0_MASK     EQU  0x80000000
SIM_SCGC6_DAC0_SHIFT    EQU  31
SIM_SCGC6_RTC_MASK      EQU  0x20000000
SIM_SCGC6_RTC_SHIFT     EQU  29
SIM_SCGC6_ADC0_MASK     EQU  0x08000000
SIM_SCGC6_ADC0_SHIFT    EQU  27
SIM_SCGC6_TPM2_MASK     EQU  0x04000000
SIM_SCGC6_TPM2_SHIFT    EQU  26
SIM_SCGC6_TPM1_MASK     EQU  0x02000000
SIM_SCGC6_TPM1_SHIFT    EQU  25
SIM_SCGC6_TPM0_MASK     EQU  0x01000000
SIM_SCGC6_TPM0_SHIFT    EQU  24
SIM_SCGC6_PIT_MASK      EQU  0x00800000
SIM_SCGC6_PIT_SHIFT     EQU  23
SIM_SCGC6_DMAMUX_MASK   EQU  0x00000002
SIM_SCGC6_DMAMUX_SHIFT  EQU  1
SIM_SCGC6_FTF_MASK      EQU  0x00000001
SIM_SCGC6_FTF_SHIFT     EQU  0
;---------------------------------------------------------------
;SIM_SOPT1 (POR or LVD:  0x80000000)
;   31:USBREGEN=USB voltage regulator enable (1)
;   30:USBSSTBY=USB voltage regulator standby during stop, VLPS, LLS, and VLLS (0)
;   29:USBVSTBY=USB voltage regulator standby during VLPS and VLLS (0)
;28-20:(reserved):read-only:000000000
;19-18:OSC32KSEL=32K oscillator clock select (00)
;      (ERCLK32K for sLCD, RTC, and LPTMR)
;                00:System oscillator (OSC32KCLK)
;                01:(reserved)
;                10:RTC_CLKIN
;                11:LPO 1kHz
; 17-6:(reserved):read-only:000000000000
;  5-0:(reserved)
SIM_SOPT1_OSC32KSEL_MASK   EQU  0xC0000
SIM_SOPT1_OSC32KSEL_SHIFT  EQU  18
SIM_SOPT1_USBVSTBY_MASK    EQU  0x20000000
SIM_SOPT1_USBVSTBY_SHIFT   EQU  29
SIM_SOPT1_USBSSTBY_MASK    EQU  0x40000000
SIM_SOPT1_USBSSTBY_SHIFT   EQU  30
SIM_SOPT1_USBREGEN_MASK    EQU  0x80000000
SIM_SOPT1_USBREGEN_SHIFT   EQU  31
;---------------------------------------------------------------
;SIM_SOPT2
;31-28:(reserved):read-only:0
;27-26:UART0SRC=UART0 clock source select
;               00:clock disabled
;               01:MCGFLLCLK or MCGPLLCLK/2
;               10:OSCERCLK
;               11:MCGIRCLK
;25-24:TPMSRC=TPM clock source select
;             00:clock disabled
;             01:MCGFLLCLK or MCGPLLCLK/2
;             10:OSCERCLK
;             11:MCGIRCLK
;23-19:(reserved):read-only:0
;   18:USBSRC=USB clock source select
;             0:USB_CLKIN
;             1:MCGFLLCLK or MCGPLLCLK/2
;   17:(reserved):read-only:0
;   16:PLLFLLSEL=PLL/FLL clock select
;             0:MCGFLLCLK
;             1:MCGPLLCLK/2
;15- 8:(reserved):read-only:0
; 7- 5:CLKOUTSEL=CLKOUT select
;                000:(reserved)
;                001:(reserved)
;                010:bus clock
;                011:LPO clock (1 KHz)
;                100:MCGIRCLK
;                101:(reserved)
;                110:OSCERCLK
;                110:(reserved)
;    4:RTCCLKOUTSEL=RTC clock out select
;                   0:RTC (1 Hz)
;                   1:OSCERCLK
; 3- 0:(reserved):read-only:0
SIM_SOPT2_UART0SRC_MASK       EQU  0x0C000000
SIM_SOPT2_UART0SRC_SHIFT      EQU  26
SIM_SOPT2_TPMSRC_MASK         EQU  0x03000000
SIM_SOPT2_TPMSRC_SHIFT        EQU  24
SIM_SOPT2_USBSRC_MASK         EQU  0x00040000
SIM_SOPT2_USBSRC_SHIFT        EQU  18
SIM_SOPT2_PLLFLLSEL_MASK      EQU  0x00010000
SIM_SOPT2_PLLFLLSEL_SHIFT     EQU  16
SIM_SOPT2_CLKOUTSEL_MASK      EQU  0xE0
SIM_SOPT2_CLKOUTSEL_SHIFT     EQU  5
SIM_SOPT2_RTCCLKOUTSEL_MASK   EQU  0x10
SIM_SOPT2_RTCCLKOUTSEL_SHIFT  EQU  4
;---------------------------------------------------------------
;SIM_SOPT5
;31-20:Reserved; read-only; always 0
;   19:Reserved; read-only; always 0
;   18:UART2ODE=UART2 open drain enable
;   17:UART1ODE=UART1 open drain enable
;   16:UART0ODE=UART0 open drain enable
;15-07:Reserved; read-only; always 0
;   06:UART1TXSRC=UART1 receive data select
;                :0=UART1_RX pin
;                :1=CMP0 output
;05-04:UART1TXSRC=UART1 transmit data select source
;                :00=UART1_TX pin
;                :01=UART1_TX pin modulated with TPM1 channel 0 output
;                :10=UART1_TX pin modulated with TPM2 channel 0 output
;                :11=(reserved)
;   03:Reserved; read-only; always 0
;   02:UART0RXSRC=UART0 receive data select
;                :0=UART0_RX pin
;                :1=CMP0 output
;01-00:UART0TXSRC=UART0 transmit data select source
;                :00=UART0_TX pin
;                :01=UART0_TX pin modulated with TPM1 channel 0 output
;                :10=UART0_TX pin modulated with TPM2 channel 0 output
;                :11=(reserved)
SIM_SOPT5_UART2ODE_MASK     EQU  0x00040000
SIM_SOPT5_UART2ODE_SHIFT    EQU  18
SIM_SOPT5_UART1ODE_MASK     EQU  0x00020000
SIM_SOPT5_UART1ODE_SHIFT    EQU  17
SIM_SOPT5_UART0ODE_MASK     EQU  0x00010000
SIM_SOPT5_UART0ODE_SHIFT    EQU  16
SIM_SOPT5_UART1RXSRC_MASK   EQU  0x00000040
SIM_SOPT5_UART1RXSRC_SHIFT  EQU  6
SIM_SOPT5_UART1TXSRC_MASK   EQU  0x00000030
SIM_SOPT5_UART1TXSRC_SHIFT  EQU  4
SIM_SOPT5_UART0RXSRC_MASK   EQU  0x00000004
SIM_SOPT5_UART0RXSRC_SHIFT  EQU  2
SIM_SOPT5_UART0TXSRC_MASK   EQU  0x00000003
SIM_SOPT5_UART0TXSRC_SHIFT  EQU  0
;---------------------------------------------------------------
;Timer/PWM modules (TPMx)
TPM_SC_OFFSET      EQU  0x00
TPM_CNT_OFFSET     EQU  0x04
TPM_MOD_OFFSET     EQU  0x08
TPM_C0SC_OFFSET    EQU  0x0C
TPM_C0V_OFFSET     EQU  0x10
TPM_C1SC_OFFSET    EQU  0x14
TPM_C1V_OFFSET     EQU  0x18
TPM_C2SC_OFFSET    EQU  0x1C
TPM_C2V_OFFSET     EQU  0x20
TPM_C3SC_OFFSET    EQU  0x24
TPM_C3V_OFFSET     EQU  0x28
TPM_C4SC_OFFSET    EQU  0x2C
TPM_C4V_OFFSET     EQU  0x30
TPM_C5SC_OFFSET    EQU  0x34
TPM_C5V_OFFSET     EQU  0x38
TPM_STATUS_OFFSET  EQU  0x50
TPM_CONF_OFFSET    EQU  0x84
;---------------------------------------------------------------
;TPMx_CnSC:  Channel n Status and Control
;31-8:(reserved):read-only:0
;   7:CHF=channel flag
;         set on channel event
;         write 1 to clear
;   6:CHIE=channel interrupt enable
;   5:MSB=channel mode select B (see selection table below)
;   4:MSA=channel mode select A (see selection table below)
;   3:ELSB=edge or level select B (see selection table below)
;   2:ELSA=edge or level select A (see selection table below)
;   1:(reserved):read-only:0
;   0:DMA=DMA enable
;Mode, Edge, and Level Selection
;MSB:MSA | ELSB:ELSA | Mode           | Configuration
;  0 0   |    0 0    | (none)         | channel disabled
;  0 1   |    0 0    | SW compare     | pin not used
;  1 X   |    0 0    | SW compare     | pin not used
;  0 0   |    0 1    | input capture  | rising edge
;  0 0   |    1 0    | input capture  | falling edge
;  0 0   |    1 1    | input capture  | either edge
;  0 1   |    0 1    | output compare | toggle on match
;  0 1   |    1 0    | output compare | clear on match
;  0 1   |    1 1    | output compare | set on match
;  1 0   |    X 1    | PWM            | low pulse
;  1 0   |    1 0    | PWM            | high pulse
;  1 1   |    X 1    | output compare | pulse high on match
;  1 1   |    1 0    | output compare | pulse low on match
TPM_CnSC_CHF_MASK    EQU  0x80
TPM_CnSC_CHF_SHIFT   EQU  7
TPM_CnSC_CHIE_MASK   EQU  0x40
TPM_CnSC_CHIE_SHIFT  EQU  6
TPM_CnSC_MSB_MASK    EQU  0x20
TPM_CnSC_MSB_SHIFT   EQU  5
TPM_CnSC_MSA_MASK    EQU  0x10
TPM_CnSC_MSA_SHIFT   EQU  4
TPM_CnSC_ELSB_MASK   EQU  0x08
TPM_CnSC_ELSB_SHIFT  EQU  3
TPM_CnSC_ELSA_MASK   EQU  0x04
TPM_CnSC_ELSA_SHIFT  EQU  2
TPM_CnSC_CDMA_MASK   EQU  0x01
TPM_CnSC_CDMA_SHIFT  EQU  0
;---------------------------------------------------------------
;TPMx_CnV:  Channel n Value
;31-16:(reserved):read-only:0
;16- 0:MOD (all bytes must be written at the same time)
TPM_CnV_VAL_MASK   EQU 0xFFFF
TPM_CnV_VAL_SHIFT  EQU 0
;---------------------------------------------------------------
;TPMx_CONF:  Configuration
;31-28:(reserved):read-only:0
;27-24:TRGSEL=trigger select
;             should be changed only when counter disabled
;             0000:EXTRG_IN (external trigger pin input)
;             0001:CMP0 output
;             0010:(reserved)
;             0011:(reserved)
;             0100:PIT trigger 0
;             0101:PIT trigger 1
;             0110:(reserved)
;             0111:(reserved)
;             1000:TPM0 overflow
;             1001:TPM1 overflow
;             1010:TPM2 overflow
;             1011:(reserved)
;             1100:RTC alarm
;             1101:RTC seconds
;             1110:LPTMR trigger
;             1111:(reserved)
;23-19:(reserved):read-only:0
;   18:CROT=counter reload on trigger
;           should be changed only when counter disabled
;   17:CSOO=counter stop on overflow
;           should be changed only when counter disabled
;   16:CSOT=counter start on trigger
;           should be changed only when counter disabled
;15-10:(reserved):read-only:0
;    9:GTBEEN=global time base enable
;    8:(reserved):read-only:0
; 7- 6:DBGMODE=debug mode
;              00:paused during debug, and during debug
;                 trigger and input caputure events ignored
;              01:(reserved)
;              10:(reserved)
;              11:counter continues during debug
;    5:DOZEEN=doze enable
;             0:counter continues during debug
;             1:paused during debug, and during debug
;               trigger and input caputure events ignored
; 4- 0:(reserved):read-only:0
TPM_CONF_TRGSEL_MASK    EQU  0x0F000000
TPM_CONF_TRGSEL_SHIFT   EQU  24
TPM_CONF_CROT_MASK      EQU  0x00040000
TPM_CONF_CROT_SHIFT     EQU  18
TPM_CONF_CSOO_MASK      EQU  0x00020000
TPM_CONF_CSOO_SHIFT     EQU  17
TPM_CONF_CSOT_MASK      EQU  0x00010000
TPM_CONF_CSOT_SHIFT     EQU  16
TPM_CONF_GTBEEN_MASK    EQU  0x200
TPM_CONF_GTBEEN_SHIFT   EQU  9
TPM_CONF_DBGMODE_MASK   EQU  0xC0
TPM_CONF_DBGMODE_SHIFT  EQU  6
TPM_CONF_DOZEEN_MASK    EQU  0x20
TPM_CONF_DOZEEN_SHIFT   EQU  5
;---------------------------------------------------------------
;TPMx_MOD:  Modulo
;31-16:(reserved):read-only:0
;16- 0:MOD (all bytes must be written at the same time)
TPM_MOD_MOD_MASK   EQU 0xFFFF
TPM_MOD_MOD_SHIFT  EQU 0xFFFF
;---------------------------------------------------------------
;TPMx_SC:  Status and Control
;31-9:(reserved):read-only:0
;   8:DMA=DMA enable
;   7:TOF=timer overflow flag
;         set on count after TPMx_CNT = TPMx_MOD
;         write 1 to clear
;   6:TOIE=timer overflow interrupt enable
;   5:CPWMS=center-aligned PWM select
;           0:edge align (up count)
;           1:center align (up-down count)
; 4-3:CMOD=clock mode selection
;          00:counter disabled
;          01:TPMx_CNT increments on every TPMx clock
;          10:TPMx_CNT increments on rising edge of TPMx_EXTCLK
;          11:(reserved)
; 2-0:PS=prescale factor selection
;        can be written only when counter is disabled
;        count clock = CMOD selected clock / 2^PS
TPM_SC_DMA_MASK     EQU 0x100
TPM_SC_DMA_SHIFT    EQU 8
TPM_SC_TOF_MASK     EQU 0x80
TPM_SC_TOF_SHIFT    EQU 7
TPM_SC_TOIE_MASK    EQU 0x40
TPM_SC_TOIE_SHIFT   EQU 6
TPM_SC_CPWMS_MASK   EQU 0x20
TPM_SC_CPWMS_SHIFT  EQU 5
TPM_SC_CMOD_MASK    EQU 0x18
TPM_SC_CMOD_SHIFT   EQU 3
TPM_SC_PS_MASK      EQU 0x07
TPM_SC_PS_SHIFT     EQU 0
;---------------------------------------------------------------
;TPMx_STATUS:  Capture and Compare Status
;31-9:(reserved):read-only:0
;   8:TOF=timer overflow flag=TPMx_SC.TOF
; 7-6:(reserved):read-only:0
;   5:CH5F=channel 5 flag=TPMx_C5SC.CHF
;   4:CH4F=channel 4 flag=TPMx_C4SC.CHF
;   3:CH3F=channel 3 flag=TPMx_C3SC.CHF
;   2:CH2F=channel 2 flag=TPMx_C2SC.CHF
;   1:CH1F=channel 1 flag=TPMx_C1SC.CHF
;   0:CH0F=channel 0 flag=TPMx_C0SC.CHF
TPM_STATUS_TOF_MASK    EQU 0x100
TPM_STATUS_TOF_SHIFT   EQU 8
TPM_STATUS_CH5F_MASK   EQU 0x20
TPM_STATUS_CH5F_SHIFT  EQU 5
TPM_STATUS_CH4F_MASK   EQU 0x10
TPM_STATUS_CH4F_SHIFT  EQU 4
TPM_STATUS_CH3F_MASK   EQU 0x08
TPM_STATUS_CH3F_SHIFT  EQU 3
TPM_STATUS_CH2F_MASK   EQU 0x04
TPM_STATUS_CH2F_SHIFT  EQU 2
TPM_STATUS_CH1F_MASK   EQU 0x02
TPM_STATUS_CH1F_SHIFT  EQU 1
TPM_STATUS_CH0F_MASK   EQU 0x01
TPM_STATUS_CH0F_SHIFT  EQU 0
;---------------------------------------------------------------
;Timer/PWM module 0 (TPM0)
TPM0_BASE           EQU  0x40038000
TPM0_SC      EQU (TPM0_BASE + TPM_SC_OFFSET    )
TPM0_CNT     EQU (TPM0_BASE + TPM_CNT_OFFSET   )
TPM0_MOD     EQU (TPM0_BASE + TPM_MOD_OFFSET   )
TPM0_C0SC    EQU (TPM0_BASE + TPM_C0SC_OFFSET  )
TPM0_C0V     EQU (TPM0_BASE + TPM_C0V_OFFSET   )
TPM0_C1SC    EQU (TPM0_BASE + TPM_C1SC_OFFSET  )
TPM0_C1V     EQU (TPM0_BASE + TPM_C1V_OFFSET   )
TPM0_C2SC    EQU (TPM0_BASE + TPM_C2SC_OFFSET  )
TPM0_C2V     EQU (TPM0_BASE + TPM_C2V_OFFSET   )
TPM0_C3SC    EQU (TPM0_BASE + TPM_C3SC_OFFSET  )
TPM0_C3V     EQU (TPM0_BASE + TPM_C3V_OFFSET   )
TPM0_C4SC    EQU (TPM0_BASE + TPM_C4SC_OFFSET  )
TPM0_C4V     EQU (TPM0_BASE + TPM_C4V_OFFSET   )
TPM0_C5SC    EQU (TPM0_BASE + TPM_C5SC_OFFSET  )
TPM0_C5V     EQU (TPM0_BASE + TPM_C5V_OFFSET   )
TPM0_STATUS  EQU (TPM0_BASE + TPM_STATUS_OFFSET)
TPM0_CONF    EQU (TPM0_BASE + TPM_CONF_OFFSET  )
;---------------------------------------------------------------
;Timer/PWM module 1 (TPM1)
TPM1_BASE           EQU  0x40039000
TPM1_SC      EQU (TPM1_BASE + TPM_SC_OFFSET    )
TPM1_CNT     EQU (TPM1_BASE + TPM_CNT_OFFSET   )
TPM1_MOD     EQU (TPM1_BASE + TPM_MOD_OFFSET   )
TPM1_C0SC    EQU (TPM1_BASE + TPM_C0SC_OFFSET  )
TPM1_C0V     EQU (TPM1_BASE + TPM_C0V_OFFSET   )
TPM1_C1SC    EQU (TPM1_BASE + TPM_C1SC_OFFSET  )
TPM1_C1V     EQU (TPM1_BASE + TPM_C1V_OFFSET   )
TPM1_C2SC    EQU (TPM1_BASE + TPM_C2SC_OFFSET  )
TPM1_C2V     EQU (TPM1_BASE + TPM_C2V_OFFSET   )
TPM1_C3SC    EQU (TPM1_BASE + TPM_C3SC_OFFSET  )
TPM1_C3V     EQU (TPM1_BASE + TPM_C3V_OFFSET   )
TPM1_C4SC    EQU (TPM1_BASE + TPM_C4SC_OFFSET  )
TPM1_C4V     EQU (TPM1_BASE + TPM_C4V_OFFSET   )
TPM1_C5SC    EQU (TPM1_BASE + TPM_C5SC_OFFSET  )
TPM1_C5V     EQU (TPM1_BASE + TPM_C5V_OFFSET   )
TPM1_STATUS  EQU (TPM1_BASE + TPM_STATUS_OFFSET)
TPM1_CONF    EQU (TPM1_BASE + TPM_CONF_OFFSET  )
;---------------------------------------------------------------
;Timer/PWM module 2 (TPM2)
TPM2_BASE           EQU  0x4003A000
TPM2_SC      EQU (TPM2_BASE + TPM_SC_OFFSET    )
TPM2_CNT     EQU (TPM2_BASE + TPM_CNT_OFFSET   )
TPM2_MOD     EQU (TPM2_BASE + TPM_MOD_OFFSET   )
TPM2_C0SC    EQU (TPM2_BASE + TPM_C0SC_OFFSET  )
TPM2_C0V     EQU (TPM2_BASE + TPM_C0V_OFFSET   )
TPM2_C1SC    EQU (TPM2_BASE + TPM_C1SC_OFFSET  )
TPM2_C1V     EQU (TPM2_BASE + TPM_C1V_OFFSET   )
TPM2_C2SC    EQU (TPM2_BASE + TPM_C2SC_OFFSET  )
TPM2_C2V     EQU (TPM2_BASE + TPM_C2V_OFFSET   )
TPM2_C3SC    EQU (TPM2_BASE + TPM_C3SC_OFFSET  )
TPM2_C3V     EQU (TPM2_BASE + TPM_C3V_OFFSET   )
TPM2_C4SC    EQU (TPM2_BASE + TPM_C4SC_OFFSET  )
TPM2_C4V     EQU (TPM2_BASE + TPM_C4V_OFFSET   )
TPM2_C5SC    EQU (TPM2_BASE + TPM_C5SC_OFFSET  )
TPM2_C5V     EQU (TPM2_BASE + TPM_C5V_OFFSET   )
TPM2_STATUS  EQU (TPM2_BASE + TPM_STATUS_OFFSET)
TPM2_CONF    EQU (TPM2_BASE + TPM_CONF_OFFSET  )
;---------------------------------------------------------------
;UART 0
UART0_BASE  EQU  0x4006A000
UART0_BDH_OFFSET  EQU  0x00
UART0_BDL_OFFSET  EQU  0x01
UART0_C1_OFFSET   EQU  0x02
UART0_C2_OFFSET   EQU  0x03
UART0_S1_OFFSET   EQU  0x04
UART0_S2_OFFSET   EQU  0x05
UART0_C3_OFFSET   EQU  0x06
UART0_D_OFFSET    EQU  0x07
UART0_MA1_OFFSET  EQU  0x08
UART0_MA2_OFFSET  EQU  0x09
UART0_C4_OFFSET   EQU  0x0A
UART0_C5_OFFSET   EQU  0x0B
UART0_BDH        EQU  (UART0_BASE + UART0_BDH_OFFSET)
UART0_BDL        EQU  (UART0_BASE + UART0_BDL_OFFSET)
UART0_C1         EQU  (UART0_BASE + UART0_C1_OFFSET)
UART0_C2         EQU  (UART0_BASE + UART0_C2_OFFSET)
UART0_S1         EQU  (UART0_BASE + UART0_S1_OFFSET)
UART0_S2         EQU  (UART0_BASE + UART0_S2_OFFSET)
UART0_C3         EQU  (UART0_BASE + UART0_C3_OFFSET)
UART0_D          EQU  (UART0_BASE + UART0_D_OFFSET)
UART0_MA1        EQU  (UART0_BASE + UART0_MA1_OFFSET)
UART0_MA2        EQU  (UART0_BASE + UART0_MA2_OFFSET)
UART0_C4         EQU  (UART0_BASE + UART0_C4_OFFSET)
UART0_C5         EQU  (UART0_BASE + UART0_C5_OFFSET)
;---------------------------------------------------------------
;UART0_BDH
;  7:LBKDIE=LIN break detect IE
;  6:RXEDGIE=RxD input active edge IE
;  5:SBNS=Stop bit number select
;4-0:SBR[12:0] (BUSCLK / (16 x 9600))
UART0_BDH_LBKDIE_MASK    EQU  0x80
UART0_BDH_LBKDIE_SHIFT   EQU  7
UART0_BDH_RXEDGIE_MASK   EQU  0x40
UART0_BDH_RXEDGIE_SHIFT  EQU  6
UART0_BDH_SBNS_MASK      EQU  0x20
UART0_BDH_SBNS_SHIFT     EQU  5
UART0_BDH_SBR_MASK       EQU  0x1F
UART0_BDH_SBR_SHIFT      EQU  0
;---------------------------------------------------------------
;UART0_BDL
;7-0:SBR[7:0] (BUSCLK / 16 x 9600))
UART0_BDL_SBR_MASK   EQU  0xFF
UART0_BDL_SBR_SHIFT  EQU  0
;---------------------------------------------------------------
;UART0_C1
;7:LOOPS=loop mode select (normal)
;6:DOZEEN=UART disabled in wait mode (enabled)
;5:RSRC=receiver source select (internal--no effect LOOPS=0)
;4:M=9- or 8-bit mode select (1 start, 8 data [lsb first], 1 stop)
;3:WAKE=receiver wakeup method select (idle)
;2:IDLE=idle line type select (idle begins after start bit)
;1:PE=parity enable (disabled)
;0:PT=parity type (even parity--no effect PE=0)
UART0_C1_LOOPS_MASK      EQU  0x80
UART0_C1_LOOPS_SHIFT     EQU  7
UART0_C1_DOZEEN_MASK     EQU  0x40
UART0_C1_DOZEEN_SHIFT    EQU  6
UART0_C1_RSRC_MASK       EQU  0x20
UART0_C1_RSRC_SHIFT      EQU  5
UART0_C1_M_MASK          EQU  0x10
UART0_C1_M_SHIFT         EQU  4
UART0_C1_WAKE_MASK       EQU  0x08
UART0_C1_WAKE_SHIFT      EQU  3
UART0_C1_ILT_MASK        EQU  0x04
UART0_C1_ILT_SHIFT       EQU  2
UART0_C1_PE_MASK         EQU  0x02
UART0_C1_PE_SHIFT        EQU  1
UART0_C1_PT_MASK         EQU  0x01
UART0_C1_PT_SHIFT        EQU  0
;---------------------------------------------------------------
;UART0_C2
;7:TIE=transmitter IE for TDRE (disabled)
;6:TCIE=trasmission complete IE for TC (disabled)
;5:RIE=receiver IE for RDRF (disabled)
;4:ILIE=idle line IE for IDLE (disabled)
;3:TE=transmitter enable (disabled)
;2:RE=receiver enable (disabled)
;1:RWU=receiver wakeup control (normal)
;0:SBK=send break (disabled, normal)
UART0_C2_TIE_MASK    EQU  0x80
UART0_C2_TIE_SHIFT   EQU  7
UART0_C2_TCIE_MASK   EQU  0x40
UART0_C2_TCIE_SHIFT  EQU  6
UART0_C2_RIE_MASK    EQU  0x20
UART0_C2_RIE_SHIFT   EQU  5
UART0_C2_ILIE_MASK   EQU  0x10
UART0_C2_ILIE_SHIFT  EQU  4
UART0_C2_TE_MASK     EQU  0x08
UART0_C2_TE_SHIFT    EQU  3
UART0_C2_RE_MASK     EQU  0x04
UART0_C2_RE_SHIFT    EQU  2
UART0_C2_RWU_MASK    EQU  0x02
UART0_C2_RWU_SHIFT   EQU  1
UART0_C2_SBK_MASK    EQU  0x01
UART0_C2_SBK_SHIFT   EQU  0
;---------------------------------------------------------------
;UART0_C3
;7:R8T9=Receive bit 8; transmit bit 9 (not used M=0)
;6:R9T8=Receive bit 9; transmit bit 8 (not used M=0)
;5:TXDIR=TxD pin direction in single-wire mode 
;                        (input--no effect LOOPS=0)
;4:TXINV=transmit data inversion (not invereted)
;3:ORIE=overrun IE for OR (disabled)
;2:NEIE=noise error IE for NF (disabled)
;1:FEIE=framing error IE for FE (disabled)
;0:PEIE=parity error IE for PF (disabled)
UART0_C3_R8T9_MASK    EQU  0x80
UART0_C3_R8T9_SHIFT   EQU  7
UART0_C3_R9T8_MASK    EQU  0x40
UART0_C3_R9T8_SHIFT   EQU  6
UART0_C3_TXDIR_MASK   EQU  0x20
UART0_C3_TXDIR_SHIFT  EQU  5
UART0_C3_TXINV_MASK   EQU  0x10
UART0_C3_TXINV_SHIFT  EQU  4
UART0_C3_ORIE_MASK    EQU  0x08
UART0_C3_ORIE_SHIFT   EQU  3
UART0_C3_NEIE_MASK    EQU  0x04
UART0_C3_NEIE_SHIFT   EQU  2
UART0_C3_FEIE_MASK    EQU  0x02
UART0_C3_FEIE_SHIFT   EQU  1
UART0_C3_PEIE_MASK    EQU  0x01
UART0_C3_PEIE_SHIFT   EQU  0
;---------------------------------------------------------------
;UART0_C4
;  7:MAEN1=Match address mode enable 1 (disabled)
;  6:MAEN2=Match address mode enable 2 (disabled)
;  5:M10=10-bit mode select (not selected)
;4-0:OSR=Over sampling ratio (01111)
;        00000 <= OSR <= 00010:  (invalid; defaults to ratio = 16)        
;        00011 <= OSR <= 11111:  ratio = OSR + 1
UART0_C4_MAEN1_MASK   EQU  0x80
UART0_C4_MAEN1_SHIFT  EQU  7
UART0_C4_MAEN2_MASK   EQU  0x40
UART0_C4_MAEN2_SHIFT  EQU  6
UART0_C4_M10_MASK     EQU  0x20
UART0_C4_M10_SHIFT    EQU  5
UART0_C4_OSR_MASK     EQU  0x1F
UART0_C4_OSR_SHIFT    EQU  0
;---------------------------------------------------------------
;UART0_C5
;  7:TDMAE=Transmitter DMA enable (disabled)
;  6:(reserved):  read-only:  0
;  5:RDMAE=Receiver full DMA enable (disabled)
;4-2:(reserved):  read-only:  000
;  1:BOTHEDGE=Both edge sampling (only rising edge)
;  0:RESYNCDIS=Resynchronization disable (enabled)
UART0_C5_TDMAE_MASK       EQU  0x80
UART0_C5_TDMAE_SHIFT      EQU  7
UART0_C5_RDMAE_MASK       EQU  0x20
UART0_C5_RDMAE_SHIFT      EQU  5
UART0_C5_BOTHEDGE_MASK    EQU  0x02
UART0_C5_BOTHEDGE_SHIFT   EQU  1
UART0_C5_RESYNCDIS_MASK   EQU  0x01
UART0_C5_RESYNCDIS_SHIFT  EQU  0
;---------------------------------------------------------------
;UART0_D
;7:R7T7=Receive data buffer bit 7; 
;       transmit data buffer bit 7
;6:R6T6=Receive data buffer bit 6; 
;       transmit data buffer bit 6
;5:R5T5=Receive data buffer bit 5; 
;       transmit data buffer bit 5
;4:R4T4=Receive data buffer bit 4; 
;       transmit data buffer bit 4
;3:R3T3=Receive data buffer bit 3; 
;       transmit data buffer bit 3
;2:R2T2=Receive data buffer bit 2; 
;       transmit data buffer bit 2
;1:R1T1=Receive data buffer bit 1; 
;       transmit data buffer bit 1
;0:R0T0=Receive data buffer bit 0; 
;       transmit data buffer bit 0
UART0_D_R7T7_MASK   EQU  0x80
UART0_D_R7T7_SHIFT  EQU  7
UART0_D_R6T6_MASK   EQU  0x40
UART0_D_R6T6_SHIFT  EQU  6
UART0_D_R5T5_MASK   EQU  0x20
UART0_D_R5T5_SHIFT  EQU  5
UART0_D_R4T4_MASK   EQU  0x10
UART0_D_R4T4_SHIFT  EQU  4
UART0_D_R3T3_MASK   EQU  0x08
UART0_D_R3T3_SHIFT  EQU  3
UART0_D_R2T2_MASK   EQU  0x04
UART0_D_R2T2_SHIFT  EQU  2
UART0_D_R1T1_MASK   EQU  0x02
UART0_D_R1T1_SHIFT  EQU  1
UART0_D_R0T0_MASK   EQU  0x01
UART0_D_R0T0_SHIFT  EQU  0
;---------------------------------------------------------------
;UART0_MA1
;7-0:MA=Match address
UART0_MA1_MA_MASK   EQU  0xFF
UART0_MA1_MA_SHIFT  EQU  0
;---------------------------------------------------------------
;UART0_MA2
;7-0:MA=Match address
UART0_MA2_MA_MASK   EQU  0xFF
UART0_MA2_MA_SHIFT  EQU  0
;---------------------------------------------------------------
;UART0_S1
;7:TDRE=transmit data register empty flag
;6:TC=transmission complete flag
;5:RDRF=receive data register full flag
;4:IDLE=idle line flag
;3:OR=receiver overrun flag
;2:NF=noise flag
;1:FE=framing error flag
;0:PF=parity error flag
UART0_S1_TDRE_MASK   EQU 0x80
UART0_S1_TDRE_SHIFT  EQU 7
UART0_S1_TC_MASK     EQU 0x40
UART0_S1_TC_SHIFT    EQU 6
UART0_S1_RDRF_MASK   EQU 0x20
UART0_S1_RDRF_SHIFT  EQU 5
UART0_S1_IDLE_MASK   EQU 0x10
UART0_S1_IDLE_SHIFT  EQU 4
UART0_S1_OR_MASK     EQU 0x08
UART0_S1_OR_SHIFT    EQU 3
UART0_S1_NF_MASK     EQU 0x04
UART0_S1_NF_SHIFT    EQU 2
UART0_S1_FE_MASK     EQU 0x02
UART0_S1_FE_SHIFT    EQU 1
UART0_S1_PF_MASK     EQU 0x01
UART0_S1_PF_SHIFT    EQU 0
;---------------------------------------------------------------
;UART0_S2
;7:LBKDIF=LIN break detect interrupt flag
;6:RXEDGIF=RxD pin active edge interrupt flag
;5:MSBF=MSB first (LSB first)
;4:RXINV=receive data inversion (not inverted)
;3:RWUID=receive wake-up idle detect (not detected)
;2:BRK13=break character generation length (10 bit times)
;1:LBKDE=LIN break detect enable (10 bit times)
;0:RAF=receiver active flag
UART0_S2_LBKDIF_MASK   EQU 0x80
UART0_S2_LBKDIF_SHIFT  EQU 7
UART0_S2_RXEDGIF_MASK  EQU 0x40
UART0_S2_RXEDGIF_SHIFT EQU 6
UART0_S2_MSBF_MASK     EQU 0x20
UART0_S2_MSBF_SHIFT    EQU 5
UART0_S2_RXINV_MASK    EQU 0x10
UART0_S2_RXINV_SHIFT   EQU 4
UART0_S2_RWUID_MASK    EQU 0x08
UART0_S2_RWUID_SHIFT   EQU 3
UART0_S2_BRK13_MASK    EQU 0x04
UART0_S2_BRK13_SHIFT   EQU 2
UART0_S2_LBKDE_MASK    EQU 0x02
UART0_S2_LBKDE_SHIFT   EQU 1
UART0_S2_RAF_MASK      EQU 0x01
UART0_S2_RAF_SHIFT     EQU 0
;---------------------------------------------------------------
;UART 1 and UART2
UART_BDH_OFFSET  EQU  0x00
UART_BDL_OFFSET  EQU  0x01
UART_C1_OFFSET   EQU  0x02
UART_C2_OFFSET   EQU  0x03
UART_S1_OFFSET   EQU  0x04
UART_S2_OFFSET   EQU  0x05
UART_C3_OFFSET   EQU  0x06
UART_D_OFFSET    EQU  0x07
UART_C4_OFFSET   EQU  0x08
;---------------------------------------------------------------
;UART 1
UART1_BASE  EQU  0x4006B000
UART1_BDH        EQU  (UART1_BASE + UART_BDH_OFFSET)
UART1_BDL        EQU  (UART1_BASE + UART_BDL_OFFSET)
UART1_C1         EQU  (UART1_BASE + UART_C1_OFFSET)
UART1_C2         EQU  (UART1_BASE + UART_C2_OFFSET)
UART1_S1         EQU  (UART1_BASE + UART_S1_OFFSET)
UART1_S2         EQU  (UART1_BASE + UART_S2_OFFSET)
UART1_C3         EQU  (UART1_BASE + UART_C3_OFFSET)
UART1_D          EQU  (UART1_BASE + UART_D_OFFSET)
UART1_C4         EQU  (UART1_BASE + UART_C4_OFFSET)
;---------------------------------------------------------------
;UART 2
UART2_BASE  EQU  0x4006C000
UART2_BDH        EQU  (UART2_BASE + UART_BDH_OFFSET)
UART2_BDL        EQU  (UART2_BASE + UART_BDL_OFFSET)
UART2_C1         EQU  (UART2_BASE + UART_C1_OFFSET)
UART2_C2         EQU  (UART2_BASE + UART_C2_OFFSET)
UART2_S1         EQU  (UART2_BASE + UART_S1_OFFSET)
UART2_S2         EQU  (UART2_BASE + UART_S2_OFFSET)
UART2_C3         EQU  (UART2_BASE + UART_C3_OFFSET)
UART2_D          EQU  (UART2_BASE + UART_D_OFFSET)
UART2_C4         EQU  (UART2_BASE + UART_C4_OFFSET)
;---------------------------------------------------------------
;UARTx_BDH
;  7:LBKDIE=LIN break detect IE
;  6:RXEDGIE=RxD input active edge IE
;  5:SBNS=Stop bit number select
;4-0:SBR[12:0] (BUSCLK / (16 x 9600))
UART_BDH_LBKDIE_MASK    EQU  0x80
UART_BDH_LBKDIE_SHIFT   EQU  7
UART_BDH_RXEDGIE_MASK   EQU  0x40
UART_BDH_RXEDGIE_SHIFT  EQU  6
UART_BDH_SBNS_MASK      EQU  0x20
UART_BDH_SBNS_SHIFT     EQU  5
UART_BDH_SBR_MASK       EQU  0x1F
UART_BDH_SBR_SHIFT      EQU  0
;---------------------------------------------------------------
;UARTx_BDL
;7-0:SBR[7:0] (BUSCLK / 16 x 9600))
UART_BDL_SBR_MASK   EQU  0xFF
UART_BDL_SBR_SHIFT  EQU  0
;---------------------------------------------------------------
;UARTx_C1
;7:LOOPS=loops select (normal)
;6:UARTSWAI=UART stop in wait mode (disabled)
;5:RSRC=receiver source select (internal--no effect LOOPS=0)
;4:M=9- or 8-bit mode select (1 start, 8 data [lsb first], 1 stop)
;3:WAKE=receiver wakeup method select (idle)
;2:IDLE=idle line type select (idle begins after start bit)
;1:PE=parity enable (disabled)
;0:PT=parity type (even parity--no effect PE=0)
UART_C1_LOOPS_MASK      EQU  0x80
UART_C1_LOOPS_SHIFT     EQU  7
UART_C1_UARTSWAI_MASK   EQU  0x40
UART_C1_UARTSWAI_SHIFT  EQU  6
UART_C1_RSRC_MASK       EQU  0x20
UART_C1_RSRC_SHIFT      EQU  5
UART_C1_M_MASK          EQU  0x10
UART_C1_M_SHIFT         EQU  4
UART_C1_WAKE_MASK       EQU  0x08
UART_C1_WAKE_SHIFT      EQU  3
UART_C1_ILT_MASK        EQU  0x04
UART_C1_ILT_SHIFT       EQU  2
UART_C1_PE_MASK         EQU  0x02
UART_C1_PE_SHIFT        EQU  1
UART_C1_PT_MASK         EQU  0x01
UART_C1_PT_SHIFT        EQU  0
;---------------------------------------------------------------
;UARTx_C2
;7:TIE=transmit IE for TDRE (disabled)
;6:TCIE=trasmission complete IE for TC (disabled)
;5:RIE=receiver IE for RDRF (disabled)
;4:ILIE=idle line IE for IDLE (disabled)
;3:TE=transmitter enable (enabled)
;2:RE=receiver enable (enabled)
;1:RWU=receiver wakeup control (normal)
;0:SBK=send break (disabled, normal)
UART_C2_TIE_MASK    EQU  0x80
UART_C2_TIE_SHIFT   EQU  7
UART_C2_TCIE_MASK   EQU  0x40
UART_C2_TCIE_SHIFT  EQU  6
UART_C2_RIE_MASK    EQU  0x20
UART_C2_RIE_SHIFT   EQU  5
UART_C2_ILIE_MASK   EQU  0x10
UART_C2_ILIE_SHIFT  EQU  4
UART_C2_TE_MASK     EQU  0x08
UART_C2_TE_SHIFT    EQU  3
UART_C2_RE_MASK     EQU  0x04
UART_C2_RE_SHIFT    EQU  2
UART_C2_RWU_MASK    EQU  0x02
UART_C2_RWU_SHIFT   EQU  1
UART_C2_SBK_MASK    EQU  0x01
UART_C2_SBK_SHIFT   EQU  0
;---------------------------------------------------------------
;UARTx_C3
;7:R8=9th data bit for receiver (not used M=0)
;6:T8=9th data bit for transmitter (not used M=0)
;5:TXDIR=TxD pin direction in single-wire mode (no effect LOOPS=0)
;4:TXINV=transmit data inversion (not invereted)
;3:ORIE=overrun IE for OR (disabled)
;2:NEIE=noise error IE for NF (disabled)
;1:FEIE=framing error IE for FE (disabled)
;0:PEIE=parity error IE for PF (disabled)
UART_C3_R8_MASK      EQU  0x80
UART_C3_R8_SHIFT     EQU  7
UART_C3_T8_MASK      EQU  0x40
UART_C3_T8_SHIFT     EQU  6
UART_C3_TXDIR_MASK   EQU  0x20
UART_C3_TXDIR_SHIFT  EQU  5
UART_C3_TXINV_MASK   EQU  0x10
UART_C3_TXINV_SHIFT  EQU  4
UART_C3_ORIE_MASK    EQU  0x08
UART_C3_ORIE_SHIFT   EQU  3
UART_C3_NEIE_MASK    EQU  0x04
UART_C3_NEIE_SHIFT   EQU  2
UART_C3_FEIE_MASK    EQU  0x02
UART_C3_FEIE_SHIFT   EQU  1
UART_C3_PEIE_MASK    EQU  0x01
UART_C3_PEIE_SHIFT   EQU  0
;---------------------------------------------------------------
;UARTx_C4
;  7:TDMAS=transmitter DMA select (disabled)
;  6:(reserved); read-only; always 0
;  5:RDMAS=receiver full DMA select (disabled)
;  4:(reserved); read-only; always 0
;  3:(reserved); read-only; always 0
;2-0:(reserved); read-only; always 0
UART_C4_TDMAS_MASK   EQU  0x80
UART_C4_TDMAS_SHIFT  EQU  7
UART_C4_RDMAS_MASK   EQU  0x20
UART_C4_RDMAS_SHIFT  EQU  5
;---------------------------------------------------------------
;UARTx_S1
;7:TDRE=transmit data register empty flag
;6:TC=transmission complete flag
;5:RDRF=receive data register full flag
;4:IDLE=idle line flag
;3:OR=receiver overrun flag
;2:NF=noise flag
;1:FE=framing error flag
;0:PF=parity error flag
UART_S1_TDRE_MASK   EQU 0x80
UART_S1_TDRE_SHIFT  EQU 7
UART_S1_TC_MASK     EQU 0x40
UART_S1_TC_SHIFT    EQU 6
UART_S1_RDRF_MASK   EQU 0x20
UART_S1_RDRF_SHIFT  EQU 5
UART_S1_IDLE_MASK   EQU 0x10
UART_S1_IDLE_SHIFT  EQU 4
UART_S1_OR_MASK     EQU 0x08
UART_S1_OR_SHIFT    EQU 3
UART_S1_NF_MASK     EQU 0x04
UART_S1_NF_SHIFT    EQU 2
UART_S1_FE_MASK     EQU 0x02
UART_S1_FE_SHIFT    EQU 1
UART_S1_PF_MASK     EQU 0x01
UART_S1_PF_SHIFT    EQU 0
;---------------------------------------------------------------
;UARTx_S2
;7:LBKDIF=LIN break detect interrupt flag
;6:RXEDGIF=RxD pin active edge interrupt flag
;5:(reserved);read-only; always 0
;4:RXINV=receive data inversion
;3:RWUID=receive wake-up idle detect
;2:BRK13=break character generation length
;1:LBKDE=LIN break detect enable
;0:RAF=receiver active flag
UART_S2_LBKDIF_MASK   EQU 0x80
UART_S2_LBKDIF_SHIFT  EQU 7
UART_S2_RXEDGIF_MASK  EQU 0x40
UART_S2_RXEDGIF_SHIFT EQU 6
UART_S2_RXINV_MASK    EQU 0x10
UART_S2_RXINV_SHIFT   EQU 4
UART_S2_RWUID_MASK    EQU 0x08
UART_S2_RWUID_SHIFT   EQU 3
UART_S2_BRK13_MASK    EQU 0x04
UART_S2_BRK13_SHIFT   EQU 2
UART_S2_LBKDE_MASK    EQU 0x02
UART_S2_LBKDE_SHIFT   EQU 1
UART_S2_RAF_MASK      EQU 0x01
UART_S2_RAF_SHIFT     EQU 0
            END
