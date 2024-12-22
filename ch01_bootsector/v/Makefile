# Disable default rules by overriding them with empty rules
.SUFFIXES:

all: run

.PHONY : run build net clean run_under_av check_asm

SHELL=/usr/bin/bash

TARGET=bootsector.bin
SOURCE=bootsector.v
TOC_SOURCE=bootsector.v.c
TOC_SOURCE_FILTERED=bootsector.c
TOASM_SOURCE=bootsector.s
OBJ_INTERMIDIATE=bootsector.o
COMPILER=v
COMPILER2C_FLAGS=-freestanding
CC = i686-elf-gcc
C2O_FLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse
C2ASM_FLAGS = $(C2O_FLAGS) -O0 -S 
LD=i686-elf-ld
LD_FLAGS=-T ../c/linker.ld --oformat binary -s
FILTER=sed
APPENDER=echo

bootsector.c: bootsector.v Makefile
	@echo "# Compile $(TARGET) by $(COMPILER)."
	@$(COMPILER) $(COMPILER2C_FLAGS) -o $(TOC_SOURCE) $(SOURCE)
	@echo "# Filter out unneeded code and add necessary reused functions and bootsector signature from ../c/bootsector.h by $(FILTER) and $(APPENDER)."
	@$(FILTER) -n -E '/void main__start\(void\) \{/,/^\}/p; /^string _const_main__/p; /^\\s*_const_main__/s/_const_main__/string /p' $(TOC_SOURCE) > $(TOC_SOURCE_FILTERED)
	@$(FILTER) -i -E 's/([a-zA-Z_][a-zA-Z0-9_]*)\\.len/sizeof(\\1)/g' $(TOC_SOURCE_FILTERED)
	@$(FILTER) -i -E 's/\\(_const_main__([a-zA-Z0-9][_a-zA-Z0-9]*)\\.str\\)/\\(\\1\\)/g' $(TOC_SOURCE_FILTERED)
	@$(FILTER) -i -E 's/_const_main__//g; s/main__//g; s/\\bbios_([a-z][_a-z0-9_]*)/\\U&/g' $(TOC_SOURCE_FILTERED)
	@$(FILTER) -i "1i #include \"../c/bootsector.h\"\nASM_EPILOG;\nFN_BIOS_CLEAR_SCREEN;\nFN_BIOS_SET_CURSOR_POS__ROW_COL;\nDATA_BIOS_PARAM;\nFN_BIOS_PRINT_STRING__MSG_COLOR;\n#define VV_LOCAL_SYMBOL\n#define u8 unsigned char\ntypedef const char string[];\n#define _SLIT(s) s\n" bootsector.c
	@$(APPENDER) -e "void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {\n\tstart();\n\tfor(;;) {}\n}\nEND_BOOTSECTOR\n" >> bootsector.c

bootsector.o: bootsector.c Makefile
	@echo "# Compile processed c code to object by $(CC)."
	@$(CC) $(C2O_FLAGS) -o bootsector.o -c bootsector.c

check_asm: bootsector.c Makefile
	@echo "# Generate asm code for checking by $(CC)."
	@$(CC) $(C2ASM_FLAGS) -o bootsector.s bootsector.c
	@echo "# Opening file in Visual Studio Code... "
	@code bootsector.s
	# @ls -l bootsector.s

$(TARGET): bootsector.o Makefile
	@echo "# Link object to binary by $(LD)."
	@$(LD) $(LD_FLAGS) -o $(TARGET) bootsector.o

build: $(TARGET) Makefile
	@echo "# Build $(TARGET) by $(COMPILER)/$(CC)/$(LD) succeeded!"
	@echo "# Verify $(TARGET) is valid bootsector."
	@$(SHELL) ../verify_boot.sh

neat:
	rm -f *.o *.s *.c

clean: neat
	rm -f bootsector.bin

run: build
	@echo "run qemu load bootsector.bin as disk image for boot device"
	$(SHELL) ../test.qemu.sh

run_under_av: build
	@#../.pipe/pb_holder/target/release/pb_holder.exe f2p bootsector.pz tinyos_bootsector_provider
	$(SHELL) ../test.under_av.qemu.sh
