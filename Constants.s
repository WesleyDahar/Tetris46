;------------------------------
; Constants
;------------------------------

DRAW_NEXT
	DCB "\x1b[33m\x1b[4;54H[][][]\x1b[5;56H[]\0####"
	DCB "\x1b[32m\x1b[4;54H[][][]\x1b[5;58H[]\0####"
	DCB "\x1b[32m\x1b[4;54H[][]\x1b[5;56H[][]\0####"
	DCB "\x1b[33m\x1b[4;55H[][]\x1b[5;55H[][]\0####"
	DCB "\x1b[36m\x1b[4;56H[][]\x1b[5;54H[][]\0####"
	DCB "\x1b[36m\x1b[4;54H[][][]\x1b[5;54H[]\0####"
	DCB "\x1b[31m\x1b[5;53H[][][][]\0###########"

BLOCK
	DCD 0xFE000218
	DCD 0xE8FE0018
	DCD 0xE8FE0002
	DCD 0xE8000218
	DCD 0xFE00021A
	DCD 0xE8001618
	DCD 0xE6FE0002
	DCD 0xE8EA0018
	DCD 0xFE00181A
	DCD 0xE8FE0016
	DCD 0xFE00181A
	DCD 0xE8FE0016
	DCD 0xFE001618
	DCD 0xFE001618
	DCD 0xFE001618
	DCD 0xFE001618
	DCD 0x00021618
	DCD 0xE6FE0018
	DCD 0x00021618
	DCD 0xE6FE0018
	DCD 0xFE000216
	DCD 0xE6E80018
	DCD 0xEAFE0002
	DCD 0xE800181A
	DCD 0xFCFE0002
	DCD 0xD0E80018
	DCD 0xFCFE0002
	DCD 0xD0E80018

VARIABLE_BASE
STS	DCB "\x1b[05;14H"
	DCD 3
	DCB "\x1b[08;14H"
	DCD 3
	DCB "\x1b[11;14H"
	DCD 3
	DCB "\x1b[14;14H"
	DCD 3
	DCB "\x1b[17;14H"
	DCD 3
	DCB "\x1b[20;14H"
	DCD 3
	DCB "\x1b[23;14H"
	DCD 3
VLN DCB "\x1b[02;38H"
	DCD 3
VLV DCB "\x1b[22;59H"
	DCD 2
VSC DCB "\x1b[16;55H"
	DCD 6
VTP DCB "\x1b[13;55H"
	DCD 0x271006

COLOR DCB "3223661"
CLEAR_NEXT DCB "\x1b[4;53H        \x1b[5;53H        \0"
CLEAR_LINE DCB "                    \x1b[20D\0"
CURSOR_SET DCB "\x1b[24;25H\0"
CURSOR_UP DCB "\x1b[A\0"
CURSOR_DOWN DCB "\x1b[B\0"

GAMEOVER
	DCB "\x1b[9;25H\x1b[37m                    "
	DCB "\x1b[10;25H        GAME        "
	DCB "\x1b[11;25H        OVER        "
	DCB "\x1b[12;25H                    \0"

BOARD
	DCB "\x1b[0;0H\x1b[0;37m@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@\n\r"
	DCB "@@  STATISTICS    @@  @@    LINES   0000    @@  @@    NEXT    @@\n\r"
	DCB "@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@  @@            @@\n\r"
	DCB "@@                @@  @@@@@@@@@@@@@@@@@@@@@@@@  @@            @@\n\r"
	DCB "@@\x1b[33m  [][][]   \x1b[37m000  @@  @@                    @@  @@            @@\n\r"
	DCB "@@\x1b[33m    []     \x1b[37m     @@  @@                    @@  @@            @@\n\r"
	DCB "@@                @@  @@                    @@  @@            @@\n\r"
	DCB "@@\x1b[32m  [][][]   \x1b[37m000  @@  @@                    @@  @@@@@@@@@@@@@@@@\n\r"
	DCB "@@\x1b[32m      []   \x1b[37m     @@  @@                    @@                  \n\r"
	DCB "@@                @@  @@                    @@  @@@@@@@@@@@@@@@@\n\r"
	DCB "@@\x1b[32m  [][]     \x1b[37m000  @@  @@                    @@  @@            @@\n\r"
	DCB "@@\x1b[32m    [][]   \x1b[37m     @@  @@                    @@  @@  TOP       @@\n\r"
	DCB "@@                @@  @@                    @@  @@    000000  @@\n\r"
	DCB "@@\x1b[33m   [][]    \x1b[37m000  @@  @@                    @@  @@            @@\n\r"
	DCB "@@\x1b[33m   [][]    \x1b[37m     @@  @@                    @@  @@  SCORE     @@\n\r"
	DCB "@@                @@  @@                    @@  @@    000000  @@\n\r"
	DCB "@@\x1b[36m    [][]   \x1b[37m000  @@  @@                    @@  @@            @@\n\r"
	DCB "@@\x1b[36m  [][]     \x1b[37m     @@  @@                    @@  @@@@@@@@@@@@@@@@\n\r"
	DCB "@@                @@  @@                    @@                  \n\r"
	DCB "@@\x1b[36m  [][][]   \x1b[37m000  @@  @@                    @@  @@@@@@@@@@@@@@@@\n\r"
	DCB "@@\x1b[36m  []       \x1b[37m     @@  @@                    @@  @@  LEVEL     @@\n\r"
	DCB "@@                @@  @@                    @@  @@        00  @@\n\r"
	DCB "@@\x1b[31m [][][][]  \x1b[37m000  @@  @@                    @@  @@@@@@@@@@@@@@@@\n\r"
	DCB "@@                @@  @@                    @@                  \n\r"
	DCB "@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@"

	ALIGN
	END
