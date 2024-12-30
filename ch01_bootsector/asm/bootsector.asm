[org 0x7c00]            ; Tell NASM where this code will be loaded
[bits 16]               ; We're working in 16-bit real mode

%include "common_bootsector.asm"

start:
    INIT_SEGMENTS
    BIOS_CLEAR_SCREEN

    PRINT_STRING_COLOR 0, 0, [hello_msg_color], hello_msg
    PRINT_STRING_COLOR 4, 0, [turn_on_msg_color], turn_on_msg

.main_loop:
; delay a while
.delay_step:
    mov cx, 0x01FF
.delay:
    nop
    loop .delay

    ; delay_through_step dw 0x00
    mov ax, [delay_through_step]
    inc ax
    cmp ax, [delay_through_max]
    jb .no_wrap_delay_step
    xor ax, ax
.no_wrap_delay_step:
    mov [delay_through_step], ax
    test ax, ax
    jnz .delay_step
 
 ; Check for spacebar press, return al is paused
    mov ah, 0x01        ; BIOS check for keystroke
    int 0x16            ; Keyboard services
    jz .no_space_key          ; Jump if no key pressed
    
    mov ah, 0x00        ; BIOS read keystroke
    int 0x16            ; Keyboard services
    
    cmp al, ' '         ; Compare with space
    jne .no_space_key         ; If not space, continue
    
    ; Toggle pause state
    mov al, [is_paused]
    xor al, 1           ; Toggle between 0 and 1
    mov [is_paused], al
    jmp .check_result

.no_space_key:
    mov al, [is_paused]

; Check pause state
.check_result:
    test al, al
    jnz .paused_action

; otherwise clear paused display
    call clear_paused;

;     ; Update color
;     mov al, [adv_msg_color]
;     inc al
;     cmp al, 0x10
;     jb .no_background
;     xor al, al
; .no_background:
;     mov [adv_msg_color], al
    CALL_PRINT_ADV_SCROLL
    CALL_BIOS_QUERY_AND_PRINT_TIME
    jmp .main_loop

.paused_action:
    call flash_paused_display
    jmp .main_loop

FN_FLASH_PAUSED_DISPLAY
FN_PRINT_ADV_SCROLL
FN_BCD_TO_ASCII
FN_BIOS_PRINT_STRING_P_MSG
FN_BIOS_QUERY_AND_PRINT_TIME

; Data
hello_msg db 'Hello, bootsector by ASM in busy loop!', 0
hello_msg_row db 0
hello_msg_col db 0
hello_msg_color db 0x0E

DATA_TIME_STR
DATA_SAFE_POWER_OFF
DATA_ADV
DATA_PAUSED

delay_through_step dw 0x00
delay_through_max dw 0xFFFF

; Pad to 510 bytes and add boot signature
times 510-($-$$) db 0
dw 0xAA55
