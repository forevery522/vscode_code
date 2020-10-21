;description
CODE SEGMENT USE16
    ASSUME CS: CODE
START:  MOV DX, 4000H
        MOV DS, DX
        MOV AX, 55H
        MOV CX, 10H
        MOV SI, 0
L1:     MOV [SI], AX
        INC SI
        LOOP L1
        MOV SI, 0
        MOV CX, 10H
L2:     CMP [SI], AL
        JNZ F
        INC SI
        LOOP L2
        MOV AL, 7EH
        JMP A
F:      MOV AL, 81H
A:      MOV AH, 4CH
        INT 21H
CODE ENDS
END START