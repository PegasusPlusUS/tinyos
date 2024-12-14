[BITS 16]
[ORG 0x7C00]

%include "../../ch01_bootsector/nasm/common.asm"

start:
    INIT_SEGMENTS
    CLEAR_SCREEN

    PRINT_STRING_COLOR 0, 0, [hello_msg_color], hello_msg

    cli                     ; Disable interrupts

    ; Set up the stack
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Set up the timer interrupt (IRQ0)
    mov al, 0x36
    out 0x43, al
    mov ax, 0x4E20          ; 1 second interval (0x4E20 = 20000 in decimal)
    out 0x40, al
    mov al, ah
    out 0x40, al

    ; Set up ISR for IRQ0
    cli
    lidt [idtr]
    sti

    ; Enable interrupts
    sti

    ; Initialize the number to display
    mov word [number], 0

    ; Infinite loop
loop:
    nop
    jmp loop

; Interrupt Descriptor Table (IDT)
idtr:
    dw idt_end - idt - 1    ; Limit
    dd idt                  ; Base

idt:
    dw isr_timer - start    ; Offset low
    dw 0x08                 ; Selector
    db 0                   ; Reserved
    db 0x8E                ; Type and attributes
    dw isr_timer - start    ; Offset high

idt_end:

; Timer Interrupt Service Routine (ISR)
isr_timer:
    pusha

    ; Increment the number
    inc word [number]

    ; Display the number
    call display_number

    ; Acknowledge the interrupt
    mov al, 0x20
    out 0x20, al

    popa
    iret

; Display the number
display_number:
    mov ax, [number]
    call print_number
    ret

; Print the number
print_number:
    ; Convert number to string and print
    mov bx, 10
    xor cx, cx

convert_loop:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz convert_loop

print_loop:
    pop ax
    mov ah, 0x0E
    int 0x10
    loop print_loop

    ret

FN_PRINT_STRING

; Data
hello_msg db "Hello, timer driven world!", 0
hello_msg_color db 0x07
number dw 0

times 510-($-$$) db 0
dw 0xAA55
