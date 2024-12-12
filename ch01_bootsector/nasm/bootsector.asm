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

    ; Print hello message at line 1 in yellow
    mov ah, 0x02        ; Set cursor position
    xor bh, bh          ; Page 0
    mov dh, 0           ; Row 0 (line 1)
    mov dl, 0           ; Column 0
    int 0x10
    mov si, hello_msg
    mov bl, 0x0E        ; Yellow color
    call print_string_color

    ; Print green "safe to turn off" message at line 3
    mov ah, 0x02        ; Set cursor position
    mov dh, 4           ; Row 4 (line 5)
    mov dl, 0           ; Column 0
    int 0x10
    mov si, safe_msg
    mov bl, 0x0A        ; Light green color
    call print_string_color

main_loop:
    ; Print adv message "TinyOS is an open source tutorial at https://github.com/pegasusplus/tinyos" at line 4
    mov ah, 0x02        ; Set cursor position
    mov dh, 6           ; Row 6 (line 7)
    mov dl, 0           ; Column 0
    int 0x10
    mov si, adv_msg
    mov bl, [adv_color]   ; Light blue color
    call print_string_color 

    ; Position cursor for time display at line 2
    mov ah, 0x02        ; Set cursor position
    mov dh, 2           ; Row 2 (line 3)
    mov dl, 0           ; Column 0
    int 0x10

    ; Get time from BIOS RTC
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
    
    ; Print the time in white
    mov si, time_str
    mov bl, 0x0F        ; Bright white color
    call print_string_color
    
    ; Add a small delay
    mov cx, 0xFFFF
delay:
    loop delay
    mov al, [adv_color_freq1]
    inc al
    mov [adv_color_freq1], al
    cmp al, [adv_color_freq_max1]
    jne main_loop
    mov al, 0
    mov [adv_color_freq1], al
    mov al, [adv_color_freq2]
    inc al
    mov [adv_color_freq2], al
    cmp al, [adv_color_freq_max2]
    jne main_loop
    mov al, 0
    mov [adv_color_freq2], al
    mov al, [adv_color]   ; Slightly change color
    inc al
    mov [adv_color], al
    jmp main_loop       ; Repeat forever

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
hello_msg db 'Hello, bootsector!', 0
time_str db '00:00:00', 0
safe_msg db 'Now it is safe to turn off your box.', 0
adv_msg db 'TinyOS is an open source tutorial at https://github.com/pegasusplus/tinyos', 0
adv_color db 0x0C
adv_color_step db 0x01
adv_color_freq1 db 0x00
adv_color_freq_max1 db 0x1F
adv_color_freq2 db 0x00
adv_color_freq_max2 db 0x0F

; Pad to 510 bytes and add boot signature
times 510-($-$$) db 0
dw 0xAA55
