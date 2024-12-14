[org 0x7c00]            ; Tell NASM where this code will be loaded
[bits 16]               ; We're working in 16-bit real mode

%include "common.asm"

start:
    INIT_SEGMENTS
    CLEAR_SCREEN

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

    ; Update color
    mov al, [adv_msg_color]
    inc al
    cmp al, 0x10
    jb .no_background
    xor al, al
.no_background:
    mov [adv_msg_color], al
    call print_adv_scroll
 
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
    mov ah, 0x02        ; Set cursor position
    mov dh, [time_str_row]           ; Row 2 (line 3)
    mov dl, [time_str_col]           ; Column 0
    int 0x10

    ; Print the time in white
    mov bl, [time_str_color]
    mov si, time_str
    call print_string
    jmp .main_loop

.paused_action:
    call flash_paused_display
    jmp .main_loop

; Flash "Paused" display
flash_paused_display:
    mov al, [is_paused_display]
    xor al, 1           ; Toggle between 0 and 1
    mov [is_paused_display], al

    ; Display or clear "Paused" message based on is_paused_display
    test al, al
    jz clear_paused     ; If is_paused_display is 0, clear the message

    ; Display "Paused" message
    SET_PRINT_COLOR [paused_msg_color]
    jmp print_pause_msg_pos

clear_paused:
; Clear the "Paused" message (separate function)
    SET_PRINT_COLOR 0x00        ; Black color (clear text)
print_pause_msg_pos:
    PRINT_STRING_POS [paused_msg_row], [paused_msg_col], paused_msg

print_adv_scroll:
    ; Print adv message with scrolling
    mov ah, 0x02        ; Set cursor position
    mov dh, [adv_msg_row]           ; Row 6 (line 7)
    mov dl, [adv_msg_col]           ; Column 0
    int 0x10
    
    mov bl, [adv_msg_color]
; Print from scroll_pos
    mov si, adv_msg
    add si, [scroll_pos]
    ; save char at scroll_pos
    mov al, byte [si]
    mov [char_at_scroll_pos], al
    call print_string
; Continue print from beginning to scroll_pos
    mov si, adv_msg
    add si, [scroll_pos]
    mov byte [si], 0
    ; print from beginning to scroll_pos
    mov si, adv_msg
    call print_string
    ; restore char at scroll_pos
    mov si, adv_msg
    add si, [scroll_pos]
    mov al, [char_at_scroll_pos]
    mov byte [si], al
;scroll_adv_pos:
    mov ax, [scroll_pos]
    inc ax
    cmp ax, [adv_msg_len]
    jb .not_wrap
    xor ax, ax
.not_wrap:
    mov [scroll_pos], ax
    ret

; Function to convert BCD to ASCII
; Input: AL = BCD number
; Output: AX = Two ASCII digits
bcd_to_ascii:
    push bx
    mov bl, al          ; Save original value
    shr al, 4           ; Get high digit
    add al, '0'         ; Convert to ASCII
    mov ah, bl          ; Get low digit
    and ah, 0x0F        ; Mask off high digit
    add ah, '0'         ; Convert to ASCII
    pop bx
    ret

; Function to print colored string
FN_PRINT_STRING

; Data
hello_msg db 'Hello, world!', 0
hello_msg_row db 0
hello_msg_col db 0
hello_msg_color db 0x0E
time_str db '00:'
time_str_min db '00:'
time_str_sec db '00', 0
time_str_row db 2
time_str_col db 0
time_str_color db 0x0F
turn_on_msg db "It's safe to turn off your box.", 0
turn_on_msg_row db 4
turn_on_msg_col db 0
turn_on_msg_color db 0x0F
adv_msg db 'TinyOS at https://github.com/pegasusplus/tinyos ', 0
adv_msg_len dw $ - adv_msg - 1
;adv_msg_len equ $ - adv_msg - 1
adv_msg_row db 6
adv_msg_col db 0
adv_msg_color db 0x0C
scroll_pos dw 0
char_at_scroll_pos db 0
delay_through_step dw 0x00
delay_through_max dw 0xFFFF
is_paused db 1          ; 0 = running, 1 = paused
is_paused_display db 0
paused_msg db 'Paused', 0
paused_msg_row db 2
paused_msg_col db 37
paused_msg_color db 0x0E
; Pad to 510 bytes and add boot signature
times 510-($-$$) db 0
dw 0xAA55
