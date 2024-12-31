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
	.global	asm_bios_set_cursor_pos
	.type	asm_bios_set_cursor_pos, @function
asm_bios_set_cursor_pos:
	movw	%sp,	%bx
	movb	4(%bx),	%cl
	movb	2(%bx),	%al
#APP
;# 19 "bootsector.c" 1
	.code16
	movb %al, %dh
	movb %cl, %dl
	movb $0x02, %ah
	int $0x10
	
#NO_APP
	ret
	.size	asm_bios_set_cursor_pos, .-asm_bios_set_cursor_pos
	.global	bootsector_main
	.type	bootsector_main, @function
bootsector_main:
	pushw	%bp
	movw	%sp,	%bp
	pushw	%ds
	movb	$5,	%al
	pushw	%ax
	movb	$12,	%al
	pushw	%ax
	call	asm_bios_set_cursor_pos
	addw	$4,	%sp
	xorw	%dx,	%dx
.L6:
	movw	%dx,	-2(%bp)
.L4:
	movw	-2(%bp),	%ax
	incw	%ax
	movw	%ax,	-2(%bp)
	cmpw	$31999,	%ax
	jg	.L6
#APP
;# 160 "bootsector.c" 1
	nop
#NO_APP
	jmp	.L4
	.size	bootsector_main, .-bootsector_main
	.ident	"GCC: (GNU) 6.3.0"
