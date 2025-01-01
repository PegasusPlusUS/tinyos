	.file	"bootsector.c"
	.text
/APP
	.code16
	.global _start
	_start:
xor %ax, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %ss
	mov $0x7BFF, %sp
	jmp $0x0000, $bootsector_main
	
	.section .boot_signature
.byte 0x55, 0xAA

/NO_APP
	.globl	asm_bios_clear_screen
	.type	asm_bios_clear_screen, @function
asm_bios_clear_screen:
/APP
/  26 "../c/common_bios.h" 1
	.code16
	movw $0x0003, %ax
	int $0x10
	
/  0 "" 2
/NO_APP
	ret
	.size	asm_bios_clear_screen, .-asm_bios_clear_screen
	.globl	asm_bios_set_cursor_pos
	.type	asm_bios_set_cursor_pos, @function
asm_bios_set_cursor_pos:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movb	8(%ebp), %cl
	movb	12(%ebp), %bl
/APP
/  39 "../c/common_bios.h" 1
	.code16
	movb %cl, %dh
	movb %bl, %dl
	movb $0x02, %ah
	int $0x10
	
/  0 "" 2
/NO_APP
	popl	%ebx
	popl	%ebp
	ret
	.size	asm_bios_set_cursor_pos, .-asm_bios_set_cursor_pos
	.globl	asm_bios_set_print_color
	.type	asm_bios_set_print_color, @function
asm_bios_set_print_color:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movb	8(%ebp), %dl
/APP
/  54 "../c/common_bios.h" 1
	.code16
	movb $0x0, %bh
	movb %dl, %bl
	movb $0x0, %ah
	int $0x10
	
/  0 "" 2
/NO_APP
	popl	%ebx
	popl	%ebp
	ret
	.size	asm_bios_set_print_color, .-asm_bios_set_print_color
	.globl	asm_bios_print_char
	.type	asm_bios_print_char, @function
asm_bios_print_char:
	pushl	%ebp
	movl	%esp, %ebp
	movb	8(%ebp), %dl
/APP
/  69 "../c/common_bios.h" 1
	.code16
	movb %dl, %al
	movb $0x09, %ah
	movw $0x01, %cx
	int $0x10
	
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	asm_bios_print_char, .-asm_bios_print_char
	.globl	start
	.type	start, @function
start:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%eax
	call	asm_bios_clear_screen
	pushl	%edx
	pushl	%edx
	pushl	$23
	pushl	$10
	call	asm_bios_set_cursor_pos
	movl	$12, (%esp)
	call	asm_bios_set_print_color
	addl	$16, %esp
	xorl	%ebx, %ebx
.L9:
	cmpl	%ebx, _const_bootsector__hello_msg+4
	jle	.L11
	subl	$12, %esp
	movl	_const_bootsector__hello_msg, %eax
	movzbl	(%eax,%ebx), %eax
	pushl	%eax
	call	asm_bios_print_char
	incl	%ebx
	addl	$16, %esp
	jmp	.L9
.L11:
	jmp	.L11
	.size	start, .-start
	.globl	bootsector_main
	.type	bootsector_main, @function
bootsector_main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	call	start
	.size	bootsector_main, .-bootsector_main
	.globl	hello_msg
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	" Hello, world of Bare Metal in V! "
	.data
	.align 4
	.type	hello_msg, @object
	.size	hello_msg, 12
hello_msg:
	.long	.LC0
	.long	34
	.long	1
	.globl	_const_bootsector__hello_msg
	.section	.bss
	.align 4
	.type	_const_bootsector__hello_msg, @object
	.size	_const_bootsector__hello_msg, 12
_const_bootsector__hello_msg:
	.zero	12
	.ident	"GCC: (GNU) 13.2.0"
