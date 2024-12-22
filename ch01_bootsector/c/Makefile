.PONEY : build run clean

CC = i686-elf-gcc
CFLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse
ASMFLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse -O0 -S 
         
bootsector.o: bootsector.c bootsector.h Makefile
	$(CC) $(CFLAGS) -c bootsector.c -o bootsector.o
	$(CC) $(ASMFLAGS) -o bootsector.s bootsector.c

bootsector.bin: bootsector.o
	i686-elf-ld -T linker.ld --oformat binary -s -o bootsector.bin bootsector.o

build: bootsector.bin Makefile
	../dump.sh

clean:
	rm -f *.o *.bin *.elf

#pb_holder: ../.pipe/pb_holder/target/release/pb_holder.exe

run: build
	echo "run qemu load bootsector.bin as disk image for boot device"
	../test.qemu.sh

run_under_av: build
	#../.pipe/pb_holder/target/release/pb_holder.exe f2p bootsector.pz tinyos_bootsector_provider
	../test.under_av.qemu.sh