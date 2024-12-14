[BITS 16]
[ORG 0x7C00]

%include "../../ch01_bootsector/nasm/common.asm"
%include "common.asm"

start:
    INIT_SEGMENTS
    CLEAR_SCREEN

    PRINT_STRING_COLOR [hello_msg_row], [hello_msg_col], [hello_msg_color], hello_msg
    PRINT_STRING_COLOR [turn_on_msg_row], [turn_on_msg_col], [turn_on_msg_color], turn_on_msg

    cli                     ; Disable interrupts

    ; Set up the stack
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Remap PIC
    mov al, 0x11           ; Initialize command
    out 0x20, al           ; Send to PIC1
    mov al, 0x20           ; New offset for IRQ0 (32)
    out 0x21, al
    mov al, 0x04           ; Tell PIC1 there is a slave at IRQ2
    out 0x21, al
    mov al, 0x01           ; 8086 mode
    out 0x21, al

    ; Set up the timer interrupt (IRQ0)
    mov al, 0x36           ; Channel 0, square wave mode
    out 0x43, al
    mov ax, 0x4E20         ; 1 second interval (0x4E20 = 20000 in decimal)
    out 0x40, al
    mov al, ah
    out 0x40, al

    ; Set up ISR for IRQ0
    xor ax, ax
    mov es, ax
    mov word [es:0x20*4], isr_timer    ; Offset
    mov word [es:0x20*4+2], 0          ; Segment

    ; Enable only timer interrupt
    mov al, 0xFE           ; Enable IRQ0 only
    out 0x21, al

    ; Enable interrupts
    sti

    ; Infinite loop
loop:
    hlt                    ; Halt until interrupt
    jmp loop

; Timer Interrupt Service Routine (ISR)
isr_timer:
    PUSH_REGISTERS

    ; Set up data segment
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; Display time
    call print_time

    ; Acknowledge the interrupt
    mov al, 0x20
    out 0x20, al

    POP_REGISTERS
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

hello_msg db 'Hello, timer driving world!', 0
hello_msg_row db 0
hello_msg_col db 0
hello_msg_color db 0x0E

DATA_TIME_STR
DATA_SAFE_POWER_OFF
DATA_ADV
DATA_PAUSED

times 510-($-$$) db 0
dw 0xAA55
