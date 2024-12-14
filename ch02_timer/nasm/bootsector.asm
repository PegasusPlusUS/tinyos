[BITS 16]
[ORG 0x7C00]

%include "../../ch01_bootsector/nasm/common.asm"

start:
    INIT_SEGMENTS
    CLEAR_SCREEN

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

    ; Display time
    call print_time

    ; Acknowledge the interrupt
    mov al, 0x20
    out 0x20, al

    popa
    iret

print_time:
; Get time from BIOS RTC
    mov ah, 0x02        ; BIOS get real time clock
    int 0x1A            ; Call BIOS time services
    
    ; Convert BCD to ASCII and store in time_str
    mov al, ch          ; Hours
    call bcd_to_ascii
    mov [time_str], ax
    
    mov al, cl          ; Minutes
    call bcd_to_ascii
    mov [time_str_min], ax
    
    mov al, dh          ; Seconds
    call bcd_to_ascii
    mov [time_str_sec], ax
 
; Position cursor for time display at line 3
    SET_PRINT_POSITION [time_str_row], [time_str_col]
    SET_PRINT_COLOR [time_str_color]
    SET_PRINT_STRING time_str
    call print_string
    ret

FN_BCD_TO_ASCII
FN_PRINT_STRING

; Data
time_str db '00:'
time_str_min db '00:'
time_str_sec db '00', 0
time_str_row db 3
time_str_col db 0
time_str_color db 0x07

times 510-($-$$) db 0
dw 0xAA55
