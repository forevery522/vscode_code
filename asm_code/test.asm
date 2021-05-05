IO8259_0 EQU 0240H
IO8259_1 EQU 0242H

T08253 EQU 260H
T18253 EQU 262H
T28253 EQU 264H
TD8253 EQU 266H

P8255A EQU 270H
P8255B EQU 272H
P8255C EQU 274H
P8255CON EQU 276H

ADD244 EQU 230H

_STACK		SEGMENT	STACK	
		DW	100 DUP(?)	
_STACK		ENDS		
			
_DATA		SEGMENT	WORD PUBLIC 'DATA'
TIME_DATA   DB  3FH ;0
            DB  06H ;1
            DB  5BH ;2
            DB  4FH ;3
            DB  66H ;4
            DB  6DH ;5
            DB  7DH ;6
            DB  07H ;7
            DB  7FH ;8
            DB  6FH ;9

LED_BUFF    DB  4 DUP(?)   ;显示数据缓冲
HOUR        DB  0
MIN         DB  0
SEC         DB  0
US          DB  12
CON_DP      DB  0    ;小数点标志位
CON_DIS     DB  01H    ;时差标志位
function    DW  0
inputHour   DW  0

_DATA		ENDS		
			
CODE	SEGMENT		
START	PROC	NEAR	
	ASSUME	CS:CODE, DS:_DATA, SS:_STACK
	MOV	AX,_DATA	
        MOV     DS,AX
        MOV	ES,AX
        MOV     HOUR, 0
        MOV     MIN, 0
        MOV     SEC, 0
       	MOV     CON_DP, 0
       		
INIT:	
       	MOV     DX, P8255CON   ;8255初始化
	MOV     AL,88H	
	OUT     DX,AL
	MOV     DX,P8255B	
	MOV     AL,00H
	OUT     DX,AL
        ;CLI
        NOP
        CALL	Init8259
        CALL	WriIntver
        MOV     AX, _DATA
        MOV     DS, AX
        STI
        	
        CALL    DELAY_1S

;***********************************************
;主程序入口
;***********************************************
MAIN:   ;CLI
	CALL    KEYI
	;STI
        CMP     AL, 0AH
        JE      FUN1
        CMP     AL, 0BH
        JE      FUN2
        CMP     AL, 0CH
        JE      FUN3
        CMP     AL, 0DH
        JE      FUN4
        CMP     AL, 0EH
        JE      FUN5

FUN1:   CALL    _TIME
        JMP     ENDING
FUN2:   CALL    SPEAK
        JMP     ENDING
FUN3:   CALL    TIME_DIS
        JMP     ENDING
FUN4:   CALL    SEC_CLK
        JMP     ENDING
FUN5:   

        JMP     ENDING
ENDING:        
        JMP     MAIN


;***********************************************
;数字时钟功能
;***********************************************
_TIME   PROC    NEAR
START1:	
        ;CALL TIME_DIS

HOUR_D:        
        MOV     AL, HOUR
        MOV     AH, 0
        MOV     BL, 10
        DIV     BL

        MOV     CH, AH                ;时钟十位数
        MOV     AH, 0
        MOV     BX, OFFSET TIME_DATA
        ADD     BX, AX
        MOV     AL, [BX]
        MOV     LED_BUFF, AL

        MOV     BX, OFFSET TIME_DATA  ;时钟个位数
        MOV     AL, CH
        MOV     AH, 0
        ADD     BX, AX
        MOV     AL, [BX]
        MOV     LED_BUFF+1, AL

MIN_D:        
        MOV     AL, MIN
        MOV     AH, 0
        MOV     BL, 10
        DIV     BL

        MOV     CH, AH                ;分钟十位数
        MOV     AH, 0
        MOV     BX, OFFSET TIME_DATA
        ADD     BX, AX
        MOV     AL, [BX]
        MOV     LED_BUFF+2, AL

        MOV     BX, OFFSET TIME_DATA  ;分钟个位数
        MOV     AL, CH
        MOV     AH, 0
        ADD     BX, AX
        MOV     AL, [BX]
        MOV     LED_BUFF+3, AL

