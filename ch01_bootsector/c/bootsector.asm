	.file	"bootsector.c"
	.code16gcc
	.text
/APP
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
	
/NO_APP
	.globl	_asm_char_1_
	.section	.bss
	.type	_asm_char_1_, @object
	.size	_asm_char_1_, 1
_asm_char_1_:
	.zero	1
	.globl	_asm_char_2_
	.type	_asm_char_2_, @object
	.size	_asm_char_2_, 1
_asm_char_2_:
	.zero	1
	.globl	_asm_msg_
	.align 4
	.type	_asm_msg_, @object
	.size	_asm_msg_, 4
_asm_msg_:
	.zero	4
	.globl	ADV_MSG
	.section	.rodata
	.align 4
	.type	ADV_MSG, @object
	.size	ADV_MSG, 26
ADV_MSG:
	.string	"GitHub:PegasusPlus/tinyos"
	.text
	.globl	asm_bios_set_cursor_pos
	.type	asm_bios_set_cursor_pos, @function
asm_bios_set_cursor_pos:
	push	%bp
	movw	%sp, %bp
	subw	$8, %sp
	movw	8(%bp), %dx
	movw	12(%bp), %ax
	movb	%dl, -4(%bp)
	movb	%al, -8(%bp)
	movzbw	-4(%bp), %ax
	movzbw	-8(%bp), %dx
/APP
/  21 "../../ch01_bootsector/c/bootsector.c" 1
	pushal
	movb %al, %dh
	movb %dl, %dl
	movb $0x02, %ah
	int $0x10
	popal
	
/  0 "" 2
/NO_APP
	nop
	leave
	ret
	.size	asm_bios_set_cursor_pos, .-asm_bios_set_cursor_pos
	.globl	asm_bios_clear_screen
	.type	asm_bios_clear_screen, @function
asm_bios_clear_screen:
	push	%bp
	movw	%sp, %bp
/APP
/  40 "../../ch01_bootsector/c/bootsector.c" 1
	pushal
	movw $0x0003, %ax
	int $0x10
	popal
	
/  0 "" 2
/NO_APP
	nop
	pop	%bp
	ret
	.size	asm_bios_clear_screen, .-asm_bios_clear_screen
	.globl	asm_bios_set_print_color
	.type	asm_bios_set_print_color, @function
asm_bios_set_print_color:
	push	%bp
	movw	%sp, %bp
	subw	$4, %sp
	movw	8(%bp), %ax
	movb	%al, -4(%bp)
	movzbw	-4(%bp), %ax
/APP
/  54 "../../ch01_bootsector/c/bootsector.c" 1
	pushal
	movb $0x0, %bh
	movb %al, %bl
	movb $0x0, %ah
	int $0x10
	popal
	
/  0 "" 2
/NO_APP
	nop
	leave
	ret
	.size	asm_bios_set_print_color, .-asm_bios_set_print_color
	.globl	asm_bios_print_char
	.type	asm_bios_print_char, @function
asm_bios_print_char:
	push	%bp
	movw	%sp, %bp
	subw	$4, %sp
	movw	8(%bp), %ax
	movb	%al, -4(%bp)
	movzbw	-4(%bp), %ax
/APP
/  70 "../../ch01_bootsector/c/bootsector.c" 1
	pushal
	movb %al, %al
	movb $0x09, %ah
	movw $0x01, %cx
	int $0x10
	popal
	
/  0 "" 2
/NO_APP
	nop
	leave
	ret
	.size	asm_bios_print_char, .-asm_bios_print_char
	.globl	HELLO_MSG
	.data
	.align 4
	.type	HELLO_MSG, @object
	.size	HELLO_MSG, 11
HELLO_MSG:
	.string	" Hi, gcc! "
	.globl	_scroll_pos_
	.section	.bss
	.align 2
	.type	_scroll_pos_, @object
	.size	_scroll_pos_, 2
_scroll_pos_:
	.zero	2
	.text
	.globl	print_hi_msg_scroll
	.type	print_hi_msg_scroll, @function
print_hi_msg_scroll:
	push	%bp
	movw	%sp, %bp
	push	$72
	call	asm_bios_print_char
	addw	$4, %sp
	movzx	_scroll_pos_, %ax
	cbtw
	movzbw	HELLO_MSG, %ax
	movb	%al, _asm_char_2_
	movzx	_scroll_pos_, %ax
	cbtw
	movb	$0, HELLO_MSG
	push	$105
	call	asm_bios_print_char
	addw	$4, %sp
	movzbw	_asm_char_2_, %dx
	movzx	_scroll_pos_, %ax
	cbtw
	movb	%dl, HELLO_MSG
	movzx	_scroll_pos_, %ax
	addw	$1, %ax
	movw	%ax, _scroll_pos_
	movzx	_scroll_pos_, %ax
	cmpw	$10, %ax
	jbe	.L7
	movw	$0, _scroll_pos_
.L7:
	nop
	leave
	ret
	.size	print_hi_msg_scroll, .-print_hi_msg_scroll
	.globl	delay
	.section	.bss
	.align 4
	.type	delay, @object
	.size	delay, 4
delay:
	.zero	4
	.text
	.globl	bootsector_main
	.type	bootsector_main, @function
bootsector_main:
	push	%bp
	movw	%sp, %bp
	call	asm_bios_clear_screen
	push	$0
	push	$0
	call	asm_bios_set_cursor_pos
	addw	$8, %sp
	push	$15
	call	asm_bios_set_print_color
	addw	$4, %sp
	push	$67
	call	asm_bios_print_char
	addw	$4, %sp
.L11:
	movw	$0, delay
	jmp	.L9
.L10:
/APP
/  176 "../../ch01_bootsector/c/bootsector.c" 1
	nop
/  0 "" 2
/NO_APP
.L9:
	movw	delay, %ax
	addw	$1, %ax
	movw	%ax, delay
	cmpw	$31999, %ax
	jle	.L10
	jmp	.L11
	.size	bootsector_main, .-bootsector_main
/APP
	.section .boot_signature
.byte 0x55, 0xAA

	.ident	"GCC: (GNU) 13.2.0"
