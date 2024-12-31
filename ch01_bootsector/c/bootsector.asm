	.arch i8086,jumps
	.code16
	.att_syntax prefix
#NO_APP
#APP
	.code16
	.global _start
	_start:
xor %ax, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %cs
	mov %ax, %ss
	mov $0x7BFF, %sp
	xor %ax, %ax
	mov %sp, %ax
	mov %ax, %sp
	jmp $0x0000, $bootsector_main
	
#NO_APP
	.global	ADV_MSG
	.section	.rodata
	.type	ADV_MSG, @object
	.size	ADV_MSG, 26
ADV_MSG:
	.string	"GitHub:PegasusPlus/tinyos"
	.text
	.global	asm_bios_set_cursor_pos
	.type	asm_bios_set_cursor_pos, @function
asm_bios_set_cursor_pos:
	pushw	%bp
	movw	%sp,	%bp
	movb	4(%bp),	%al
	movb	6(%bp),	%ah
#APP
;# 19 "../../ch01_bootsector/c/bootsector.c" 1
	pushal
	movb %al, %dh
	movb %ah, %dl
	movb $0x02, %ah
	int $0x10
	popal
	
#NO_APP
	nop
	popw	%bp
	pushw	%ss
	popw	%ds
	ret
	.size	asm_bios_set_cursor_pos, .-asm_bios_set_cursor_pos
	.global	asm_bios_clear_screen
	.type	asm_bios_clear_screen, @function
asm_bios_clear_screen:
	pushw	%bp
	movw	%sp,	%bp
#APP
;# 38 "../../ch01_bootsector/c/bootsector.c" 1
	pushal
	movw $0x0003, %ax
	int $0x10
	popal
	
#NO_APP
	nop
	popw	%bp
	pushw	%ss
	popw	%ds
	ret
	.size	asm_bios_clear_screen, .-asm_bios_clear_screen
	.global	asm_bios_set_print_color
	.type	asm_bios_set_print_color, @function
asm_bios_set_print_color:
	pushw	%bp
	movw	%sp,	%bp
	movb	4(%bp),	%al
#APP
;# 52 "../../ch01_bootsector/c/bootsector.c" 1
	pushal
	movb $0x0, %bh
	movb %al, %bl
	movb $0x0, %ah
	int $0x10
	popal
	
#NO_APP
	nop
	popw	%bp
	pushw	%ss
	popw	%ds
	ret
	.size	asm_bios_set_print_color, .-asm_bios_set_print_color
	.global	asm_bios_print_char
	.type	asm_bios_print_char, @function
asm_bios_print_char:
	pushw	%bp
	movw	%sp,	%bp
	movb	4(%bp),	%al
#APP
;# 68 "../../ch01_bootsector/c/bootsector.c" 1
	pushal
	movb %al, %al
	movb $0x09, %ah
	movw $0x01, %cx
	int $0x10
	popal
	
#NO_APP
	nop
	popw	%bp
	pushw	%ss
	popw	%ds
	ret
	.size	asm_bios_print_char, .-asm_bios_print_char
	.global	HELLO_MSG
	.data
	.type	HELLO_MSG, @object
	.size	HELLO_MSG, 11
HELLO_MSG:
	.string	" Hi, gcc! "
	.global	_scroll_pos_
	.bss
	.p2align	1
	.type	_scroll_pos_, @object
	.size	_scroll_pos_, 2
_scroll_pos_:
	.skip	2,0
	.text
	.global	print_hi_msg_scroll
	.type	print_hi_msg_scroll, @function
print_hi_msg_scroll:
	pushw	%bp
	movw	%sp,	%bp
	subw	$2,	%sp
	movb	$72,	%al
	pushw	%ax
	pushw	%ss
	popw	%ds
	call	asm_bios_print_char
	addw	$2,	%sp
	movw	%ss:_scroll_pos_,	%bx
	movb	%ss:HELLO_MSG,	%al
	movb	%al,	-1(%bp)
	movw	%ss:_scroll_pos_,	%bx
	movb	$0,	%ss:HELLO_MSG
	movb	$105,	%al
	pushw	%ax
	pushw	%ss
	popw	%ds
	call	asm_bios_print_char
	addw	$2,	%sp
	movw	%ss:_scroll_pos_,	%bx
	movb	-1(%bp),	%al
	movb	%al,	%ss:HELLO_MSG
	movw	%ss:_scroll_pos_,	%ax
	incw	%ax
	movw	%ax,	%ss:_scroll_pos_
	movw	%ss:_scroll_pos_,	%ax
	cmpw	$10+1,	%ax
	cmpw	$10,	%ax
	jbe	.L7
	movw	$0,	%ss:_scroll_pos_
.L7:
	nop
	movw	%bp,	%sp
	popw	%bp
	pushw	%ss
	popw	%ds
	ret
	.size	print_hi_msg_scroll, .-print_hi_msg_scroll
	.comm	delay,2,2
	.global	bootsector_main
	.type	bootsector_main, @function
bootsector_main:
	pushw	%bp
	movw	%sp,	%bp
	pushw	%ss
	popw	%ds
	call	asm_bios_clear_screen
	movb	$0,	%al
	pushw	%ax
	movb	$12,	%al
	pushw	%ax
	pushw	%ss
	popw	%ds
	call	asm_bios_set_cursor_pos
	addw	$4,	%sp
	movb	$5,	%al
	pushw	%ax
	movb	$12,	%al
	pushw	%ax
	pushw	%ss
	popw	%ds
	call	asm_bios_set_cursor_pos
	addw	$4,	%sp
	movb	$15,	%al
	pushw	%ax
	pushw	%ss
	popw	%ds
	call	asm_bios_set_print_color
	addw	$2,	%sp
	movb	$67,	%al
	pushw	%ax
	pushw	%ss
	popw	%ds
	call	asm_bios_print_char
	addw	$2,	%sp
.L11:
	movw	$0,	%ss:delay
	jmp	.L9
.L10:
#APP
;# 175 "../../ch01_bootsector/c/bootsector.c" 1
	nop
#NO_APP
.L9:
	movw	%ss:delay,	%ax
	incw	%ax
	movw	%ax,	%ss:delay
	cmpw	$31999,	%ax
	cmpw	$31999,	%ax
	jle	.L10
	jmp	.L11
	.size	bootsector_main, .-bootsector_main
#APP
	.section .boot_signature
.byte 0x55, 0xAA

	.ident	"GCC: (GNU) 6.3.0"
