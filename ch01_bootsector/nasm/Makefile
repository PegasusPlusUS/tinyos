# TODO: reuse common.mk

.SUFFIXES:

all: run

.PHONY : run build neat clean run_under_av check_asm

SHELL=/usr/bin/bash

BOOTSECTOR=bootsector
FILE_TARGET=$(BOOTSECTOR).bin
FILE_SOURCE=$(BOOTSECTOR).asm
FILES_SOURCE_DEPENDENCIES=common.asm
FILES_SOURCE_ADDITIONAL_DEPENDENCIES=common_bios.asm
FILES_BUILD_RULES=Makefile
EXE_LANG_TO_C_COMPILER=nasm
COMPILER2TARGET_FLAGS=-o
SCRIPT_VERIFY=../verify_boot.sh
SCRIPT_TEST=../test.qemu.sh

$(FILE_TARGET) : $(FILE_SOURCE) $(FILES_SOURCE_DEPENDENCIES) $(FILES_SOURCE_ADDITIONAL_DEPENDENCIES) $(FILES_BUILD_RULES)
	@echo "# Compile $(FILE_SOURCE) to $(FILE_TARGET) by $(EXE_LANG_TO_C_COMPILER)"
	@$(EXE_LANG_TO_C_COMPILER) $(COMPILER2TARGET_FLAGS) $(FILE_TARGET) $(FILE_SOURCE)
	
build : $(FILE_TARGET) $(FILES_BUILD_RULES)
	@echo "# Verify target is bootable"
	@$(SHELL) $(SCRIPT_VERIFY)

run : build
	@echo "# Run QEMU with 1M memory to load $(FILE_TARGET) as disk image for boot device"
	@$(SHELL) $(SCRIPT_TEST)

clean :
	rm -f $(FILE_TARGET)