;小数点屏闪效果（一亮一灭为一秒）        
LA:     MOV     AL, CON_DP
        CMP     AL, 30
        JB      DIS2
DIS1:   CALL    _DISPLAY    ;显示数据（不加小数点）
        JMP     UP
DIS2:   CALL    DISPLAY_M   ;显示数据（加点）

UP:    
        INC     CON_DP
        MOV     AL, CON_DP
        CMP     AL, 60
        JE      CLEAN
        JMP     RE
CLEAN:  MOV     CON_DP, 0
        
RE:	NOP
	;JMP	START1
        RET
_TIME   ENDP


Init8259        PROC	NEAR            ;8259初始化
	MOV	DX,IO8259_0
	MOV	AL,13H
	OUT	DX,AL
	MOV	DX,IO8259_1
	MOV	AL,08H
	OUT	DX,AL
	MOV	AL,09H
	OUT	DX,AL
	MOV	AL, 0FEH
	OUT	DX, AL
	RET
Init8259	ENDP

WriIntver	PROC	NEAR            ;中断向量表，中断程序地址写入

	PUSH	DS
	PUSH	AX
	MOV	AX,0
	MOV	DS,AX
	MOV	SI,0020H
	MOV	AX,OFFSET INT_0
	MOV	[SI],AX
	MOV	AX,SEG INT_0
	MOV	[SI+2],AX
	POP	AX
	POP	DS
		RET
WriIntver	ENDP

DELAY_1S        PROC    NEAR
	PUSH	DX
	PUSH	AX
	MOV     DX,TD8253
	MOV     AL,35H
        OUT     DX,AL			;计数器T0设置在模式2状态,BCD码计数
	MOV     DX,TD8253
        MOV     AL,77H
	OUT     DX,AL			;计数器T1为模式2状态，输出方波,BCD码计数
		
	MOV     DX,T08253
	MOV     AL,00H			;先低后高写，此处写低位
	OUT     DX,AL
	MOV     AL,10H			;此处写高位
	OUT     DX,AL			;CLK0/1000
        MOV     DX,T18253
	MOV     AL,00H
        OUT     DX,AL
	MOV     AL,10H
        OUT     DX,AL			;CLK1/1000
        POP	AX
        POP	DX
        RET
DELAY_1S        ENDP

INT_0:	                         ;中断程序，刷新时钟数字
       PUSH     DX 
       PUSH     AX
       INC      SEC 
       MOV      AL, SEC
       CMP      AL, 60
       JNE      EXIT
       MOV      SEC, 0
       INC      MIN
       MOV      AL, MIN
       CMP      AL, 60
       JNE      EXIT
       MOV      MIN, 0
       INC      HOUR
       MOV      AL, HOUR
       CMP      AL, 24
       JNE      EXIT
       MOV      HOUR, 0

;中断结束        
EXIT: 
        MOV     DX, 0240H    
        MOV     AL, 20H
        OUT     DX, AL
        POP     AX
        POP     DX
        IRET

_DISPLAY        PROC    NEAR  ;带小数点的显示

        MOV     BX, OFFSET LED_BUFF
        MOV     AH, 00001000B  ;初始从最右边开始
        MOV     CX, 4  ;四位数码管

DISPLAY1: 
        MOV     DX, P8255A   ;PA口初始化清除
        MOV     AL, 0
        OUT     DX, AL

        MOV     DX, P8255A
        MOV     AL, AH
        OUT     DX, AL
        MOV     AL, [BX]

        CMP     AH, 04H  ;3号数码管需要增减小数点
        JE      DP_SHOW
        JMP     SHOW

DP_SHOW:        CALL DISPLAY_DP     ;显示小数点

SHOW:   MOV     DX, P8255B
        OUT     DX, AL
        CALL    DELAY1
        SHR     AH, 1  ;数码管选择右移
        INC     BX  ;缓冲区遍历
        DEC     CX
        JNZ     DISPLAY1  ;数码管刷新未完成则继续循环
        MOV     DX, P8255A
        MOV     AL, 0
        OUT     DX, AL

        RET

_DISPLAY        ENDP

