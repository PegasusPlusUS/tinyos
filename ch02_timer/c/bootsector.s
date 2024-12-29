	.file	"bootsector.c"
	.code16gcc
	.text
/APP
	.code16
	.global _start
	_start:
	xorw %ax, %ax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %ss
	movw $0x7C00, %sp
	call asm_bios_clear_screen
	movb $12, _asm_char_1_
	movb $27, _asm_char_2_
	call asm_bios_set_cursor_pos_p_row_col
	movb $10, _asm_char_1_
	movw $ADV_MSG, _asm_msg_
	call asm_bios_print_string_p_msg_color
	cli
	movb $0x11, %al
	outb %al, $0x20
	movb $0x20, %al
	outb %al, $0x21
	movb $0x04, %al
	outb %al, $0x21
	movb $0x01, %al
	outb %al, $0x21
	movb $0x36, %al
	outb %al, $0x43
	movw $0x04AF, %ax
	outb %al, $0x40
	movb %ah, %al
	outb %al, $0x40
	xorw %ax, %ax
	movw %ax, %es
	movw %ax, %es:0x20*4+2
	movw $.inline_isr_, %ax
	movw %ax, %es:0x20*4
	movw %es:0x20*4, %ax
	movb $0xFE, %al
	outb %al, $0x21
	sti
	.halt:
	hlt
	jmp .halt
	.inline_isr_:
	pushal
	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %es
	call timer_handler
	movb $0x20, %al
	outb %al, $0x20
	popal
	iret
	
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
	.globl	HELLO_MSG
	.data
	.align 4
	.type	HELLO_MSG, @object
	.size	HELLO_MSG, 19
HELLO_MSG:
	.string	" C in timer mode! "
	.globl	_scroll_pos_
	.section	.bss
	.align 2
	.type	_scroll_pos_, @object
	.size	_scroll_pos_, 2
_scroll_pos_:
	.zero	2
	.text
	.globl	asm_bios_clear_screen
	.type	asm_bios_clear_screen, @function
asm_bios_clear_screen:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  21 "bootsector.c" 1
	pushal
	mov $0x0003, %ax
	int $0x10
	popal
	
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	asm_bios_clear_screen, .-asm_bios_clear_screen
	.globl	asm_bios_set_cursor_pos_p_row_col
	.type	asm_bios_set_cursor_pos_p_row_col, @function
asm_bios_set_cursor_pos_p_row_col:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  22 "bootsector.c" 1
	pushal
	xor %bh, %bh
	movb _asm_char_1_, %dh
	movb _asm_char_2_, %dl
	movb $0x02, %ah
	int $0x10
	popal
	
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	asm_bios_set_cursor_pos_p_row_col, .-asm_bios_set_cursor_pos_p_row_col
	.globl	asm_bios_print_string_p_msg_color
	.type	asm_bios_print_string_p_msg_color, @function
asm_bios_print_string_p_msg_color:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  23 "bootsector.c" 1
	.code16
	pushal
	mov _asm_msg_, %si
	.loop:
	lodsb
	test %al, %al
	jz .done
	movb $0x09, %ah
	movw $1, %cx
	movb _asm_char_1_, %bl
	xor %bh, %bh
	int $0x10
	movb $0x03, %ah
	xor %bh, %bh
	int $0x10
	inc %dl
	movb $0x02, %ah
	int $0x10
	jmp .loop
	.done:
	popal
	
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	asm_bios_print_string_p_msg_color, .-asm_bios_print_string_p_msg_color
	.globl	print_hi_msg_scroll
	.type	print_hi_msg_scroll, @function
print_hi_msg_scroll:
	pushl	%ebp
	movl	%esp, %ebp
	movzwl	_scroll_pos_, %eax
	cwtl
	addl	$HELLO_MSG, %eax
	movl	%eax, _asm_msg_
	call	asm_bios_print_string_p_msg_color
	movzwl	_scroll_pos_, %eax
	cwtl
	movzbl	HELLO_MSG(%eax), %eax
	movb	%al, _asm_char_2_
	movzwl	_scroll_pos_, %eax
	cwtl
	movb	$0, HELLO_MSG(%eax)
	movl	$HELLO_MSG, _asm_msg_
	call	asm_bios_print_string_p_msg_color
	movzwl	_scroll_pos_, %eax
	cwtl
	movzbl	_asm_char_2_, %edx
	movb	%dl, HELLO_MSG(%eax)
	movzwl	_scroll_pos_, %eax
	addl	$1, %eax
	movw	%ax, _scroll_pos_
	movzwl	_scroll_pos_, %eax
	cmpw	$18, %ax
	jbe	.L6
	movw	$0, _scroll_pos_
.L6:
	nop
	popl	%ebp
	ret
	.size	print_hi_msg_scroll, .-print_hi_msg_scroll
	.globl	delay
	.section	.bss
	.type	delay, @object
	.size	delay, 1
delay:
	.zero	1
	.text
	.globl	timer_hadler
	.type	timer_hadler, @function
timer_hadler:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  38 "bootsector.c" 1
	.global timer_handler
	timer_handler:
	
/  0 "" 2
/NO_APP
	movzbl	delay, %eax
	addl	$1, %eax
	movb	%al, delay
	cmpb	$-73, %al
	jbe	.L8
	movb	$0, delay
	movb	$8, _asm_char_1_
	movb	$31, _asm_char_2_
	call	asm_bios_set_cursor_pos_p_row_col
	movb	$15, _asm_char_1_
	call	print_hi_msg_scroll
.L8:
/APP
/  47 "bootsector.c" 1
	ret
	
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	timer_hadler, .-timer_hadler
/APP
	.section .boot_signature
.byte 0x55, 0xAA

	.ident	"GCC: (GNU) 13.2.0"
