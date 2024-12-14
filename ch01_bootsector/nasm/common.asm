%macro INIT_SEGMENTS 0
    xor ax, ax          ; Clear AX
    mov ds, ax          ; Set DS=0
    mov es, ax          ; Set ES=0
    mov ss, ax          ; Set SS=0
    mov sp, 0x7C00      ; Set stack pointer just below where we're loaded
%endmacro

%macro CLEAR_SCREEN 0
    mov ax, 0x0003      ; Text mode 80x25, 16 colors
    int 0x10            ; BIOS video interrupt
%endmacro

%macro SET_PRINT_POSITION 2
    mov ah, 0x02        ; Set cursor position
    mov bh, 0           ; Page 0
    mov dh, %1           ; Row 0 (line 1)
    mov dl, %2           ; Column 0
    int 0x10
%endmacro

%macro SET_PRINT_COLOR 1
    mov bl, byte %1
%endmacro

%macro SET_PRINT_STRING 1
    mov si, %1
%endmacro

%macro SET_PRINT_STRING_OFFSET 2
    mov si, %1
    add si, %2
%endmacro

%macro PRINT_STRING_POS 3
    mov ah, 0x02        ; Set cursor position
    mov bh, 0           ; Page 0
    mov dh, %1           ; Row 0 (line 1)
    mov dl, %2           ; Column 0
    int 0x10
    mov si, %3           ; String
    call print_string
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

%macro FN_PRINT_STRING 0
; Input: SI = pointer to string, BL = color attribute
print_string:
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

; dh: row, dl: column, bl: color, si: string
%macro PRINT_STRING_COLOR 4
    SET_PRINT_POSITION %1, %2
    SET_PRINT_COLOR %3
    mov si, %4           ; String
    call print_string
%endmacro

