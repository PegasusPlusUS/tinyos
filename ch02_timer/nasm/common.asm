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

%macro SETUP_TIMER_INTERRUPT 1
    ; Set up the timer interrupt (IRQ0)
    mov al, 0x36           ; Channel 0, square wave mode
    out 0x43, al
    mov ax, 1659h         ; twice per second interval (0x4E20 = 20000 in decimal)
    out 0x40, al
    mov al, ah
    out 0x40, al

    ; Set up ISR for IRQ0
    xor ax, ax
    mov es, ax
    mov word [es:0x20*4], %1    ; Offset
    mov word [es:0x20*4+2], 0          ; Segment
%endmacro

%macro ENABLE_TIMER_INTERRUPT_ONLY 0
    mov al, 0xFE           ; Enable IRQ0 only
    out 0x21, al
%endmacro

%macro DISABLE_TIMER_INTERRUPT 0
    mov al, 0x00           ; Disable IRQ0
    out 0x21, al
%endmacro

%macro BEGIN_ISR_TIMER 1
    %1:
    PUSH_REGISTERS
%endmacro

%macro ACK_ISR 0
    mov al, 0x20
    out 0x20, al
%endmacro

%macro END_ISR_TIMER 0
    POP_REGISTERS
    iret
%endmacro




