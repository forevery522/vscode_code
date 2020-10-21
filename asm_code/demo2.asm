;description
stack SEGMENT USE16
    db 100 dup(?)
stack ENDS

;description
data SEGMENT USE16
    message db 'Hello,World,2020',0dh,0ah,'$'
data ENDS

;description
code SEGMENT USE16
    assume cs:code, ds:data, ss:stack

;description
display PROC
    push ax
    push dx
    mov ah, 9
    mov dx, offset message
    int 21h
    pop dx
    pop ax
    ret 
display ENDP

;description
string PROC
    mov ax, data
    mov dx, ax
    call display
    mov bx, 0
    mov cx, sizeof message
search: mov al, message[bx]
        cmp al, "a"
        jb pass
        cmp al, "z"
        ja pass
        and byte ptr message[bx], 11011111b
pass:   inc bx
        loop search
        call display
        mov ah, 4ch
        int 21h
string ENDP
code ENDS
end string
