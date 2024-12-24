# common.mk

# Disable default rules by overriding them with empty rules
.SUFFIXES:

all: run

.PHONY : run build net clean run_under_av check_asm

SHELL=/usr/bin/bash

BOOTSECTOR=bootsector
FILE_THIS=Makefile ../common.mk

# Common rules and variables
CC = i686-elf-gcc
CC_FLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
        -nostdlib -nostdinc -fno-asynchronous-unwind-tables \
        -fno-builtin -fno-stack-protector -mno-mmx -mno-sse
C2O_FLAGS = $(CC_FLAGS) -o 
C2ASM_FLAGS = $(CC_FLAGS) -O0 -S -o 
LD = i686-elf-ld
LD_FLAGS = -T ../c/linker.ld --oformat binary -s

# Define FILE_SOURCE and TOC_SOURCE
FILE_SOURCE=$(BOOTSECTOR)$(LANG_SUFFIX)
FILE_SOURCE_DEPENDENCY=common_bios$(LANG_SUFFIX)
TOC_SOURCE=$(FILE_SOURCE).c

# Rule to build TOC_SOURCE
$(TOC_SOURCE): $(FILE_SOURCE) $(FILE_SOURCE_DEPENDENCY) $(FILE_SOURCE_ADDITIONAL_DEPENDENCY) $(FILE_THIS)
	@echo "# Compile $(FILE_TARGET) by $(COMPILER)."
	@$(COMPILER) $(COMPILER2C_FLAGS)$(TOC_SOURCE) $(FILE_SOURCE)

# Filter C
TOC_SOURCE_FILTERED=$(BOOTSECTOR).c
FILTER=awk
SCRIPT_FILTER_TOC_SOURCE=filter_toc_source.awk
$(TOC_SOURCE_FILTERED): $(TOC_SOURCE) $(SCRIPT_FILTER_TOC_SOURCE) $(FILE_THIS)
	@echo "# Filter out unneeded code and add necessary reused functions and $(BOOTSECTOR) signature from ../c/$(BOOTSECTOR).h by $(FILTER)."
	@$(FILTER) -f $(SCRIPT_FILTER_TOC_SOURCE) $(TOC_SOURCE) > $(TOC_SOURCE_FILTERED)

# C to O
OBJ_INTERMIDIATE=$(BOOTSECTOR).o
TOASM_SOURCE=$(BOOTSECTOR).s
C_DEPENDENCIES=../c/common_prefix.h ../c/bootsector.h ../c/common_suffix.h
C_LANG_DEPENDENCIES=common_prefix$(LANG_SUFFIX).h common_suffix$(LANG_SUFFIX).h $(C_DEPENDENCIES)
$(OBJ_INTERMIDIATE): $(TOC_SOURCE_FILTERED) $(C_LANG_DEPENDENCIES) $(FILE_THIS)
	@echo "# Compile processed c code to object by $(CC)."
	@$(CC) $(C2O_FLAGS)$(OBJ_INTERMIDIATE) -c $(TOC_SOURCE_FILTERED)

$(TOASM_SOURCE): $(TOC_SOURCE_FILTERED) $(FILE_THIS)
	@echo "# Generate asm code for checking by $(CC)."
	@$(CC) $(C2ASM_FLAGS)$(TOASM_SOURCE) $(TOC_SOURCE_FILTERED)

# Link object to binary
FILE_TARGET=$(BOOTSECTOR).bin
$(FILE_TARGET): $(OBJ_INTERMIDIATE) $(FILE_THIS)
	@echo "# Link object to binary by $(LD)."
	@$(LD) $(LD_FLAGS) -o $(FILE_TARGET) $(OBJ_INTERMIDIATE)

# Verify and test scripts
SCRIPT_VERIFY=../verify_boot.sh
SCRIPT_TEST=../test.qemu.sh

# Build and run targets
build: $(FILE_TARGET) $(FILE_THIS)
	@echo "# Build $(FILE_TARGET) by $(COMPILER)/$(CC)/$(LD) succeeded!"
	@echo "# Verify $(FILE_TARGET) is valid $(BOOTSECTOR)."
	@$(SHELL) $(SCRIPT_VERIFY)

neat:
	rm -f *.o *.s *.c

clean: neat
	rm -f $(FILE_TARGET)

run: build
	@echo "# Run QEMU VM with 1M memory to load $(FILE_TARGET) as disk image for boot device"
	$(SHELL) $(SCRIPT_TEST)
