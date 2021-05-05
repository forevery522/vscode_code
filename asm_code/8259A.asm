IO8259_0	EQU	0240H
IO8259_1	EQU	0241H

_STACK		SEGMENT	STACK	
		DW	100 DUP(?)	
_STACK		ENDS		
			
_DATA		SEGMENT	WORD PUBLIC 'DATA'
TIME_DATA   DB 3FH ;0
            DB 06H ;1
            DB 5BH ;2
            DB 4FH ;3
            DB 66H ;4
            DB 6DH ;5
            DB 7DH ;6
            DB 07H ;7
            DB 7FH ;8
            DB 6FH ;9
            ;DB 80H ;dp

LED_BUFF    DB 4 DUP(?)   ;显示数据缓冲

_DATA		ENDS		
			
CODE		SEGMENT		
START		PROC	NEAR	
		ASSUME	CS:CODE, DS:_DATA, SS:_STACK
		MOV	AX,_DATA	
        	MOV DS,AX
        	MOV	ES,AX
        	NOP
        	CALL	Init8259
        	CALL	WriIntver
		STI			;开中断
START1:	
HOUR_D:        
        MOV AL, HOUR
        MOV AH, 0
        MOV BL, 10
        DIV BL

        MOV CH, AH                ;时钟十位数
        MOV AH, 0
        MOV BX, OFFSET TIME_DATA
        ADD BX, AX
        MOV AL, [BX]
        MOV LED_BUFF, AL

        MOV BX, OFFSET TIME_DATA  ;时钟个位数
        MOV AL, CH
        MOV AH, 0
        ADD BX, AX
        MOV AL, [BX]
        MOV LED_BUFF+1, AL

MIN_D:        
        MOV AL, MIN
        MOV AH, 0
        MOV BL, 10
        DIV BL

        MOV CH, AH                ;分钟十位数
        MOV AH, 0
        MOV BX, OFFSET TIME_DATA
        ADD BX, AX
        MOV AL, [BX]
        MOV LED_BUFF+2, AL

        MOV BX, OFFSET TIME_DATA  ;分钟个位数
        MOV AL, CH
        MOV AH, 0
        ADD BX, AX
        MOV AL, [BX]
        MOV LED_BUFF+3, AL
		CALL DISPLAY_M
		JMP	START1

Init8259	PROC	NEAR
		MOV	DX,IO8259_0
		MOV	AL,13H
		OUT	DX,AL
		MOV	DX,IO8259_1
		MOV	AL,80H
		OUT	DX,AL
		MOV	AL,03H
		OUT	DX,AL
		RET
Init8259	ENDP

WriIntver	PROC	NEAR
		PUSH	ES
		MOV	AX,0
		MOV	ES,AX
		MOV	DI,200H
		LEA	AX,INT_0
		STOSW
		MOV	AX,CS
		STOSW
		POP	ES
		RET
WriIntver	ENDP

DISPLAY_M PROC NEAR

        MOV BX, OFFSET LED_BUFF
        MOV AH, 00001000B
        MOV CX, 4

DISPLAY2: 
        MOV DX, P8255A
        MOV AL, 0
        OUT DX, AL

        MOV DX, P8255A
        MOV AL, AH
        OUT DX, AL
        MOV AL, [BX]

        MOV DX, P8255B
        OUT DX, AL
        CALL DELAY1
        SHR AH, 1
        INC BX
        DEC CX
        JNZ DISPLAY2
        MOV DX, P8255A
        MOV AL, 0
        OUT DX, AL

        RET

DISPLAY_M ENDP

INT_0:	
       PUSH DX
       PUSH AX
       INC SEC 
       MOV AL, SEC
       CMP AL, 60
       JNE EXIT
       MOV SEC, 0
       INC MIN
       MOV AL, MIN
       CMP AL, 60
       JNE EXIT
       MOV MIN, 0
       INC HOUR
       MOV AL, HOUR
       CMP AL, 24
       JNE EXIT
       MOV HOUR, 0
		MOV	DX,IO8259_0
		MOV	AL,20H
		OUT	DX,AL
		POP	AX
		POP	DX
		IRET


		
START		ENDP		
CODE		ENDS		
		END	START