DISPLAY_DP      PROC    NEAR   ;加小数点
        OR      AL, 80H
        RET
DISPLAY_DP      ENDP


DISPLAY_M       PROC    NEAR

        MOV     BX, OFFSET LED_BUFF
        MOV     AH, 00001000B
        MOV     CX, 4

DISPLAY2: 
        MOV     DX, P8255A
        MOV     AL, 0
        OUT     DX, AL

        MOV     DX, P8255A
        MOV     AL, AH
        OUT     DX, AL
        MOV     AL, [BX]

        MOV     DX, P8255B
        OUT     DX, AL
        CALL    DELAY1
        SHR     AH, 1
        INC     BX
        DEC     CX
        JNZ     DISPLAY2
        MOV     DX, P8255A
        MOV     AL, 0
        OUT     DX, AL

        RET

DISPLAY_M       ENDP

DELAY1  PROC    NEAR    ;延时程序，使数字稳定显示在数码管上
        PUSH    AX
        PUSH    CX
        MOV     AL, 0
        MOV     CX, AX
        LOOP    $
        POP     CX
        POP     AX
        RET
DELAY1  ENDP

;***********************************************
;键盘扫描功能
;***********************************************
KEYI    PROC    NEAR 
 	PUSH    BX 
 	PUSH    DX 
 	;CLI
LK: 	CALL    _TIME
	CALL    AllKey ;调用判有无闭合键子程序 
 	JNZ     LK1 
 	JMP     LK 
LK1: 	 
 	CALL    AllKey ;调用判有无闭合键子程序 
 	 
 	JNZ     LK2  
 	JMP     LK 
LK2: 	MOV     BL,0FEH ;R2 
 	MOV     BH,0 ;R4 
LK4: 	MOV     DX,ADD244 
 	MOV     AL,BL 
 	OUT     DX,AL 
 	INC     DX 
 	IN      AL,DX 
 	TEST    AL,01H 
 	JNZ     LONE 
 	XOR     AL,AL ;0 行有键闭合 
 	JMP     LKP 
LONE: 	TEST    AL,02H 
 	JNZ     NEXT 
 	MOV     AL,08H ;1 行有键闭合 
LKP: 	ADD     BH,AL 
LK3: 	CALL    _TIME
 	CALL    AllKey 
 	JNZ     LK3 
 	MOV     AL,BH ;键号->AL 
 	POP     DX 
 	POP     BX 
 	RET 
NEXT: 	INC     BH ;列计数器加 1 
 	TEST    BL,80H 
 	JZ      KND ;判是否已扫到最后一列 
 	ROL     BL,01H        
 	JMP     LK4 
KND: 	JMP     LK 
KEYI    ENDP 

AllKey  PROC    NEAR 
 	MOV     DX,ADD244 
 	XOR     AL,AL 
 	OUT     DX,AL ;全"0"->扫描口 
 	INC     DX 
 	IN      AL,DX ;读键`状态 
 	NOT     AL 
 	AND     AL,03H ;取低二位 
 	RET 
AllKey  ENDP 


;***********************************************
;时区功能(待修改)
;***********************************************
TIME_DIS PROC   NEAR
        PUSH    DX
        PUSH    AX
        NOT     CON_DIS
        AND     CON_DIS, 01H
        CALL    TIME_TRANS
BACK:
        POP     AX
        POP     DX
        RET
TIME_DIS ENDP


TIME_TRANS PROC NEAR
        PUSH    AX
        MOV     AL, HOUR
        CMP     AL, 12
        JB      ADDING
SUBBING:
        SUB     HOUR, 12
        JMP     BACK1        
ADDING: 
        ADD     HOUR, 12
BACK1:  
        POP     AX
        RET
TIME_TRANS ENDP

;***********************************************
;语音功能
;***********************************************
SPEAK PROC NEAR

        RET
SPEAK ENDP

;***********************************************
;秒表计时功能
;***********************************************
SEC_CLK PROC NEAR

        RET
SEC_CLK ENDP

;***********************************************
;闹钟功能
;***********************************************

START	ENDP		
CODE	ENDS		
	END	START