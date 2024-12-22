# Disable default rules by overriding them with empty rules
.SUFFIXES:

all: run

.PHONY : run build net clean run_under_av check_asm

SHELL=/usr/bin/bash

FILE_THIS=Makefile

# CI_PIPE_LINE_START
# 1. V to C
FILE_SOURCE=bootsector.v
TOC_SOURCE=$(FILE_SOURCE).c
COMPILER=v
COMPILER2C_FLAGS=-freestanding
$(TOC_SOURCE_FILTERED): $(FILE_SOURCE) $(FILE_THIS)
	@echo "# Compile $(FILE_TARGET) by $(COMPILER)."
	@$(COMPILER) $(COMPILER2C_FLAGS) -o $(TOC_SOURCE) $(FILE_SOURCE)

# 2. Filter C
TOC_SOURCE_FILTERED=bootsector.c
FILTER=sed
APPENDER=echo
$(TOC_SOURCE_FILTERED): $(TOC_SOURCE) $(FILE_THIS)
	@echo "# Filter out unneeded code and add necessary reused functions and bootsector signature from ../c/bootsector.h by $(FILTER) and $(APPENDER)."
	@$(FILTER) -n -E '/void main__start\(void\) \{/,/^\}/p; /^string _const_main__/p; /^\\s*_const_main__/s/_const_main__/string /p' $(TOC_SOURCE) > $(TOC_SOURCE_FILTERED)
	@$(FILTER) -i -E 's/([a-zA-Z_][a-zA-Z0-9_]*)\\.len/sizeof(\\1)/g' $(TOC_SOURCE_FILTERED)
	@$(FILTER) -i -E 's/\\(_const_main__([a-zA-Z0-9][_a-zA-Z0-9]*)\\.str\\)/\\(\\1\\)/g' $(TOC_SOURCE_FILTERED)
	@$(FILTER) -i -E 's/_const_main__//g; s/main__//g; s/\\bbios_([a-z][_a-z0-9_]*)/\\U&/g' $(TOC_SOURCE_FILTERED)
	@$(FILTER) -i "1i #include \"../c/bootsector.h\"\nASM_EPILOG;\nFN_BIOS_CLEAR_SCREEN;\nFN_BIOS_SET_CURSOR_POS__ROW_COL;\nDATA_BIOS_PARAM;\nFN_BIOS_PRINT_STRING__MSG_COLOR;\n#define VV_LOCAL_SYMBOL\n#define u8 unsigned char\ntypedef const char string[];\n#define _SLIT(s) s\n" $(TOC_SOURCE_FILTERED)
	@$(APPENDER) -e "void __attribute__((noreturn)) __attribute__((no_instrument_function)) bootsector_main(void) {\n\tstart();\n\tfor(;;) {}\n}\nEND_BOOTSECTOR\n" >> $(TOC_SOURCE_FILTERED)

# 3. C to O
OBJ_INTERMIDIATE=bootsector.o
TOASM_SOURCE=bootsector.s
CC = i686-elf-gcc
C2O_FLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse
C2ASM_FLAGS = $(C2O_FLAGS) -O0 -S 
$(OBJ_INTERMIDIATE): $(TOC_SOURCE_FILTERED) $(FILE_THIS)
	@echo "# Compile processed c code to object by $(CC)."
	@$(CC) $(C2O_FLAGS) -o $(OBJ_INTERMIDIATE) -c $(TOC_SOURCE_FILTERED)
$(TOASM_SOURCE): $(TOC_SOURCE_FILTERED) $(FILE_THIS)
	@echo "# Generate asm code for checking by $(CC)."
	@$(CC) $(C2ASM_FLAGS) -o $(TOASM_SOURCE) $(TOC_SOURCE_FILTERED)

LD=i686-elf-ld
LD_FLAGS=-T ../c/linker.ld --oformat binary -s

FILE_TARGET=bootsector.bin
$(FILE_TARGET): $(OBJ_INTERMIDIATE) $(FILE_THIS)
	@echo "# Link object to binary by $(LD)."
	@$(LD) $(LD_FLAGS) -o $(FILE_TARGET) $(OBJ_INTERMIDIATE)

SCRIPT_VERIFY=../verify_boot.sh
SCRIPT_TEST=../test.qemu.sh
SCRIPT_TEST_UNDER_AV=../test.under_av.qemu.sh
# CI_PIPE_LINE_END


check_asm: $(TOASM_SOURCE) $(FILE_THIS)
	@echo "# Opening file in Visual Studio Code... "
	@code $(TOASM_SOURCE)
	# @ls -l $(TOASM_SOURCE)

build: $(FILE_TARGET) $(FILE_THIS)
	@echo "# Build $(FILE_TARGET) by $(COMPILER)/$(CC)/$(LD) succeeded!"
	@echo "# Verify $(FILE_TARGET) is valid bootsector."
	@$(SHELL) $(SCRIPT_VERIFY)

neat:
	rm -f *.o *.s *.c

clean: neat
	rm -f $(FILE_TARGET)

run: build
	@echo "# Run QEMU VM with 1M memory to load bootsector.bin as disk image for boot device"
	$(SHELL) $(SCRIPT_TEST)

run_under_av: build
	@#../.pipe/pb_holder/target/release/pb_holder.exe f2p bootsector.pz tinyos_bootsector_provider
	$(SHELL) $(SCRIPT_TEST_UNDER_AV)
