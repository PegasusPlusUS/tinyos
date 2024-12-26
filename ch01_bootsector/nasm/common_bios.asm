%macro BIOS_CLEAR_SCREEN 0
    mov ax, 0x0003      ; Text mode 80x25, 16 colors
    int 0x10            ; BIOS video interrupt
%endmacro

%macro BIOS_SET_PRINT_POSITION_P_ROW_COL 2
    mov ah, 0x02        ; Set cursor position
    mov bh, 0           ; Page 0
    mov dh, %1           ; Row 0 (line 1)
    mov dl, %2           ; Column 0
    int 0x10
%endmacro

%macro BIOS_SET_PRINT_COLOR_P_COLOR 1
    mov bl, byte %1
%endmacro

%macro BIOS_SET_PRINT_STRING_P_MSG 1
    mov si, %1
%endmacro

%macro BIOS_SET_PRINT_STRING_OFFSET_P_MSG_OFFSET 2
    mov si, %1
    add si, %2
%endmacro

%macro BIOS_PRINT_STRING_POS_P_ROW_COL_MSG 3
    mov ah, 0x02        ; Set cursor position
    mov bh, 0           ; Page 0
    mov dh, %1           ; Row 0 (line 1)
    mov dl, %2           ; Column 0
    int 0x10
    mov si, %3           ; String
    call bios_print_string
%endmacro

%macro FN_BIOS_PRINT_STRING_P_MSG 0
; Input: SI = pointer to string, BL = color attribute
bios_print_string:
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
%endmacro

%macro CALL_BIOS_QUERY_AND_PRINT_TIME 0
call bios_query_and_print_time
%endmacro

%macro FN_BIOS_QUERY_AND_PRINT_TIME 0
bios_query_and_print_time:
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
    BIOS_SET_PRINT_POSITION_P_ROW_COL [time_str_row], [time_str_col]
    BIOS_SET_PRINT_COLOR_P_COLOR [time_str_color]
    BIOS_SET_PRINT_STRING_P_MSG time_str
    call bios_print_string
    ret
%endmacro
