P8255A EQU 270H
P8255B EQU 272H
P8255C EQU 274H
P8255CON EQU 276H

_STACK	SEGMENT	STACK	
		DW 100 DUP(?)	
_STACK	ENDS		
			
_DATA	SEGMENT

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

HOUR        DB 0
MIN         DB 0
SEC         DB 0

CON_DP      DB 0    ;小数点标志

_DATA	ENDS		
			
CODE	SEGMENT PUBLIC 'CODE'	    	
        ASSUME	CS:CODE, DS:_DATA, SS:_STACK

MAIN:		
	MOV AX,_DATA	   
	MOV DS,AX
    MOV HOUR, 0
    MOV MIN, 0
    MOV SEC, 0
    MOV CON_DP, 0

INIT:	
    MOV DX, P8255CON   ;8255初始化
	MOV AL,80H	
	OUT DX,AL
	MOV DX,P8255B	
	MOV AL,0FFH
	OUT DX,AL

LP_DIS:

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

;··········待更改代码区域开始············
LA:     MOV AL, CON_DP
        CMP AL, 10
        JB  DIS2
DIS1:   CALL _DISPLAY    ;显示数据（不加小数点）
        JMP UP
DIS2:   CALL DISPLAY_M   ;显示数据（加点）

UP:    
; CALL UPDATE   ;更新时分秒数据
        INC CON_DP
        MOV AL, CON_DP
        CMP AL, 20
        JE CLEAN
        JMP RE
CLEAN:  MOV CON_DP, 0
;············待更改区域结束···············

RE:     JMP LP_DIS

ENDLESS:
        JMP ENDLESS

_DISPLAY PROC NEAR  ;带小数点的显示

        MOV BX, OFFSET LED_BUFF
        MOV AH, 00001000B  ;初始从最右边开始
        MOV CX, 4  ;四位数码管

DISPLAY1: 
        MOV DX, P8255A   ;PA口初始化清除
        MOV AL, 0
        OUT DX, AL

        MOV DX, P8255A
        MOV AL, AH
        OUT DX, AL
        MOV AL, [BX]

        CMP AH, 04H  ;2号数码管需要增减小数点
        JE DP_SHOW
        JMP SHOW

DP_SHOW: CALL DISPLAY_DP

SHOW:   MOV DX, P8255B
        OUT DX, AL
        CALL DELAY1
        SHR AH, 1  ;数码管选择左移
        INC BX  ;缓冲区遍历
        DEC CX
        JNZ DISPLAY1  ;数码管刷新未完成则继续循环
        MOV DX, P8255A
        MOV AL, 0
        OUT DX, AL

RETURN: RET

_DISPLAY ENDP

DISPLAY_DP PROC NEAR   ;加小数点
        OR AL, 80H
        RET
DISPLAY_DP ENDP

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

RETURN: RET

DISPLAY_M ENDP
;********************
;时钟数字更新子程序
;********************
UPDATE PROC NEAR
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

;中断结束        
EXIT: 
        POP AX
        RET
    
UPDATE ENDP

;********************
;延时子程序
;********************
DELAY1 PROC NEAR
        PUSH AX
        PUSH CX
        MOV AL, 0
        MOV CX, AX
        LOOP $
        POP CX
        POP AX
        RET
DELAY1 ENDP
		
CODE	ENDS		
	END	MAIN