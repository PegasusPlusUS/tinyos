%include "common_bios.asm"

%macro INIT_SEGMENTS 0
    xor ax, ax          ; Clear AX
    mov ds, ax          ; Set DS=0
    mov es, ax          ; Set ES=0
    mov ss, ax          ; Set SS=0
    mov sp, 0x7C00      ; Set stack pointer just below where we're loaded
%endmacro

%macro FN_BCD_TO_ASCII 0
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
%endmacro

; dh: row, dl: column, bl: color, si: string
%macro PRINT_STRING_COLOR 4
    BIOS_SET_PRINT_POSITION_P_ROW_COL %1, %2
    BIOS_SET_PRINT_COLOR_P_COLOR %3
    mov si, %4           ; String
    call bios_print_string
%endmacro

%macro DATA_TIME_STR 0
time_str db '00:'
time_str_min db '00:'
time_str_sec db '00', 0
time_str_row db 2
time_str_col db 0
time_str_color db 0x0F
%endmacro

%macro DATA_SAFE_POWER_OFF 0
turn_on_msg db "It's safe to turn off.", 0
turn_on_msg_row db 4
turn_on_msg_col db 0
turn_on_msg_color db 0x0A
%endmacro

%macro DATA_ADV 0
adv_msg db ' Tutorial at gh:pegasusplus/tinyos ', 0
adv_msg_len dw $ - adv_msg - 1
;adv_msg_len equ $ - adv_msg - 1
adv_msg_row db 6
adv_msg_col db 0
adv_msg_color db 0x0D
scroll_pos dw 0
char_at_scroll_pos db 0
%endmacro

%macro DATA_PAUSED 0
is_paused db 0          ; 0 = running, 1 = paused
is_paused_display db 0
paused_msg db 'Paused', 0
paused_msg_row db 2
paused_msg_col db 37
paused_msg_color db 0x0E
%endmacro

%macro CALL_PRINT_ADV_SCROLL 0
call print_adv_scroll
%endmacro

%macro FN_PRINT_ADV_SCROLL 0
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
    call bios_print_string
; Continue print from beginning to scroll_pos
    mov si, adv_msg
    add si, [scroll_pos]
    mov byte [si], 0
    ; print from beginning to scroll_pos
    mov si, adv_msg
    call bios_print_string
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
%endmacro

%macro FN_FLASH_PAUSED_DISPLAY 0
flash_paused_display:
    mov al, [is_paused_display]
    xor al, 1           ; Toggle between 0 and 1
    mov [is_paused_display], al

    ; Display or clear "Paused" message based on is_paused_display
    test al, al
    jz clear_paused     ; If is_paused_display is 0, clear the message

    ; Display "Paused" message
    BIOS_SET_PRINT_COLOR_P_COLOR [paused_msg_color]
    jmp print_pause_msg_pos

clear_paused:
; Clear the "Paused" message (separate function)
    BIOS_SET_PRINT_COLOR_P_COLOR 0x00        ; Black color (clear text)
print_pause_msg_pos:
    BIOS_PRINT_STRING_POS_P_ROW_COL_MSG [paused_msg_row], [paused_msg_col], paused_msg
    ret
%endmacro
