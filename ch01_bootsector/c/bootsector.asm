jg 0x47
dec sp
inc si
addw [bx+di],ax
addw [bx+si],ax
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
addw [bx+si],ax
add ax,[bx+si]
addw [bx+si],ax
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
pusha
add al,0x0
add [bx+si],al
add [bx+si],al
add [si],dh
add [bx+si],al
add [bx+si],al
addw [bx+si],ch
add [bp+di],cl
addw [bx+si],cl
add [bx+di],dh
ror byte [bp-0x7128],byte 0xc0
movw cs,ax
movw ss,ax
mov sp,0x7bff
xor ax,ax
mov ax,sp
movw sp,ax
jmp 0x0:0x0
pusha
mov bp,sp
mov ah,0x2
mov dh,[bp+0x8]
mov dl,[bp+0xc]
mov bh,0x0
int 0x10
popa
nop
ret
mov bp,sp
pusha
mov ah,0x0
mov al,0x3
int 0x10
popa
nop
ret
pusha
mov bp,sp
sub sp,byte +0x4
mov ax,[bp+0x8]
movb [bp-0x4],al
movzx ax,[bp-0x4]
mov bh,0x0
movb bl,al
mov ah,0x0
int 0x10
popa
nop
leave
ret
pusha
mov bp,sp
sub sp,byte +0x4
mov ax,[bp+0x8]
movb [bp-0x4],al
movzx ax,[bp-0x4]
movb al,al
mov ah,0x9
mov cx,0x1
int 0x10
popa
nop
ret
push bp
mov bp,sp
sub sp,byte +0x10
push byte +0x48
call 0xab
add sp,byte +0x4
movzx ax,[0x0]
cbw
movzx ax,[0x0]
movb [bp-0x1],al
movzx ax,[0x0]
cbw
mov byte [0x0],0x0
push byte +0x69
call 0xcc
add sp,byte +0x4
movzx ax,[0x0]
cbw
movzx dx,[bp-0x1]
mov [0x0],dl
movzx ax,[0x0]
add ax,byte +0x1
movw [0x0],ax
movzx ax,[0x0]
cmp ax,byte +0xa
jna 0xfa
mov word [0x0],0x0
nop
leave
ret
mov bp,sp
call 0x100
push byte +0x0
push byte +0xc
call 0x107
add sp,byte +0x8
push byte +0x5
push byte +0xc
call 0x111
add sp,byte +0x8
push byte +0xf
call 0x119
add sp,byte +0x4
push byte +0x43
call 0x121
add sp,byte +0x4
mov word [0x0],0x0
jmp short 0x12f
nop
mov ax,[0x0]
add ax,byte +0x1
movw [0x0],ax
cmp ax,0x7cff
jng 0x12e
jmp short 0x126
addw [bx+si],ah
dec ax
imul bp,[si],word 0x6720
arpl [bp+di+0x21],sp
and [bx+si],al
add [bx+0x69],al
jz 0x198
jnz 0x1b4
cmp dl,[bx+si+0x65]
a32 popa
jnc 0x1ce
jnc 0x1ab
insb
jnz 0x1d1
das
jz 0x1ca
outsb
jns 0x1d3
jnc 0x166
push bp
stosb
add [bx+0x43],al
inc bx
cmp ah,[bx+si]
sub [bx+0x4e],al
push bp
sub [bx+si],sp
xor [bp+di],si
xor ch,[cs:0x30]
add [0x7973],ch
insw
jz 0x1e3
bound ax,[bx+si]
cs jnc 0x1fb
jc 0x1fd
popa
bound ax,[bx+si]
cs jnc 0x1f7
jnc 0x205
jc 0x207
popa
bound ax,[bx+si]
cs jc 0x1fe
insb
cs jz 0x202
js 0x213
add [0x6164],ch
jz 0x206
add [0x7362],ch
jnc 0x1ab
cs jc 0x21d
fs popa
jz 0x213
add [0x6f62],ch
outsw
jz 0x218
jnc 0x224
a32 outsb
popa
jz 0x235
jc 0x227
add [0x6f63],ch
insw
insw
gs outsb
jz 0x1cc
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
addw [bx+si],ax
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add al,0x0
int1
inc word [bx+si]
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bp+di],al
add [bx+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bp+di],al
add [bp+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bp+di],al
add [si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bp+di],al
add [di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bp+di],al
add [0x0],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bp+di],al
add [bx],al
add [0x0],cl
addb [bx+si], al
addb [bx+si], al
add [bx+si], al
add [bx+si], al
addw [bx+si],dl
add [bx+di],al
add [di],dl
add [bx+si],al
add cl,cl
add [bx+si],al
add [bp+si+0x0],al
add [bx+si],al
adc al,[bx+si]
addw [bx+si],ax
and ax,0x0
add [bx+si],al
add [bx+si],al
add [bp+si],bl
add [bx+si],al
add [bx+di],dl
add [di],al
add [di],ch
add [bx+si],al
addw [bx+si],bl
add [bx+si],al
add [bp+si],dl
add [bx+si],al
add [bp+si],dl
add [bx+di],al
add [di+0x0],al
add [bx+si],al
sub al,[bx+si]
add [bx+si],al
or al,0x0
add [bx+si],al
adc al,[bx+si]
addw [bx+si],ax
pop bx
add [bx+si],al
add [0x0],dh
add [si],bl
add [bx+si],al
add [bp+si],dl
add [bx+di],al
add [si+0x0],dh
add [bx+si],al
push dx
add [bx+si],al
add [si],bl
add [bx+si],al
add [bp+si],dl
add [bx+di],al
add [bx+si+0x0],cl
add [bx+si],al
add [bx+si],al
add [bp+di],cl
add [bx+si],al
add [bx+di],dl
add [bp+di],al
add [bp+si+0x0],dl
add [bx+si],al
add [bx+si],al
add [bp+si],al
add [bx+si],al
add [bx+di],dl
add [si],al
add [bx+0x0],bl
add [bp+0x0],ch
add [bx+si],al
pop bx
add [bx+si],al
add [bp+si],dl
add [bx+di],al
add [bp+di+0x0],dh
add [si],al
add [bx+si],al
add [si],al
add [bx+si],al
add [bx+di],dl
add [si],al
add [bx+si],al
bound bp,[bx+0x6f]
jz 0x375
arpl [gs:si+0x6f],si
jc 0x336
arpl [bx+si],ax
pop di
jnc 0x381
popa
jc 0x384
add [bp+si+0x6f],ah
outsw
jz 0x389
arpl [gs:si+0x6f],si
jc 0x37b
insw
popa
imul bp,[bp+0x0],word 0x4441
push si
pop di
dec bp
push bx
inc di
add [bx+di+0x73],ah
insw
pop di
bound bp,[bx+di+0x6f]
jnc 0x391
jnc 0x399
jz 0x395
arpl [di+0x72],si
jnc 0x3aa
jc 0x39c
jo 0x3ae
jnc 0x341
popa
jnc 0x3b1
pop di
bound bp,[bx+di+0x6f]
jnc 0x3a9
arpl [si+0x65],bp
popa
jc 0x3af
jnc 0x3b5
jc 0x3b9
gs outsb
add [bx+di+0x73],ah
insw
pop di
bound bp,[bx+di+0x6f]
jnc 0x3bf
jnc 0x3c7
jz 0x3c3
jo 0x3d8
imul bp,[bp+0x74],word 0x635f
outsw
insb
outsw
jc 0x370
popa
jnc 0x3e0
pop di
bound bp,[bx+di+0x6f]
jnc 0x3d8
jo 0x3ed
imul bp,[bp+0x74],word 0x635f
push word 0x7261
add [bx+si+0x45],cl
dec sp
dec sp
dec di
pop di
dec bp
push bx
inc di
add [bx+0x73],bl
arpl [bp+si+0x6f],si
insb
insb
pop di
jo 0x407
jnc 0x3f9
add [bx+si+0x72],dh
imul bp,[bp+0x74],word 0x685f
imul bx,[bx+0x6d],word 0x6773
pop di
jnc 0x40d
jc 0x41b
insb
insb
add [si+0x65],ah
insb
popa
jns 0x3b5
add [bx+si],al
add [si],dl
add [bx+si],al
add [si],dl
or [bx+si],ax
add [bx+0x0],dh
add [bx+si],al
adc ax,0xe
add [bx+0x0],bh
add [bx+si],al
adc al,0x10
add [bx+si],al
test [bx+si],ax
add [bx+si],al
adc al,0xf
add [bx+si],al
lea ax,[bx+si]
add [bx+si],al
adc al,0x10
add [bx+si],al
xchg ax,dx
add [bx+si],al
add [si],dl
sldt [bx+si]
cbw
add [bx+si],al
add [di],dl
push cs
add [bx+si],al
mov al,[0x0]
add [si],dl
adc [bx+si],al
add [bx+di+0x0],ch
add [si],dl
sldt [bx+si]
scasb
add [bx+si],al
add [si],dl
adc [bx+si],al
add [si+0x0],dh
add [si],dl
adc [bx+si],al
add [bx+di+0x0],bh
add [si],dl
adc [bx+si],al
add dl,al
add [bx+si],al
add [si],dl
adc [bx+si],al
add ah,cl
add [bx+si],al
add [di],dl
or al,0x0
add bl,dl
add [bx+si],al
add [di],dl
or ax,[bx+si]
add ch,bl
add [bx+si],al
add [di],dl
or ax,[bx+si]
add ch,ah
add [bx+si],al
add [di],dl
or ax,0x0
in ax,dx
add [bx+si],al
add [di],dl
push cs
add [bx+si],al
hlt
add [bx+si],al
add [si],dl
adc al,[bx+si]
add ah,bh
add [bx+si],al
add [si],dl
adc al,[bx+si]
add [bp+si],al
addw [bx+si],ax
add [si],dl
adc al,[bx+si]
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx],bl
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [0x0],al
add [bx+si],al
add [bx+si],al
add [si],dh
add [bx+si],al
add [bp+di],cl
addw [bx+si],ax
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bp+di],bl
add [bx+si],al
add [bx+di],cl
add [bx+si],al
add [bx+si+0x0],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
mov ax,0x3
add [bx+si+0x0],ch
add [bx+di],cl
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [si],al
add [bx+si],al
addw [bx+si],cl
add [bx+si],al
add [di],ah
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bp+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si+0x1],al
add [bx+si],al
or ax,[bx+si]
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add al,0x0
add [bx+si],al
add [bx+si],al
add [bx+si],al
sub ax,[bx+si]
add [bx+si],al
or [bx+si],al
add [bx+si],al
add ax,[bx+si]
add [bx+si],al
add [bx+si],al
add [bx+si],al
dpushc sp
addw [bx+si],ax
addw [bx+si],cl
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
addw [bx+si],dh
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bp+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [si+0x1],cl
add [bx+si],al
sbb al,[bx+si]
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add al,0x0
add [bx+si],al
add [bx+si],al
add [bx+si],al
cmp [bx+si],al
add [bx+si],al
addw [bx+si],ax
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
addw [bx+si],ax
add [bp+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si+0x0],cl
add [bx+si],al
addw [bx+si],ax
add [bx+si],al
xor [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
push word 0x1
add [bp+di],dl
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bx+di],dl
add [bx+si],al
add [bp+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bp+di+0x1],bh
add [bx+si],al
push cx
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bp+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add ah,cl
addw [bx+si],ax
addw [bx+si],dh
addw [bx+si],ax
add [bp+si],cl
add [bx+si],al
addw [bx+si],cl
add [bx+si],al
add [si],al
add [bx+si],al
addw [bx+si],dl
add [bx+si],al
add [bx+di],cl
add [bx+si],al
add [bp+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add ah,bh
add al,[bx+si]
add [bx+di+0x0],bh
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
add [bx+di],al
add [bx+si],al
add [bx+si],al
add [bx+si],al
db 0x00
