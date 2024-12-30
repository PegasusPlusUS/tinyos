	.file	"bootsector.c"
	.code16gcc
	.text
/APP
	.code16
	.global _start
	_start:
    xor ax
, ax
    mov ds
, ax
    mov es
, ax
    mov cs
, ax
    mov ss
, ax
    mov sp
, 0x7BFFh
    xor ax
, ax
    mov ax
, sp
    mov sp
, ax
    jmp $bootsector_main
, 0x0000h
	
/NO_APP
	global	ADV_MSG
	section	.rodata
	.align 4
	.type	ADV_MSG, @object
	.size	ADV_MSG, 26
ADV_MSG:
	.string	"GitHub:PegasusPlus/tinyos"
	.text
	global	asm_bios_set_cursor_pos
	.type	asm_bios_set_cursor_pos, @function
asm_bios_set_cursor_pos:
    pusha
    movw bp
, sp
    movb ah     # Set cursor position
, 0x02h
/APP
/  19 "../../ch01_bootsector/c/bootsector.c" 1
    movb dh    # Row from stack
, 8(bp)
    movb dl   # Column from stack
, 12(bp)
    movb bh     # Page number (usually 0)
, 0x00h
    int     0x10h
    popa
/  0 "" 2
/NO_APP
	nop
    ret
	.size	asm_bios_set_cursor_pos, .-asm_bios_set_cursor_pos
	global	asm_bios_clear_screen
	.type	asm_bios_clear_screen, @function
asm_bios_clear_screen:
    movw bp
, sp
/APP
/  38 "../../ch01_bootsector/c/bootsector.c" 1
    pusha
    movb ah     # Set video mode
, 0x00h
    movb al     # Mode 3: 80x25 color text
, 0x03h
    int     0x10h
    popa
	
/  0 "" 2
/NO_APP
	nop
    ret
	.size	asm_bios_clear_screen, .-asm_bios_clear_screen
	global	asm_bios_set_print_color
	.type	asm_bios_set_print_color, @function
asm_bios_set_print_color:
	pusha
    movw bp
, sp
    subw sp
, 4
    movw ax
, 8(bp)
    movb -4(bp)
, al
    movzbw ax
, -4(bp)
/APP
/  52 "../../ch01_bootsector/c/bootsector.c" 1
    movb bh
, 0x0h
    movb bl
, al
    movb ah
, 0x0h
	int 0x10h
	popa
	
/  0 "" 2
/NO_APP
	nop
	leave
	ret
	.size	asm_bios_set_print_color, .-asm_bios_set_print_color
	global	asm_bios_print_char
	.type	asm_bios_print_char, @function
asm_bios_print_char:
	pusha
    movw bp
, sp
    subw sp
, 4
    movw ax
, 8(bp)
    movb -4(bp)
, al
    movzbw ax
, -4(bp)
/APP
/  68 "../../ch01_bootsector/c/bootsector.c" 1
    movb al
, al
    movb ah
, 0x09h
    movw cx
, 0x01h
	int 0x10h
	popa
	
/  0 "" 2
/NO_APP
	nop
	ret
	.size	asm_bios_print_char, .-asm_bios_print_char
	global	HELLO_MSG
	.data
	.align 4
	.type	HELLO_MSG, @object
	.size	HELLO_MSG, 11
HELLO_MSG:
	.string	" Hi, gcc! "
	global	_scroll_pos_
	section	.bss
	.align 2
	.type	_scroll_pos_, @object
	.size	_scroll_pos_, 2
_scroll_pos_:
	.zero	2
	.text
	global	print_hi_msg_scroll
	.type	print_hi_msg_scroll, @function
print_hi_msg_scroll:
	push	bp
    movw bp
, sp
    subw sp
, 16
	push	72
	call	asm_bios_print_char
    addw sp
, 4
    movzx ax
, _scroll_pos_
	cbtw
    movzbw ax
, HELLO_MSG
    movb -1(bp)
, al
    movzx ax
, _scroll_pos_
	cbtw
    movb HELLO_MSG
, 0
	push	105
	call	asm_bios_print_char
    addw sp
, 4
    movzx ax
, _scroll_pos_
	cbtw
    movzbw dx
, -1(bp)
    movb HELLO_MSG
, dl
    movzx ax
, _scroll_pos_
    addw ax
, 1
    movw _scroll_pos_
, ax
    movzx ax
, _scroll_pos_
    cmpw ax
, 10
	jbe	.L7
    movw _scroll_pos_
, 0
.L7:
	nop
	leave
	ret
	.size	print_hi_msg_scroll, .-print_hi_msg_scroll
	global	delay
	section	.bss
	.align 4
	.type	delay, @object
	.size	delay, 4
delay:
	.zero	4
	.text
	global	bootsector_main
	.type	bootsector_main, @function
bootsector_main:
    movw bp
, sp
	call	asm_bios_clear_screen
	push	0
	push	12
	call	asm_bios_set_cursor_pos
    addw sp
, 8
	push	5
	push	12
	call	asm_bios_set_cursor_pos
    addw sp
, 8
	push	15
	call	asm_bios_set_print_color
    addw sp
, 4
	push	67
	call	asm_bios_print_char
    addw sp
, 4
.L11:
    movw delay
, 0
	jmp	.L9
.L10:
/APP
/  175 "../../ch01_bootsector/c/bootsector.c" 1
	nop
/  0 "" 2
/NO_APP
.L9:
    movw ax
, delay
    addw ax
, 1
    movw delay
, ax
    cmpw ax
, 31999
	jle	.L10
	jmp	.L11
	.size	bootsector_main, .-bootsector_main
/APP
	section .boot_signature
.byte 0x55, 0xAA

	.ident	"GCC: (GNU) 13.2.0"
