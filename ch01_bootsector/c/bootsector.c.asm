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
	mov %ax, %ss
	mov $0x7BFF, %sp
	jmp $0x0000, $bootsector_main
	
	.section .boot_signature
.byte 0x55, 0xAA

#NO_APP
	.text
	.global	asm_bios_clear_screen
	.type	asm_bios_clear_screen, @function
asm_bios_clear_screen:
#APP
;# 39 "bootsector.h" 1
	.code16
	movw $0x0003, %ax
	int $0x10
	
#NO_APP
	ret
	.size	asm_bios_clear_screen, .-asm_bios_clear_screen
	.global	asm_bios_set_cursor_pos
	.type	asm_bios_set_cursor_pos, @function
asm_bios_set_cursor_pos:
	movw	%sp,	%bx
	movb	4(%bx),	%cl
	movb	2(%bx),	%al
#APP
;# 52 "bootsector.h" 1
	.code16
	movb %al, %dh
	movb %cl, %dl
	movb $0x02, %ah
	int $0x10
	
#NO_APP
	ret
	.size	asm_bios_set_cursor_pos, .-asm_bios_set_cursor_pos
	.global	asm_bios_set_print_color
	.type	asm_bios_set_print_color, @function
asm_bios_set_print_color:
	movw	%sp,	%bx
	movb	2(%bx),	%al
#APP
;# 67 "bootsector.h" 1
	.code16
	movb $0x0, %bh
	movb %al, %bl
	movb $0x0, %ah
	int $0x10
	
#NO_APP
	ret
	.size	asm_bios_set_print_color, .-asm_bios_set_print_color
	.global	asm_bios_print_char
	.type	asm_bios_print_char, @function
asm_bios_print_char:
	movw	%sp,	%bx
	movb	2(%bx),	%dl
#APP
;# 82 "bootsector.h" 1
	.code16
	movb %dl, %al
	movb $0x09, %ah
	movw $0x01, %cx
	int $0x10
	
#NO_APP
	ret
	.size	asm_bios_print_char, .-asm_bios_print_char
	.global	print_string
	.type	print_string, @function
print_string:
	pushw	%si
	pushw	%bp
	movw	%sp,	%bp
	pushw	%ds
	movb	$10,	%al
	pushw	%ax
	call	asm_bios_set_print_color
	movw	6(%bp),	%si
	addw	$2,	%sp
.L9:
	cmpb	$0,	(%si)
	jne	.L10
	movw	%bp,	%sp
	popw	%bp
	popw	%si
	ret
.L10:
	movb	10(%bp),	%al
	incb	%al
	movb	%al,	-1(%bp)
	pushw	10(%bp)
	pushw	8(%bp)
	call	asm_bios_set_cursor_pos
	pushw	(%si)
	call	asm_bios_print_char
	incw	%si
	addw	$6,	%sp
	movb	-1(%bp),	%al
	movb	%al,	10(%bp)
	jmp	.L9
	.size	print_string, .-print_string
	.global	bootsector_main
	.type	bootsector_main, @function
bootsector_main:
	pushw	%bp
	movw	%sp,	%bp
	pushw	%ds
	call	asm_bios_clear_screen
	movb	$10,	%al
	pushw	%ax
	movb	$27,	%al
	pushw	%ax
	movb	$12,	%al
	pushw	%ax
	movw	$ADV_MSG,	%ax
	pushw	%ax
	call	print_string
	addw	$8,	%sp
	xorw	%dx,	%dx
.L15:
	movw	%dx,	-2(%bp)
.L13:
	movw	-2(%bp),	%ax
	incw	%ax
	movw	%ax,	-2(%bp)
	cmpw	$31999,	%ax
	jg	.L15
#APP
;# 70 "bootsector.c" 1
	nop
#NO_APP
	jmp	.L13
	.size	bootsector_main, .-bootsector_main
	.global	HELLO_MSG
	.data
	.type	HELLO_MSG, @object
	.size	HELLO_MSG, 11
HELLO_MSG:
	.string	" Hi, gcc! "
	.global	ADV_MSG
	.section	.rodata
	.type	ADV_MSG, @object
	.size	ADV_MSG, 22
ADV_MSG:
	.string	"GH:PegasusPlus/tinyos"
	.ident	"GCC: (GNU) 6.3.0"
