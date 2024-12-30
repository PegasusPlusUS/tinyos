00000000  7F45              jg 0x47
00000002  4C                dec sp
00000003  46                inc si
00000004  0101              add [bx+di],ax
00000006  0100              add [bx+si],ax
00000008  0000              add [bx+si],al
0000000A  0000              add [bx+si],al
0000000C  0000              add [bx+si],al
0000000E  0000              add [bx+si],al
00000010  0100              add [bx+si],ax
00000012  0300              add ax,[bx+si]
00000014  0100              add [bx+si],ax
00000016  0000              add [bx+si],al
00000018  0000              add [bx+si],al
0000001A  0000              add [bx+si],al
0000001C  0000              add [bx+si],al
0000001E  0000              add [bx+si],al
00000020  60                pusha
00000021  0400              add al,0x0
00000023  0000              add [bx+si],al
00000025  0000              add [bx+si],al
00000027  0034              add [si],dh
00000029  0000              add [bx+si],al
0000002B  0000              add [bx+si],al
0000002D  0028              add [bx+si],ch
0000002F  000B              add [bp+di],cl
00000031  0008              add [bx+si],cl
00000033  0031              add [bx+di],dh
00000035  C08ED88EC0        ror byte [bp-0x7128],byte 0xc0
0000003A  8EC8              mov cs,ax
0000003C  8ED0              mov ss,ax
0000003E  BCFF7B            mov sp,0x7bff
00000041  31C0              xor ax,ax
00000043  89E0              mov ax,sp
00000045  89C4              mov sp,ax
00000047  EA00000000        jmp 0x0:0x0
0000004C  60                pusha
0000004D  89E5              mov bp,sp
0000004F  B402              mov ah,0x2
00000051  8A7608            mov dh,[bp+0x8]
00000054  8A560C            mov dl,[bp+0xc]
00000057  B700              mov bh,0x0
00000059  CD10              int 0x10
0000005B  61                popa
0000005C  90                nop
0000005D  C3                ret
0000005E  89E5              mov bp,sp
00000060  60                pusha
00000061  B400              mov ah,0x0
00000063  B003              mov al,0x3
00000065  CD10              int 0x10
00000067  61                popa
00000068  90                nop
00000069  C3                ret
0000006A  60                pusha
0000006B  89E5              mov bp,sp
0000006D  83EC04            sub sp,byte +0x4
00000070  8B4608            mov ax,[bp+0x8]
00000073  8846FC            mov [bp-0x4],al
00000076  0FB646FC          movzx ax,[bp-0x4]
0000007A  B700              mov bh,0x0
0000007C  88C3              mov bl,al
0000007E  B400              mov ah,0x0
00000080  CD10              int 0x10
00000082  61                popa
00000083  90                nop
00000084  C9                leave
00000085  C3                ret
00000086  60                pusha
00000087  89E5              mov bp,sp
00000089  83EC04            sub sp,byte +0x4
0000008C  8B4608            mov ax,[bp+0x8]
0000008F  8846FC            mov [bp-0x4],al
00000092  0FB646FC          movzx ax,[bp-0x4]
00000096  88C0              mov al,al
00000098  B409              mov ah,0x9
0000009A  B90100            mov cx,0x1
0000009D  CD10              int 0x10
0000009F  61                popa
000000A0  90                nop
000000A1  C3                ret
000000A2  55                push bp
000000A3  89E5              mov bp,sp
000000A5  83EC10            sub sp,byte +0x10
000000A8  6A48              push byte +0x48
000000AA  E8FEFF            call 0xab
000000AD  83C404            add sp,byte +0x4
000000B0  0FB6060000        movzx ax,[0x0]
000000B5  98                cbw
000000B6  0FB6060000        movzx ax,[0x0]
000000BB  8846FF            mov [bp-0x1],al
000000BE  0FB6060000        movzx ax,[0x0]
000000C3  98                cbw
000000C4  C606000000        mov byte [0x0],0x0
000000C9  6A69              push byte +0x69
000000CB  E8FEFF            call 0xcc
000000CE  83C404            add sp,byte +0x4
000000D1  0FB6060000        movzx ax,[0x0]
000000D6  98                cbw
000000D7  0FB656FF          movzx dx,[bp-0x1]
000000DB  88160000          mov [0x0],dl
000000DF  0FB6060000        movzx ax,[0x0]
000000E4  83C001            add ax,byte +0x1
000000E7  A30000            mov [0x0],ax
000000EA  0FB6060000        movzx ax,[0x0]
000000EF  83F80A            cmp ax,byte +0xa
000000F2  7606              jna 0xfa
000000F4  C70600000000      mov word [0x0],0x0
000000FA  90                nop
000000FB  C9                leave
000000FC  C3                ret
000000FD  89E5              mov bp,sp
000000FF  E8FEFF            call 0x100
00000102  6A00              push byte +0x0
00000104  6A0C              push byte +0xc
00000106  E8FEFF            call 0x107
00000109  83C408            add sp,byte +0x8
0000010C  6A05              push byte +0x5
0000010E  6A0C              push byte +0xc
00000110  E8FEFF            call 0x111
00000113  83C408            add sp,byte +0x8
00000116  6A0F              push byte +0xf
00000118  E8FEFF            call 0x119
0000011B  83C404            add sp,byte +0x4
0000011E  6A43              push byte +0x43
00000120  E8FEFF            call 0x121
00000123  83C404            add sp,byte +0x4
00000126  C70600000000      mov word [0x0],0x0
0000012C  EB01              jmp short 0x12f
0000012E  90                nop
0000012F  A10000            mov ax,[0x0]
00000132  83C001            add ax,byte +0x1
00000135  A30000            mov [0x0],ax
00000138  3DFF7C            cmp ax,0x7cff
0000013B  7EF1              jng 0x12e
0000013D  EBE7              jmp short 0x126
0000013F  0020              add [bx+si],ah
00000141  48                dec ax
00000142  692C2067          imul bp,[si],word 0x6720
00000146  636321            arpl [bp+di+0x21],sp
00000149  2000              and [bx+si],al
0000014B  004769            add [bx+0x69],al
0000014E  7448              jz 0x198
00000150  7562              jnz 0x1b4
00000152  3A5065            cmp dl,[bx+si+0x65]
00000155  6761              a32 popa
00000157  7375              jnc 0x1ce
00000159  7350              jnc 0x1ab
0000015B  6C                insb
0000015C  7573              jnz 0x1d1
0000015E  2F                das
0000015F  7469              jz 0x1ca
00000161  6E                outsb
00000162  796F              jns 0x1d3
00000164  7300              jnc 0x166
00000166  55                push bp
00000167  AA                stosb
00000168  004743            add [bx+0x43],al
0000016B  43                inc bx
0000016C  3A20              cmp ah,[bx+si]
0000016E  28474E            sub [bx+0x4e],al
00000171  55                push bp
00000172  2920              sub [bx+si],sp
00000174  3133              xor [bp+di],si
00000176  2E322E3000        xor ch,[cs:0x30]
0000017B  002E7379          add [0x7973],ch
0000017F  6D                insw
00000180  7461              jz 0x1e3
00000182  6200              bound ax,[bx+si]
00000184  2E7374            cs jnc 0x1fb
00000187  7274              jc 0x1fd
00000189  61                popa
0000018A  6200              bound ax,[bx+si]
0000018C  2E7368            cs jnc 0x1f7
0000018F  7374              jnc 0x205
00000191  7274              jc 0x207
00000193  61                popa
00000194  6200              bound ax,[bx+si]
00000196  2E7265            cs jc 0x1fe
00000199  6C                insb
0000019A  2E7465            cs jz 0x202
0000019D  7874              js 0x213
0000019F  002E6461          add [0x6164],ch
000001A3  7461              jz 0x206
000001A5  002E6273          add [0x7362],ch
000001A9  7300              jnc 0x1ab
000001AB  2E726F            cs jc 0x21d
000001AE  6461              fs popa
000001B0  7461              jz 0x213
000001B2  002E626F          add [0x6f62],ch
000001B6  6F                outsw
000001B7  745F              jz 0x218
000001B9  7369              jnc 0x224
000001BB  676E              a32 outsb
000001BD  61                popa
000001BE  7475              jz 0x235
000001C0  7265              jc 0x227
000001C2  002E636F          add [0x6f63],ch
000001C6  6D                insw
000001C7  6D                insw
000001C8  656E              gs outsb
000001CA  7400              jz 0x1cc
000001CC  0000              add [bx+si],al
000001CE  0000              add [bx+si],al
000001D0  0000              add [bx+si],al
000001D2  0000              add [bx+si],al
000001D4  0000              add [bx+si],al
000001D6  0000              add [bx+si],al
000001D8  0000              add [bx+si],al
000001DA  0000              add [bx+si],al
000001DC  0100              add [bx+si],ax
000001DE  0000              add [bx+si],al
000001E0  0000              add [bx+si],al
000001E2  0000              add [bx+si],al
000001E4  0000              add [bx+si],al
000001E6  0000              add [bx+si],al
000001E8  0400              add al,0x0
000001EA  F1                int1
000001EB  FF00              inc word [bx+si]
000001ED  0000              add [bx+si],al
000001EF  0000              add [bx+si],al
000001F1  0000              add [bx+si],al
000001F3  0000              add [bx+si],al
000001F5  0000              add [bx+si],al
000001F7  0003              add [bp+di],al
000001F9  0001              add [bx+di],al
000001FB  0000              add [bx+si],al
000001FD  0000              add [bx+si],al
000001FF  0000              add [bx+si],al
00000201  0000              add [bx+si],al
00000203  0000              add [bx+si],al
00000205  0000              add [bx+si],al
00000207  0003              add [bp+di],al
00000209  0003              add [bp+di],al
0000020B  0000              add [bx+si],al
0000020D  0000              add [bx+si],al
0000020F  0000              add [bx+si],al
00000211  0000              add [bx+si],al
00000213  0000              add [bx+si],al
00000215  0000              add [bx+si],al
00000217  0003              add [bp+di],al
00000219  0004              add [si],al
0000021B  0000              add [bx+si],al
0000021D  0000              add [bx+si],al
0000021F  0000              add [bx+si],al
00000221  0000              add [bx+si],al
00000223  0000              add [bx+si],al
00000225  0000              add [bx+si],al
00000227  0003              add [bp+di],al
00000229  0005              add [di],al
0000022B  0000              add [bx+si],al
0000022D  0000              add [bx+si],al
0000022F  0000              add [bx+si],al
00000231  0000              add [bx+si],al
00000233  0000              add [bx+si],al
00000235  0000              add [bx+si],al
00000237  0003              add [bp+di],al
00000239  00060000          add [0x0],al
0000023D  0000              add [bx+si],al
0000023F  0000              add [bx+si],al
00000241  0000              add [bx+si],al
00000243  0000              add [bx+si],al
00000245  0000              add [bx+si],al
00000247  0003              add [bp+di],al
00000249  0007              add [bx],al
0000024B  000E0000          add [0x0],cl
0000024F  0000              add [bx+si],al
00000251  0000              add [bx+si],al
00000253  0000              add [bx+si],al
00000255  0000              add [bx+si],al
00000257  0010              add [bx+si],dl
00000259  0001              add [bx+di],al
0000025B  0015              add [di],dl
0000025D  0000              add [bx+si],al
0000025F  00C9              add cl,cl
00000261  0000              add [bx+si],al
00000263  004200            add [bp+si+0x0],al
00000266  0000              add [bx+si],al
00000268  1200              adc al,[bx+si]
0000026A  0100              add [bx+si],ax
0000026C  250000            and ax,0x0
0000026F  0000              add [bx+si],al
00000271  0000              add [bx+si],al
00000273  001A              add [bp+si],bl
00000275  0000              add [bx+si],al
00000277  0011              add [bx+di],dl
00000279  0005              add [di],al
0000027B  002D              add [di],ch
0000027D  0000              add [bx+si],al
0000027F  0018              add [bx+si],bl
00000281  0000              add [bx+si],al
00000283  0012              add [bp+si],dl
00000285  0000              add [bx+si],al
00000287  0012              add [bp+si],dl
00000289  0001              add [bx+di],al
0000028B  004500            add [di+0x0],al
0000028E  0000              add [bx+si],al
00000290  2A00              sub al,[bx+si]
00000292  0000              add [bx+si],al
00000294  0C00              or al,0x0
00000296  0000              add [bx+si],al
00000298  1200              adc al,[bx+si]
0000029A  0100              add [bx+si],ax
0000029C  5B                pop bx
0000029D  0000              add [bx+si],al
0000029F  00360000          add [0x0],dh
000002A3  001C              add [si],bl
000002A5  0000              add [bx+si],al
000002A7  0012              add [bp+si],dl
000002A9  0001              add [bx+di],al
000002AB  007400            add [si+0x0],dh
000002AE  0000              add [bx+si],al
000002B0  52                push dx
000002B1  0000              add [bx+si],al
000002B3  001C              add [si],bl
000002B5  0000              add [bx+si],al
000002B7  0012              add [bp+si],dl
000002B9  0001              add [bx+di],al
000002BB  00880000          add [bx+si+0x0],cl
000002BF  0000              add [bx+si],al
000002C1  0000              add [bx+si],al
000002C3  000B              add [bp+di],cl
000002C5  0000              add [bx+si],al
000002C7  0011              add [bx+di],dl
000002C9  0003              add [bp+di],al
000002CB  00920000          add [bp+si+0x0],dl
000002CF  0000              add [bx+si],al
000002D1  0000              add [bx+si],al
000002D3  0002              add [bp+si],al
000002D5  0000              add [bx+si],al
000002D7  0011              add [bx+di],dl
000002D9  0004              add [si],al
000002DB  009F0000          add [bx+0x0],bl
000002DF  006E00            add [bp+0x0],ch
000002E2  0000              add [bx+si],al
000002E4  5B                pop bx
000002E5  0000              add [bx+si],al
000002E7  0012              add [bp+si],dl
000002E9  0001              add [bx+di],al
000002EB  00B30000          add [bp+di+0x0],dh
000002EF  0004              add [si],al
000002F1  0000              add [bx+si],al
000002F3  0004              add [si],al
000002F5  0000              add [bx+si],al
000002F7  0011              add [bx+di],dl
000002F9  0004              add [si],al
000002FB  0000              add [bx+si],al
000002FD  626F6F            bound bp,[bx+0x6f]
00000300  7473              jz 0x375
00000302  6563746F          arpl [gs:si+0x6f],si
00000306  722E              jc 0x336
00000308  6300              arpl [bx+si],ax
0000030A  5F                pop di
0000030B  7374              jnc 0x381
0000030D  61                popa
0000030E  7274              jc 0x384
00000310  00626F            add [bp+si+0x6f],ah
00000313  6F                outsw
00000314  7473              jz 0x389
00000316  6563746F          arpl [gs:si+0x6f],si
0000031A  725F              jc 0x37b
0000031C  6D                insw
0000031D  61                popa
0000031E  696E004144        imul bp,[bp+0x0],word 0x4441
00000323  56                push si
00000324  5F                pop di
00000325  4D                dec bp
00000326  53                push bx
00000327  47                inc di
00000328  006173            add [bx+di+0x73],ah
0000032B  6D                insw
0000032C  5F                pop di
0000032D  62696F            bound bp,[bx+di+0x6f]
00000330  735F              jnc 0x391
00000332  7365              jnc 0x399
00000334  745F              jz 0x395
00000336  637572            arpl [di+0x72],si
00000339  736F              jnc 0x3aa
0000033B  725F              jc 0x39c
0000033D  706F              jo 0x3ae
0000033F  7300              jnc 0x341
00000341  61                popa
00000342  736D              jnc 0x3b1
00000344  5F                pop di
00000345  62696F            bound bp,[bx+di+0x6f]
00000348  735F              jnc 0x3a9
0000034A  636C65            arpl [si+0x65],bp
0000034D  61                popa
0000034E  725F              jc 0x3af
00000350  7363              jnc 0x3b5
00000352  7265              jc 0x3b9
00000354  656E              gs outsb
00000356  006173            add [bx+di+0x73],ah
00000359  6D                insw
0000035A  5F                pop di
0000035B  62696F            bound bp,[bx+di+0x6f]
0000035E  735F              jnc 0x3bf
00000360  7365              jnc 0x3c7
00000362  745F              jz 0x3c3
00000364  7072              jo 0x3d8
00000366  696E745F63        imul bp,[bp+0x74],word 0x635f
0000036B  6F                outsw
0000036C  6C                insb
0000036D  6F                outsw
0000036E  7200              jc 0x370
00000370  61                popa
00000371  736D              jnc 0x3e0
00000373  5F                pop di
00000374  62696F            bound bp,[bx+di+0x6f]
00000377  735F              jnc 0x3d8
00000379  7072              jo 0x3ed
0000037B  696E745F63        imul bp,[bp+0x74],word 0x635f
00000380  686172            push word 0x7261
00000383  004845            add [bx+si+0x45],cl
00000386  4C                dec sp
00000387  4C                dec sp
00000388  4F                dec di
00000389  5F                pop di
0000038A  4D                dec bp
0000038B  53                push bx
0000038C  47                inc di
0000038D  005F73            add [bx+0x73],bl
00000390  63726F            arpl [bp+si+0x6f],si
00000393  6C                insb
00000394  6C                insb
00000395  5F                pop di
00000396  706F              jo 0x407
00000398  735F              jnc 0x3f9
0000039A  007072            add [bx+si+0x72],dh
0000039D  696E745F68        imul bp,[bp+0x74],word 0x685f
000003A2  695F6D7367        imul bx,[bx+0x6d],word 0x6773
000003A7  5F                pop di
000003A8  7363              jnc 0x40d
000003AA  726F              jc 0x41b
000003AC  6C                insb
000003AD  6C                insb
000003AE  006465            add [si+0x65],ah
000003B1  6C                insb
000003B2  61                popa
000003B3  7900              jns 0x3b5
000003B5  0000              add [bx+si],al
000003B7  0014              add [si],dl
000003B9  0000              add [bx+si],al
000003BB  0014              add [si],dl
000003BD  0900              or [bx+si],ax
000003BF  007700            add [bx+0x0],dh
000003C2  0000              add [bx+si],al
000003C4  150E00            adc ax,0xe
000003C7  007F00            add [bx+0x0],bh
000003CA  0000              add [bx+si],al
000003CC  1410              adc al,0x10
000003CE  0000              add [bx+si],al
000003D0  8500              test [bx+si],ax
000003D2  0000              add [bx+si],al
000003D4  140F              adc al,0xf
000003D6  0000              add [bx+si],al
000003D8  8D00              lea ax,[bx+si]
000003DA  0000              add [bx+si],al
000003DC  1410              adc al,0x10
000003DE  0000              add [bx+si],al
000003E0  92                xchg ax,dx
000003E1  0000              add [bx+si],al
000003E3  0014              add [si],dl
000003E5  0F0000            sldt [bx+si]
000003E8  98                cbw
000003E9  0000              add [bx+si],al
000003EB  0015              add [di],dl
000003ED  0E                push cs
000003EE  0000              add [bx+si],al
000003F0  A00000            mov al,[0x0]
000003F3  0014              add [si],dl
000003F5  1000              adc [bx+si],al
000003F7  00A90000          add [bx+di+0x0],ch
000003FB  0014              add [si],dl
000003FD  0F0000            sldt [bx+si]
00000400  AE                scasb
00000401  0000              add [bx+si],al
00000403  0014              add [si],dl
00000405  1000              adc [bx+si],al
00000407  00B40000          add [si+0x0],dh
0000040B  0014              add [si],dl
0000040D  1000              adc [bx+si],al
0000040F  00B90000          add [bx+di+0x0],bh
00000413  0014              add [si],dl
00000415  1000              adc [bx+si],al
00000417  00C2              add dl,al
00000419  0000              add [bx+si],al
0000041B  0014              add [si],dl
0000041D  1000              adc [bx+si],al
0000041F  00CC              add ah,cl
00000421  0000              add [bx+si],al
00000423  0015              add [di],dl
00000425  0C00              or al,0x0
00000427  00D3              add bl,dl
00000429  0000              add [bx+si],al
0000042B  0015              add [di],dl
0000042D  0B00              or ax,[bx+si]
0000042F  00DD              add ch,bl
00000431  0000              add [bx+si],al
00000433  0015              add [di],dl
00000435  0B00              or ax,[bx+si]
00000437  00E5              add ch,ah
00000439  0000              add [bx+si],al
0000043B  0015              add [di],dl
0000043D  0D0000            or ax,0x0
00000440  ED                in ax,dx
00000441  0000              add [bx+si],al
00000443  0015              add [di],dl
00000445  0E                push cs
00000446  0000              add [bx+si],al
00000448  F4                hlt
00000449  0000              add [bx+si],al
0000044B  0014              add [si],dl
0000044D  1200              adc al,[bx+si]
0000044F  00FC              add ah,bh
00000451  0000              add [bx+si],al
00000453  0014              add [si],dl
00000455  1200              adc al,[bx+si]
00000457  0002              add [bp+si],al
00000459  0100              add [bx+si],ax
0000045B  0014              add [si],dl
0000045D  1200              adc al,[bx+si]
0000045F  0000              add [bx+si],al
00000461  0000              add [bx+si],al
00000463  0000              add [bx+si],al
00000465  0000              add [bx+si],al
00000467  0000              add [bx+si],al
00000469  0000              add [bx+si],al
0000046B  0000              add [bx+si],al
0000046D  0000              add [bx+si],al
0000046F  0000              add [bx+si],al
00000471  0000              add [bx+si],al
00000473  0000              add [bx+si],al
00000475  0000              add [bx+si],al
00000477  0000              add [bx+si],al
00000479  0000              add [bx+si],al
0000047B  0000              add [bx+si],al
0000047D  0000              add [bx+si],al
0000047F  0000              add [bx+si],al
00000481  0000              add [bx+si],al
00000483  0000              add [bx+si],al
00000485  0000              add [bx+si],al
00000487  001F              add [bx],bl
00000489  0000              add [bx+si],al
0000048B  0001              add [bx+di],al
0000048D  0000              add [bx+si],al
0000048F  00060000          add [0x0],al
00000493  0000              add [bx+si],al
00000495  0000              add [bx+si],al
00000497  0034              add [si],dh
00000499  0000              add [bx+si],al
0000049B  000B              add [bp+di],cl
0000049D  0100              add [bx+si],ax
0000049F  0000              add [bx+si],al
000004A1  0000              add [bx+si],al
000004A3  0000              add [bx+si],al
000004A5  0000              add [bx+si],al
000004A7  0001              add [bx+di],al
000004A9  0000              add [bx+si],al
000004AB  0000              add [bx+si],al
000004AD  0000              add [bx+si],al
000004AF  001B              add [bp+di],bl
000004B1  0000              add [bx+si],al
000004B3  0009              add [bx+di],cl
000004B5  0000              add [bx+si],al
000004B7  004000            add [bx+si+0x0],al
000004BA  0000              add [bx+si],al
000004BC  0000              add [bx+si],al
000004BE  0000              add [bx+si],al
000004C0  B80300            mov ax,0x3
000004C3  00A80000          add [bx+si+0x0],ch
000004C7  0009              add [bx+di],cl
000004C9  0000              add [bx+si],al
000004CB  0001              add [bx+di],al
000004CD  0000              add [bx+si],al
000004CF  0004              add [si],al
000004D1  0000              add [bx+si],al
000004D3  0008              add [bx+si],cl
000004D5  0000              add [bx+si],al
000004D7  0025              add [di],ah
000004D9  0000              add [bx+si],al
000004DB  0001              add [bx+di],al
000004DD  0000              add [bx+si],al
000004DF  0003              add [bp+di],al
000004E1  0000              add [bx+si],al
000004E3  0000              add [bx+si],al
000004E5  0000              add [bx+si],al
000004E7  004001            add [bx+si+0x1],al
000004EA  0000              add [bx+si],al
000004EC  0B00              or ax,[bx+si]
000004EE  0000              add [bx+si],al
000004F0  0000              add [bx+si],al
000004F2  0000              add [bx+si],al
000004F4  0000              add [bx+si],al
000004F6  0000              add [bx+si],al
000004F8  0400              add al,0x0
000004FA  0000              add [bx+si],al
000004FC  0000              add [bx+si],al
000004FE  0000              add [bx+si],al
00000500  2B00              sub ax,[bx+si]
00000502  0000              add [bx+si],al
00000504  0800              or [bx+si],al
00000506  0000              add [bx+si],al
00000508  0300              add ax,[bx+si]
0000050A  0000              add [bx+si],al
0000050C  0000              add [bx+si],al
0000050E  0000              add [bx+si],al
00000510  4C                dpushc sp
00000511  0100              add [bx+si],ax
00000513  0008              add [bx+si],cl
00000515  0000              add [bx+si],al
00000517  0000              add [bx+si],al
00000519  0000              add [bx+si],al
0000051B  0000              add [bx+si],al
0000051D  0000              add [bx+si],al
0000051F  0004              add [si],al
00000521  0000              add [bx+si],al
00000523  0000              add [bx+si],al
00000525  0000              add [bx+si],al
00000527  0030              add [bx+si],dh
00000529  0000              add [bx+si],al
0000052B  0001              add [bx+di],al
0000052D  0000              add [bx+si],al
0000052F  0002              add [bp+si],al
00000531  0000              add [bx+si],al
00000533  0000              add [bx+si],al
00000535  0000              add [bx+si],al
00000537  004C01            add [si+0x1],cl
0000053A  0000              add [bx+si],al
0000053C  1A00              sbb al,[bx+si]
0000053E  0000              add [bx+si],al
00000540  0000              add [bx+si],al
00000542  0000              add [bx+si],al
00000544  0000              add [bx+si],al
00000546  0000              add [bx+si],al
00000548  0400              add al,0x0
0000054A  0000              add [bx+si],al
0000054C  0000              add [bx+si],al
0000054E  0000              add [bx+si],al
00000550  3800              cmp [bx+si],al
00000552  0000              add [bx+si],al
00000554  0100              add [bx+si],ax
00000556  0000              add [bx+si],al
00000558  0000              add [bx+si],al
0000055A  0000              add [bx+si],al
0000055C  0000              add [bx+si],al
0000055E  0000              add [bx+si],al
00000560  660100            add [bx+si],ax
00000563  0002              add [bp+si],al
00000565  0000              add [bx+si],al
00000567  0000              add [bx+si],al
00000569  0000              add [bx+si],al
0000056B  0000              add [bx+si],al
0000056D  0000              add [bx+si],al
0000056F  0001              add [bx+di],al
00000571  0000              add [bx+si],al
00000573  0000              add [bx+si],al
00000575  0000              add [bx+si],al
00000577  004800            add [bx+si+0x0],cl
0000057A  0000              add [bx+si],al
0000057C  0100              add [bx+si],ax
0000057E  0000              add [bx+si],al
00000580  3000              xor [bx+si],al
00000582  0000              add [bx+si],al
00000584  0000              add [bx+si],al
00000586  0000              add [bx+si],al
00000588  680100            push word 0x1
0000058B  0013              add [bp+di],dl
0000058D  0000              add [bx+si],al
0000058F  0000              add [bx+si],al
00000591  0000              add [bx+si],al
00000593  0000              add [bx+si],al
00000595  0000              add [bx+si],al
00000597  0001              add [bx+di],al
00000599  0000              add [bx+si],al
0000059B  0001              add [bx+di],al
0000059D  0000              add [bx+si],al
0000059F  0011              add [bx+di],dl
000005A1  0000              add [bx+si],al
000005A3  0003              add [bp+di],al
000005A5  0000              add [bx+si],al
000005A7  0000              add [bx+si],al
000005A9  0000              add [bx+si],al
000005AB  0000              add [bx+si],al
000005AD  0000              add [bx+si],al
000005AF  007B01            add [bp+di+0x1],bh
000005B2  0000              add [bx+si],al
000005B4  51                push cx
000005B5  0000              add [bx+si],al
000005B7  0000              add [bx+si],al
000005B9  0000              add [bx+si],al
000005BB  0000              add [bx+si],al
000005BD  0000              add [bx+si],al
000005BF  0001              add [bx+di],al
000005C1  0000              add [bx+si],al
000005C3  0000              add [bx+si],al
000005C5  0000              add [bx+si],al
000005C7  0001              add [bx+di],al
000005C9  0000              add [bx+si],al
000005CB  0002              add [bp+si],al
000005CD  0000              add [bx+si],al
000005CF  0000              add [bx+si],al
000005D1  0000              add [bx+si],al
000005D3  0000              add [bx+si],al
000005D5  0000              add [bx+si],al
000005D7  00CC              add ah,cl
000005D9  0100              add [bx+si],ax
000005DB  0030              add [bx+si],dh
000005DD  0100              add [bx+si],ax
000005DF  000A              add [bp+si],cl
000005E1  0000              add [bx+si],al
000005E3  0008              add [bx+si],cl
000005E5  0000              add [bx+si],al
000005E7  0004              add [si],al
000005E9  0000              add [bx+si],al
000005EB  0010              add [bx+si],dl
000005ED  0000              add [bx+si],al
000005EF  0009              add [bx+di],cl
000005F1  0000              add [bx+si],al
000005F3  0003              add [bp+di],al
000005F5  0000              add [bx+si],al
000005F7  0000              add [bx+si],al
000005F9  0000              add [bx+si],al
000005FB  0000              add [bx+si],al
000005FD  0000              add [bx+si],al
000005FF  00FC              add ah,bh
00000601  0200              add al,[bx+si]
00000603  00B90000          add [bx+di+0x0],bh
00000607  0000              add [bx+si],al
00000609  0000              add [bx+si],al
0000060B  0000              add [bx+si],al
0000060D  0000              add [bx+si],al
0000060F  0001              add [bx+di],al
00000611  0000              add [bx+si],al
00000613  0000              add [bx+si],al
00000615  0000              add [bx+si],al
00000617  00                db 0x00
