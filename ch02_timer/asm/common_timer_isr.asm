%include "common.asm"

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
    mov ax, 0x04AF        ; Load value for 1000 Hz (1193 in decimal)
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

%macro DATA_TIME_STR_HR 0
time_str db '00:'
time_str_min db '00:'
time_str_sec db '00:', 
time_str_micro_sec db '000', 0
time_micro_sec dw 0 ; 0..=999
time_str_row db 2
time_str_col db 0
time_str_color db 0x0F
%endmacro

%macro CALL_INC_MICRO_SEC_AND_TO_ASCII 0
    call increase_ms_2_ascii
%endmacro

%macro FN_INC_MICRO_SEC_AND_TO_ASCII 0
increase_ms_2_ascii:
    mov ax, [time_micro_sec]
    inc ax
    cmp ax, 1000
    jl .no_overflow
    mov ax, 0
.no_overflow:
    mov [time_micro_sec], ax

    ; Convert ax to ASCII and store in time_str_micro_sec
    mov bx, 10              ; Divisor for decimal conversion
    mov cx, 3               ; Counter for 3 digits
    lea di, [time_str_micro_sec + 2] ; Point to the last position for right alignment
    ;mov byte [time_str_micro_sec], 0 ; Null-terminate the string

.convert_loop:
    xor dx, dx              ; Clear dx before division
    div bx                   ; Divide ax by 10
    add dl, '0'             ; Convert remainder to ASCII
    mov [di], dl            ; Store ASCII character
    dec di                  ; Move to the previous position
    loop .convert_loop      ; Repeat for 3 digits

    ; Fill remaining positions with spaces for right alignment
    ;mov byte [time_str_micro_sec], '0' ; Fill first position with space

    ret
%endmacro