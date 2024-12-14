%macro PUSH_REGISTERS 0
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es
%endmacro

%macro POP_REGISTERS 0
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
%endmacro

