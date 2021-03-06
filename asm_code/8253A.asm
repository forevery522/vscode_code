T08253 EQU 260H
T18253 EQU 262H
T28253 EQU 264H
TD8253 EQU 266H

_STACK	SEGMENT	STACK	
		DW 100 DUP(?)	
_STACK	ENDS		

CODE	SEGMENT PUBLIC 'CODE'	    	
        ASSUME	CS:CODE, DS:_DATA, SS:_STACK

MAIN:		
	MOV AX,_DATA	   
	MOV DS,AX
        
	MOV     DX,TD8253
	MOV     AL,35H
    OUT     DX,AL			;计数器T0设置在模式2状态,BCD码计数
	MOV     DX,TD8253
    MOV     AL,75H
	OUT     DX,AL			;计数器T1为模式2状态，输出方波,BCD码计数
		
	MOV     DX,T08253
	MOV     AL,0E8H			;先低后高写，此处写低位
	OUT     DX,AL
	MOV     AL,00H			;此处写高位
	OUT     DX,AL			;CLK0/1000
    MOV     DX,T18253
	MOV     AL,0E8H
    OUT     DX,AL
	MOV     AL,00H
    OUT     DX,AL			;CLK1/1000
    JMP	$			;OUT1输出频率为1S的方波

    ENDLESS:
        JMP ENDLESS

CODE	ENDS		
	END	MAIN