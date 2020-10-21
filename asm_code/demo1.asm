.model small
.STACK 1024
.data
message db 8 dup(?), 0dh, 0ah, "$"
.code
main:   mov ax, @data
        mov ds, ax
        mov al, "A"
        mov si, offset message
        call BinToAsc
        mov ah, 9
        mov dx, offset message
        int 21h
        mov ah, 4ch
        int 21h
BinToAsc PROC
    push cx
    push si
    mov cx, 8
L1: shl al, 1
    mov BYTE PTR [si], "0"
    jnc L2
    mov BYTE PTR [si], "1"
L2: inc si
    loop L1
    pop si
    pop cx
    ret
BinToAsc ENDP
    end main