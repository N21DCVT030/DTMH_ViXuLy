
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _START=R4
	.DEF _dem=R6
	.DEF _x=R8
	.DEF _i=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12/23/2023
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include <delay.h>
;
;int START;
;unsigned int dem, x;
;unsigned int i;
;unsigned long ADC_out = 0;
;unsigned long nhietdo, chuc, dvi;
;
;#include <stdio.h>
;//chuong trinh con phat mot ky tu
;void uart_char_send(unsigned char chr){
; 0000 0024 void uart_char_send(unsigned char chr){

	.CSEG
_uart_char_send:
; 0000 0025     while (!(UCSRA & (1<<UDRE))) {}; //cho den khi bit UDRE=1
;	chr -> Y+0
_0x3:
	SBIS 0xB,5
	RJMP _0x3
; 0000 0026         UDR=chr;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0027 }
	RJMP _0x2060001
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 002C {
_ext_int0_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002D     i += 1;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 002E 
; 0000 002F     chuc = (i/10);
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x0
; 0000 0030     dvi = (i%10);
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x1
; 0000 0031 
; 0000 0032     uart_char_send(chuc+0x30);
; 0000 0033     uart_char_send(dvi+0x30);
; 0000 0034     // uart_char_send(10);
; 0000 0035     uart_char_send(13);
; 0000 0036     delay_ms(200);
	CALL SUBOPT_0x2
; 0000 0037 
; 0000 0038 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 003C {
_timer0_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003D //        f = 125000Hz
; 0000 003E //        --> time = 1 / f = 8lan (us)
; 0000 003F //        TCNT0: 6 - 255, duoc 250 xung nhip
; 0000 0040 //        -> Time tran = 250 * 8 = 2000 (us) = 4s
; 0000 0041 //        dem++;
; 0000 0042 //        Neu bien dem tang 500 lan thi se dc 1(s)
; 0000 0043        dem++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0044        TCNT0 = 6;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0045 }
	RJMP _0x4D
;
;
;//Ngat Nhan UART cho mot ky tu
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 004A {
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004B char data;
; 0000 004C data=UDR;
	ST   -Y,R17
;	data -> R17
	IN   R17,12
; 0000 004D //uart_char_send(data);
; 0000 004E     if (data == '0'){ START = 0x00; }
	CPI  R17,48
	BRNE _0x6
	CLR  R4
	CLR  R5
; 0000 004F     if (data == '9'){ START = 0xFF; }
_0x6:
	CPI  R17,57
	BRNE _0x7
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R4,R30
; 0000 0050 
; 0000 0051     if (START == 0xFF)
_0x7:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R4
	CPC  R31,R5
	BREQ PC+3
	JMP _0x8
; 0000 0052     {
; 0000 0053         //DIEU KHIEN 8 LED DON
; 0000 0054         if (data == '1'){ PORTC.7 = 0xFF; }
	CPI  R17,49
	BRNE _0x9
	SBI  0x15,7
; 0000 0055         if (data == 'q'){ PORTC.7 = 0x00; }
_0x9:
	CPI  R17,113
	BRNE _0xC
	CBI  0x15,7
; 0000 0056         if (data == '2'){ PORTC.6 = 0xFF; }
_0xC:
	CPI  R17,50
	BRNE _0xF
	SBI  0x15,6
; 0000 0057         if (data == 'w'){ PORTC.6 = 0x00; }
_0xF:
	CPI  R17,119
	BRNE _0x12
	CBI  0x15,6
; 0000 0058         if (data == '3'){ PORTC.5 = 0xFF; }
_0x12:
	CPI  R17,51
	BRNE _0x15
	SBI  0x15,5
; 0000 0059         if (data == 'e'){ PORTC.5 = 0x00; }
_0x15:
	CPI  R17,101
	BRNE _0x18
	CBI  0x15,5
; 0000 005A         if (data == '4'){ PORTC.4 = 0xFF; }
_0x18:
	CPI  R17,52
	BRNE _0x1B
	SBI  0x15,4
; 0000 005B         if (data == 'r'){ PORTC.4 = 0x00; }
_0x1B:
	CPI  R17,114
	BRNE _0x1E
	CBI  0x15,4
; 0000 005C         if (data == '5'){ PORTC.3 = 0xFF; }
_0x1E:
	CPI  R17,53
	BRNE _0x21
	SBI  0x15,3
; 0000 005D         if (data == 't'){ PORTC.3 = 0x00; }
_0x21:
	CPI  R17,116
	BRNE _0x24
	CBI  0x15,3
; 0000 005E         if (data == '6'){ PORTC.2 = 0xFF; }
_0x24:
	CPI  R17,54
	BRNE _0x27
	SBI  0x15,2
; 0000 005F         if (data == 'y'){ PORTC.2 = 0x00; }
_0x27:
	CPI  R17,121
	BRNE _0x2A
	CBI  0x15,2
; 0000 0060         if (data == '7'){ PORTC.1 = 0xFF; }
_0x2A:
	CPI  R17,55
	BRNE _0x2D
	SBI  0x15,1
; 0000 0061         if (data == 'u'){ PORTC.1 = 0x00; }
_0x2D:
	CPI  R17,117
	BRNE _0x30
	CBI  0x15,1
; 0000 0062         if (data == '8'){ PORTC.0 = 0xFF; }
_0x30:
	CPI  R17,56
	BRNE _0x33
	SBI  0x15,0
; 0000 0063         if (data == 'i'){ PORTC.0 = 0x00; }
_0x33:
	CPI  R17,105
	BRNE _0x36
	CBI  0x15,0
; 0000 0064 
; 0000 0065 
; 0000 0066         //DIEU KHIEN LED RUN
; 0000 0067         if (data == 'z' )
_0x36:
	CPI  R17,122
	BRNE _0x39
; 0000 0068         {
; 0000 0069            x = 250;  //0.5s
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	MOVW R8,R30
; 0000 006A         }
; 0000 006B 
; 0000 006C         if (data == 'x' )
_0x39:
	CPI  R17,120
	BRNE _0x3A
; 0000 006D         {
; 0000 006E            x = 500;  //1s
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	MOVW R8,R30
; 0000 006F         }
; 0000 0070          if (data == 'c' )
_0x3A:
	CPI  R17,99
	BRNE _0x3B
; 0000 0071         {
; 0000 0072            x = 750;  //1.5s
	LDI  R30,LOW(750)
	LDI  R31,HIGH(750)
	MOVW R8,R30
; 0000 0073         }
; 0000 0074 
; 0000 0075         if (data == 'v' )
_0x3B:
	CPI  R17,118
	BRNE _0x3C
; 0000 0076         {
; 0000 0077            x = 1000; //2s
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	MOVW R8,R30
; 0000 0078         }
; 0000 0079          if (data == 'b' )
_0x3C:
	CPI  R17,98
	BRNE _0x3D
; 0000 007A         {
; 0000 007B            x = 1250; //2.5s
	LDI  R30,LOW(1250)
	LDI  R31,HIGH(1250)
	MOVW R8,R30
; 0000 007C         }
; 0000 007D 
; 0000 007E         if (data == 'n' )
_0x3D:
	CPI  R17,110
	BRNE _0x3E
; 0000 007F         {
; 0000 0080            x = 1500;  //3s
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	MOVW R8,R30
; 0000 0081         }
; 0000 0082             if (data == 'm' )
_0x3E:
	CPI  R17,109
	BRNE _0x3F
; 0000 0083         {
; 0000 0084            x = 1750;  //3.5s
	LDI  R30,LOW(1750)
	LDI  R31,HIGH(1750)
	MOVW R8,R30
; 0000 0085         }
; 0000 0086 
; 0000 0087         if (data == 'j' )
_0x3F:
	CPI  R17,106
	BRNE _0x40
; 0000 0088         {
; 0000 0089            x = 2000;  //4s
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	MOVW R8,R30
; 0000 008A         }
; 0000 008B          if (data == 'k' )
_0x40:
	CPI  R17,107
	BRNE _0x41
; 0000 008C         {
; 0000 008D            x = 2250;  //4.5s
	LDI  R30,LOW(2250)
	LDI  R31,HIGH(2250)
	MOVW R8,R30
; 0000 008E         }
; 0000 008F 
; 0000 0090         if (data == 'l' )
_0x41:
	CPI  R17,108
	BRNE _0x42
; 0000 0091         {
; 0000 0092            x = 2500;  //5s
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	MOVW R8,R30
; 0000 0093         }
; 0000 0094 
; 0000 0095     }
_0x42:
; 0000 0096 
; 0000 0097 }
_0x8:
	LD   R17,Y+
_0x4D:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 009F {
_read_adc:
; 0000 00A0 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 00A1 // Delay needed for the stabilization of the ADC input voltage
; 0000 00A2 delay_us(10);
	__DELAY_USB 27
; 0000 00A3 // Start the AD conversion
; 0000 00A4 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00A5 // Wait for the AD conversion to complete
; 0000 00A6 while ((ADCSRA & 0x10)==0);
_0x43:
	SBIS 0x6,4
	RJMP _0x43
; 0000 00A7 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 00A8 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x2060001:
	ADIW R28,1
	RET
; 0000 00A9 }
;
;
;
;
;void main(void)
; 0000 00AF {
_main:
; 0000 00B0 // Input/Output Ports initialization
; 0000 00B1 // Port A initialization
; 0000 00B2 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00B3 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00B4 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00B5 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00B6 
; 0000 00B7 // Port B initialization
; 0000 00B8 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 00B9 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=1
; 0000 00BA PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
; 0000 00BB DDRB=0x01;
	OUT  0x17,R30
; 0000 00BC 
; 0000 00BD // Port C initialization
; 0000 00BE // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00BF // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00C0 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00C1 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00C2 
; 0000 00C3 // Port D initialization
; 0000 00C4 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C5 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00C6 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00C7 DDRD=0x00;
	OUT  0x11,R30
; 0000 00C8 
; 0000 00C9 // Timer/Counter 0 initialization
; 0000 00CA // Clock source: System Clock
; 0000 00CB // Clock value: 125.000 kHz
; 0000 00CC // Mode: Normal top=0xFF
; 0000 00CD // OC0 output: Disconnected
; 0000 00CE TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 00CF TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00D0 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00D1 
; 0000 00D2 // Timer/Counter 1 initialization
; 0000 00D3 // Clock source: System Clock
; 0000 00D4 // Clock value: Timer1 Stopped
; 0000 00D5 // Mode: Normal top=0xFFFF
; 0000 00D6 // OC1A output: Discon.
; 0000 00D7 // OC1B output: Discon.
; 0000 00D8 // Noise Canceler: Off
; 0000 00D9 // Input Capture on Falling Edge
; 0000 00DA // Timer1 Overflow Interrupt: Off
; 0000 00DB // Input Capture Interrupt: Off
; 0000 00DC // Compare A Match Interrupt: Off
; 0000 00DD // Compare B Match Interrupt: Off
; 0000 00DE TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00DF TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00E0 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00E1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00E2 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00E3 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00E4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00E5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00E6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00E7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00E8 
; 0000 00E9 // Timer/Counter 2 initialization
; 0000 00EA // Clock source: System Clock
; 0000 00EB // Clock value: Timer2 Stopped
; 0000 00EC // Mode: Normal top=0xFF
; 0000 00ED // OC2 output: Disconnected
; 0000 00EE ASSR=0x00;
	OUT  0x22,R30
; 0000 00EF TCCR2=0x00;
	OUT  0x25,R30
; 0000 00F0 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00F1 OCR2=0x00;
	OUT  0x23,R30
; 0000 00F2 
; 0000 00F3 // External Interrupt(s) initialization
; 0000 00F4 // INT0: On
; 0000 00F5 // INT0 Mode: Falling Edge
; 0000 00F6 // INT1: Off
; 0000 00F7 // INT2: Off
; 0000 00F8 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00F9 MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 00FA MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00FB GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00FC 
; 0000 00FD // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00FE TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00FF 
; 0000 0100 // USART initialization
; 0000 0101 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0102 // USART Receiver: On
; 0000 0103 // USART Transmitter: On
; 0000 0104 // USART Mode: Asynchronous
; 0000 0105 // USART Baud Rate: 9600
; 0000 0106 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0107 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0108 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0109 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 010A UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 010B 
; 0000 010C // Analog Comparator initialization
; 0000 010D // Analog Comparator: Off
; 0000 010E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 010F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0110 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0111 
; 0000 0112 // ADC initialization
; 0000 0113 // ADC Clock frequency: 1000.000 kHz
; 0000 0114 // ADC Voltage Reference: AREF pin
; 0000 0115 // ADC Auto Trigger Source: ADC Stopped
; 0000 0116 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 0117 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0118 
; 0000 0119 // SPI initialization
; 0000 011A // SPI disabled
; 0000 011B SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 011C 
; 0000 011D // TWI initialization
; 0000 011E // TWI disabled
; 0000 011F TWCR=0x00;
	OUT  0x36,R30
; 0000 0120 
; 0000 0121 // Global enable interrupts
; 0000 0122 #asm("sei")
	sei
; 0000 0123 
; 0000 0124 while (1)
_0x46:
; 0000 0125       {
; 0000 0126          if(dem >= x)
	__CPWRR 6,7,8,9
	BRLO _0x49
; 0000 0127         {
; 0000 0128             PORTB.0 = ~PORTB.0;
	SBIS 0x18,0
	RJMP _0x4A
	CBI  0x18,0
	RJMP _0x4B
_0x4A:
	SBI  0x18,0
_0x4B:
; 0000 0129             dem = 0;
	CLR  R6
	CLR  R7
; 0000 012A         }
; 0000 012B 
; 0000 012C             // DO NHIET DO
; 0000 012D             ADC_out = read_adc(0);
_0x49:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	CLR  R22
	CLR  R23
	STS  _ADC_out,R30
	STS  _ADC_out+1,R31
	STS  _ADC_out+2,R22
	STS  _ADC_out+3,R23
; 0000 012E             nhietdo = ADC_out*500/1023; //10mV = 1do.
	__GETD2N 0x1F4
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3FF
	CALL __DIVD21U
	STS  _nhietdo,R30
	STS  _nhietdo+1,R31
	STS  _nhietdo+2,R22
	STS  _nhietdo+3,R23
; 0000 012F 
; 0000 0130             chuc = nhietdo/10;
	CALL SUBOPT_0x3
	CALL __DIVD21U
	CALL SUBOPT_0x0
; 0000 0131             dvi = nhietdo%10;
	CALL SUBOPT_0x3
	CALL __MODD21U
	CALL SUBOPT_0x1
; 0000 0132             uart_char_send(chuc+0x30);
; 0000 0133             uart_char_send(dvi+0x30);
; 0000 0134 
; 0000 0135             uart_char_send(13);
; 0000 0136             uart_char_send(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _uart_char_send
; 0000 0137             delay_ms(200);
	CALL SUBOPT_0x2
; 0000 0138 
; 0000 0139       }
	RJMP _0x46
; 0000 013A }
_0x4C:
	RJMP _0x4C

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG
_ADC_out:
	.BYTE 0x4
_nhietdo:
	.BYTE 0x4
_chuc:
	.BYTE 0x4
_dvi:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	STS  _chuc,R30
	STS  _chuc+1,R31
	STS  _chuc+2,R22
	STS  _chuc+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1:
	STS  _dvi,R30
	STS  _dvi+1,R31
	STS  _dvi+2,R22
	STS  _dvi+3,R23
	LDS  R30,_chuc
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _uart_char_send
	LDS  R30,_dvi
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _uart_char_send
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _uart_char_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDS  R26,_nhietdo
	LDS  R27,_nhietdo+1
	LDS  R24,_nhietdo+2
	LDS  R25,_nhietdo+3
	__GETD1N 0xA
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

;END OF CODE MARKER
__END_OF_CODE:
