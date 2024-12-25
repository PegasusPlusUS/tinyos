# common.mk
# TODO: Need IA16-elf-gcc, IA16-elf-ld, and IA16-elf-as, otherwise, function can not take param. Current BIOS_xxx are all macros,
# 	which are not function, they uses fixed static memory to pass param to asm functions, not stack (i686-elf-gcc has bug that uses 32bit stack register which cause trouble in bootsector 16bit real mode).
# Lang -> C path
# Lang -> lib.a path
# Lang -> ASM path
# Lang -> WASM path
# Lang -> LLVMIR path

# Disable default rules by overriding them with empty rules
.SUFFIXES:

all: run

.PHONY : run build neat clean run_under_av check_asm

SHELL ?= /usr/bin/bash

BOOTSECTOR=bootsector
FILES_BUILDRULES ?= Makefile ../common.mk

# Common rules and variables
CC = i686-elf-gcc
CC_FLAGS = -m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
        -nostdlib -nostdinc -fno-asynchronous-unwind-tables \
        -fno-builtin -fno-stack-protector -mno-mmx -mno-sse
C2O_FLAGS = $(CC_FLAGS) -o 
C2ASM_FLAGS = $(CC_FLAGS) -O0 -S -o 
LD = i686-elf-ld
LD_FLAGS = -T ../c/linker.ld --oformat binary -s

# CI_PIPE_LINE_START
# 1. Lang to C initial
# Define FILE_SOURCE and FILE_LANG_TOC_INITIAL_RESULT
FILE_SOURCE ?= $(BOOTSECTOR)$(LANG_SUFFIX)
FILES_SOURCE_DEPENDENCIES ?= common_bios$(LANG_SUFFIX)
FILE_LANG_TOC_INITIAL_RESULT ?= $(FILE_SOURCE).c
SCRIPT_LANG_TOC_POST_PROCESSING ?= echo "\# $(FILE_SOURCE) to $(FILE_LANG_TOC_INITIAL_RESULT) succeeded!"
# Rule to build FILE_LANG_TOC_INITIAL_RESULT
$(FILE_LANG_TOC_INITIAL_RESULT): $(FILE_SOURCE) $(FILES_SOURCE_DEPENDENCIES) $(FILES_SOURCE_ADDITIONAL_DEPENDENCY) $(FILES_BUILDRULES)
	@echo "# Compile $(FILE_TARGET) by $(EXE_LANG_TOC_COMPILER)."
	@$(EXE_LANG_TOC_COMPILER) $(LANG2C_FLAGS)$(FILE_LANG_TOC_INITIAL_RESULT) $(FILE_SOURCE)
	@$(SCRIPT_LANG_TOC_POST_PROCESSING)

# 2. Filter C initial to final
FILE_LANG_TOC_FINAL_RESULT=$(BOOTSECTOR).c
FILTER=awk
SCRIPT_FILTER_LANG_TOC=filter_toc_source.awk
$(FILE_LANG_TOC_FINAL_RESULT): $(FILE_LANG_TOC_INITIAL_RESULT) $(SCRIPT_FILTER_LANG_TOC) $(FILES_BUILDRULES)
	@echo "# Filter out unneeded code and add necessary reused functions and $(BOOTSECTOR) signature from ../c/$(BOOTSECTOR).h by $(FILTER)."
	@$(FILTER) -f $(SCRIPT_FILTER_LANG_TOC) $(FILE_LANG_TOC_INITIAL_RESULT) > $(FILE_LANG_TOC_FINAL_RESULT)

# 3.0 final C to O
FILE_OBJ_INTERMIDIATE=$(BOOTSECTOR).o
FILE_CTOASM_RESULT=$(BOOTSECTOR).s
C_DEPENDENCIES ?= ../c/common_prefix.h ../c/bootsector.h ../c/common_suffix.h
C_LANG_DEPENDENCIES ?= common_prefix$(LANG_SUFFIX).h common_suffix$(LANG_SUFFIX).h $(C_DEPENDENCIES)
$(FILE_OBJ_INTERMIDIATE): $(FILE_LANG_TOC_FINAL_RESULT) $(C_LANG_DEPENDENCIES) $(FILES_BUILDRULES)
	@echo "# Compile processed c code to object by $(CC)."
	@$(CC) $(C2O_FLAGS)$(FILE_OBJ_INTERMIDIATE) -c $(FILE_LANG_TOC_FINAL_RESULT)

# 3.1 optional final C to ASM
$(FILE_CTOASM_RESULT): $(FILE_LANG_TOC_FINAL_RESULT) $(FILES_BUILDRULES)
	@echo "# Generate asm code for checking by $(CC)."
	@$(CC) $(C2ASM_FLAGS)$(FILE_CTOASM_RESULT) $(FILE_LANG_TOC_FINAL_RESULT)

# 4. Link object to target
# Link object to binary
FILE_TARGET=$(BOOTSECTOR).bin
$(FILE_TARGET): $(FILE_OBJ_INTERMIDIATE) $(FILES_BUILDRULES)
	@echo "# Link object to binary by $(LD)."
	@$(LD) $(LD_FLAGS) -o $(FILE_TARGET) $(FILE_OBJ_INTERMIDIATE)

# Verify and test scripts
SCRIPT_VERIFY ?= ../verify_boot.sh
SCRIPT_TEST ?= ../test.qemu.sh

# Build and run targets
build: $(FILE_TARGET) $(FILES_BUILDRULES)
	@echo "# Build $(FILE_TARGET) by $(EXE_LANG_TOC_COMPILER)/$(CC)/$(LD) succeeded!"
	@echo "# Verify $(FILE_TARGET) is valid $(BOOTSECTOR)."
	@$(SHELL) $(SCRIPT_VERIFY)

neat:
	rm -f *.o *.s *.c

clean: neat
	rm -f $(FILE_TARGET)

run: build
	@echo "# Run QEMU VM with 1M memory to load $(FILE_TARGET) as disk image for boot device"
	$(SHELL) $(SCRIPT_TEST)
