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
/  39 "bootsector.h" 1
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
/  52 "bootsector.h" 1
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
/  67 "bootsector.h" 1
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
/  82 "bootsector.h" 1
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
	.globl	bootsector_main
	.type	bootsector_main, @function
bootsector_main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	pushl	$5
	pushl	$12
	call	asm_bios_set_cursor_pos
	addl	$16, %esp
.L11:
	xorl	%eax, %eax
	movl	%eax, -12(%ebp)
.L9:
	movl	-12(%ebp), %eax
	incl	%eax
	movl	%eax, -12(%ebp)
	cmpl	$31999, %eax
	jg	.L11
/APP
/  66 "bootsector.c" 1
	nop
/  0 "" 2
/NO_APP
	jmp	.L9
	.size	bootsector_main, .-bootsector_main
	.ident	"GCC: (GNU) 13.2.0"
