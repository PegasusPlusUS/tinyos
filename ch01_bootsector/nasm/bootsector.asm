[org 0x7c00]            ; Tell NASM where this code will be loaded
[bits 16]               ; We're working in 16-bit real mode

start:
    ; Set up segments
    xor ax, ax          ; Clear AX
    mov ds, ax          ; Set DS=0
    mov es, ax          ; Set ES=0
    mov ss, ax          ; Set SS=0
    mov sp, 0x7C00      ; Set stack pointer just below where we're loaded

    ; Clear screen
    mov ax, 0x0003      ; Text mode 80x25, 16 colors
    int 0x10            ; BIOS video interrupt

    call print_hello

.main_loop:
    call check_space_key

    ; Check pause state
    test al, al
    jnz .paused_action

; Update RTC
    call read_rtc
    call print_rtc
    call print_adv_scroll
    
; delay a while and back to .main_loop
; delay some cycle then through
    call delay_through
    cmp al, al
    jz .main_loop

    mov al, [is_paused]
; if paused, toggle paused display and jmp main_loop,
    jnz .paused_action

; otherwise clear paused display, through
    call clear_paused;

    ; Update color
    mov al, [adv_color]
    inc al
    cmp al, 0x10
    jb .no_background
    xor al, al
.no_background:
    mov [adv_color], al
    call print_adv_scroll
    jmp .main_loop

.paused_action:
    call flash_paused_display
    jmp .main_loop

; Toggle "Paused" display
flash_paused_display:
    mov al, [is_paused_display]
    xor al, 1           ; Toggle between 0 and 1
    mov [is_paused_display], al

    ; Display or clear "Paused" message
    mov al, [is_paused_display]
    test al, al
    jz .clear_paused

    ; Display "Paused" message
    mov ah, 0x02        ; Set cursor position
    mov dh, 2           ; Row 2 (line 3)
    mov dl, 37          ; Column 9 (after time)
    int 0x10
    mov si, paused_msg
    mov bl, 0x0E        ; Yellow color
    call print_string_color
    ret
; ? :
.clear_paused:
clear_paused:
    ; Clear "Paused" message
    mov ah, 0x02        ; Set cursor position
    mov dh, 2           ; Row 2 (line 3)
    mov dl, 9           ; Column 9 (after time)
    int 0x10
    mov si, paused_msg
    mov bl, 0x00        ; Black color (clear text)
    call print_string_color
    ret

; Check for spacebar press
check_space_key:
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
    ret
.no_space_key:
    xor al, al
    ret


; Simple delay, and cycle adv_color_freq_max1 * max2 times, then through.
delay_through:
    mov cx, 0x7FFF
.delay:
    nop
    loop .delay

    ; adv_color_freq1 db 0x00
    mov al, [adv_color_freq1]
    inc al
    cmp al, [adv_color_freq_max1]
    jb .no_wrap_freq1
    xor al, al
    jmp .freq2
.no_wrap_freq1:
    mov [adv_color_freq1], al
    ret

.freq2:
    mov [adv_color_freq1], al
    mov al, [adv_color_freq2]
    inc al
    cmp al, [adv_color_freq_max2]
    jb .no_wrap_freq2
    xor al, al
    jmp .through
.no_wrap_freq2:
    mov [adv_color_freq2], al
    xor al, al
    ret

.through:
    mov [adv_color_freq2], al
    mov al, 1
    ret

print_adv_scroll:
    ; Print adv message with scrolling
    mov ah, 0x02        ; Set cursor position
    mov dh, 6           ; Row 6 (line 7)
    mov dl, 0           ; Column 0
    int 0x10
    
    ; Print from scroll_pos
    mov si, adv_msg
    add si, [scroll_pos]
    mov bl, [adv_color]
    ; save char at scroll_pos
    mov al, byte [si]
    mov [char_at_scroll_pos], al
    call print_string_color
    mov si, adv_msg
    add si, [scroll_pos]
    mov byte [si], 0
    ; Continue print from beginning
    mov si, adv_msg
    mov bl, [adv_color]
    call print_string_color
    ; restore char at scroll_pos
    mov si, adv_msg
    add si, [scroll_pos]
    mov al, [char_at_scroll_pos]
    mov byte [si], al
    call scroll_adv_pos
    ret

scroll_adv_pos:
    mov ax, [scroll_pos]
    inc ax
    cmp ax, [adv_msg_len]
    jb .not_wrap
    xor ax, ax
.not_wrap:
    mov [scroll_pos], ax
    ret

; Print hello message at line 1 in yellow
print_hello:
    mov ah, 0x02        ; Set cursor position
    xor bh, bh          ; Page 0
    mov dh, 0           ; Row 0 (line 1)
    mov dl, 0           ; Column 0
    int 0x10
    mov si, hello_msg
    mov bl, 0x0E        ; Yellow color
    call print_string_color
    ret

; Get time from BIOS RTC
read_rtc:
    mov ah, 0x02        ; BIOS get real time clock
    int 0x1A            ; Call BIOS time services
    
    ; Convert BCD to ASCII and store in time_str
    mov al, ch          ; Hours
    call bcd_to_ascii
    mov [time_str], ax
    
    mov al, cl          ; Minutes
    call bcd_to_ascii
    mov [time_str + 3], ax
    
    mov al, dh          ; Seconds
    call bcd_to_ascii
    mov [time_str + 6], ax
    ret

; Position cursor for time display at line 3
print_rtc:
    mov ah, 0x02        ; Set cursor position
    mov dh, 2           ; Row 2 (line 3)
    mov dl, 0           ; Column 0
    int 0x10

    ; Print the time in white
    mov si, time_str
    mov bl, 0x0F        ; Bright white color
    call print_string_color
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
; Input: SI = pointer to string, BL = color attribute
print_string_color:
    push ax
    push bx
    push cx
.loop:
    lodsb               ; Load next character
    test al, al         ; Check for null terminator
    jz .done
    mov ah, 0x09        ; BIOS write character and attribute
    mov cx, 1           ; Print one character
    push bx
    mov bh, 0           ; Page number
    int 0x10
    pop bx
    
    ; Move cursor forward
    mov ah, 0x03        ; Get cursor position
    mov bh, 0
    int 0x10
    inc dl              ; Increment column
    mov ah, 0x02        ; Set cursor position
    int 0x10
    
    jmp .loop
.done:
    pop cx
    pop bx
    pop ax
    ret

; Data
hello_msg db 'Hi, OS!', 0
time_str db '00:00:00', 0
adv_msg db 'TinyOS at https://github.com/pegasusplus/tinyos ', 0
adv_msg_len dw $ - adv_msg - 1
;adv_msg_len equ $ - adv_msg - 1
scroll_pos dw 0
char_at_scroll_pos db 0
adv_color db 0x0C
adv_color_step db 0x01
adv_color_freq1 db 0x00
adv_color_freq_max1 db 0x1F
adv_color_freq2 db 0x00
adv_color_freq_max2 db 0x0F
is_paused db 0          ; 0 = running, 1 = paused
is_paused_display db 0
paused_msg db 'Paused'

; Pad to 510 bytes and add boot signature
times 510-($-$$) db 0
dw 0xAA55
