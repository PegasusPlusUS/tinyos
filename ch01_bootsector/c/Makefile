# CC = i686-elf-gcc
# CFLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
# 		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
# 		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse
# ASMFLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
# 		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
# 		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse -O0 -S 

# Disable default rules by overriding them with empty rules
.SUFFIXES:

all: run

.PHONY : run build net clean run_under_av check_asm

SHELL=/usr/bin/bash

BOOTSECTOR=bootsector
FILE_THIS=Makefile

# CI_PIPE_LINE_START
# # 1. C to C
FILE_SOURCE=$(BOOTSECTOR).c
FILE_SOURCE_DEPENDENCY=common_prefix.h bootsector.h common_suffix.h
#TOC_SOURCE=$(FILE_SOURCE).c
# COMPILER=v
# COMPILER2C_FLAGS=-freestanding
# $(TOC_SOURCE): $(FILE_SOURCE) $(FILE_SOURCE_DEPENDENCY) $(FILE_THIS)
# 	@echo "# Compile $(FILE_TARGET) by $(COMPILER)."
# 	@$(COMPILER) $(COMPILER2C_FLAGS) -o $(TOC_SOURCE) .

# # 2. Filter C
TOC_SOURCE_FILTERED=$(BOOTSECTOR).c
# FILTER=awk
# SCRIPT_FILTER_TOC_SOURCE=filter_toc_source.awk
# $(TOC_SOURCE_FILTERED): $(TOC_SOURCE) $(SCRIPT_FILTER_TOC_SOURCE) $(FILE_THIS)
# 	@echo "# Filter out unneeded code and add necessary reused functions and $(BOOTSECTOR) signature from ../c/$(BOOTSECTOR).h by $(FILTER)."
# 	@$(FILTER) -f $(SCRIPT_FILTER_TOC_SOURCE) $(TOC_SOURCE) > $(TOC_SOURCE_FILTERED)

# 3. C to O
OBJ_INTERMIDIATE=$(BOOTSECTOR).o
TOASM_SOURCE=$(BOOTSECTOR).s
CC = i686-elf-gcc
C2O_FLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
		-nostdlib -nostdinc -fno-asynchronous-unwind-tables \
		-fno-builtin -fno-stack-protector -mno-mmx -mno-sse
C2ASM_FLAGS = $(C2O_FLAGS) -O0 -S
C_DEPENDENCIES=common_prefix.h bootsector.h common_suffix.h
$(OBJ_INTERMIDIATE): $(TOC_SOURCE_FILTERED) $(C_DEPENDENCIES) $(FILE_THIS)
	@echo "# Compile c code to object by $(CC)."
	@$(CC) $(C2O_FLAGS) -o $(OBJ_INTERMIDIATE) -c $(TOC_SOURCE_FILTERED)
$(TOASM_SOURCE): $(TOC_SOURCE_FILTERED) $(FILE_THIS)
	@echo "# Generate asm code for checking by $(CC)."
	@$(CC) $(C2ASM_FLAGS) -o $(TOASM_SOURCE) $(TOC_SOURCE_FILTERED)

LD=i686-elf-ld
LD_FLAGS=-T linker.ld --oformat binary -s

FILE_TARGET=$(BOOTSECTOR).bin
$(FILE_TARGET): $(OBJ_INTERMIDIATE) $(FILE_THIS)
	@echo "# Link object to binary by $(LD)."
	@$(LD) $(LD_FLAGS) -o $(FILE_TARGET) $(OBJ_INTERMIDIATE)

SCRIPT_VERIFY=../verify_boot.sh
SCRIPT_TEST=../test.qemu.sh

FILE_TARGET_UNDER_AV=$(FILE_TARGET).pz
PB_HOLDER=../.pipe/pb_holder/target/release/pb_holder.exe
$(FILE_TARGET_UNDER_AV): $(OBJ_INTERMIDIATE) $(FILE_THIS)
	@echo "# Start $(PB_HOLDER) to pack $(FILE_TARGET) as $(FILE_TARGET_UNDER_AV)."
	@$(PB_HOLDER) p2f $(FILE_TARGET) $(FILE_TARGET_UNDER_AV)
	@echo "# Link object to binary by $(LD)."
	@$(LD) $(LD_FLAGS) -o $($(PB_HOLDER) p2f) $(OBJ_INTERMIDIATE)
SCRIPT_VERIFY_UNDER_AV=../verify_boot.under_av.sh
SCRIPT_TEST_UNDER_AV=../test.under_av.qemu.sh
# CI_PIPE_LINE_END


check_asm: $(TOASM_SOURCE) $(FILE_THIS)
	@echo "# Opening file in Visual Studio Code... "
	@code $(TOASM_SOURCE)
	# @ls -l $(TOASM_SOURCE)

build: $(FILE_TARGET) $(FILE_THIS)
	@echo "# Build $(FILE_TARGET) by $(COMPILER)/$(CC)/$(LD) succeeded!"
	@echo "# Verify $(FILE_TARGET) is valid $(BOOTSECTOR)."
	@$(SHELL) $(SCRIPT_VERIFY)

build_under_av: $(FILE_TARGET_UNDER_AV) $(FILE_THIS)
	@echo "# Build $(FILE_TARGET_UNDER_AV) by $(COMPILER)/$(CC)/$(LD)/$(PB_HOLDER) succeeded!"
	@echo "# Verify $(FILE_TARGET_UNDER_AV) is valid $(BOOTSECTOR)."
	@$(SHELL) $(SCRIPT_VERIFY_UNDER_AV)

neat:
	rm -f *.o *.s

clean: neat
	rm -f $(FILE_TARGET)

run: build
	@echo "# Run QEMU VM with 1M memory to load $(FILE_TARGET) as disk image for boot device"
	$(SHELL) $(SCRIPT_TEST)

run_under_av: build_under_av
	@#../.pipe/pb_holder/target/release/pb_holder.exe f2p bootsector.bin.pz tinyos_bootsector_provider
	$(SHELL) $(SCRIPT_TEST_UNDER_AV)
