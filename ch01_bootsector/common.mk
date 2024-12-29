# common.mk
# TODO: Need IA16-elf-gcc, IA16-elf-ld, and IA16-elf-as, otherwise, function can not take param. Current BIOS_xxx are all macros,
# 	which are not function, they uses fixed static memory to pass param to asm functions, not stack (i686-elf-gcc has bug that uses 32bit stack register which cause trouble in bootsector 16bit real mode).
#   or try initialize 32bit ss and esp to see if that can work.
#
# Lang -> C path, v/bas/nim ready, f90, pascal (with p2c on Linux)
# Lang -> lib.a path, swift. go and c can not access memory directly, must use function call, which will be ready after ia16-toolchain is ready or init 32bit ss/esp works. This path might not possible for the size of the code.
# Lang -> ASM path, pascal (generate asm)
# Lang -> WASM path, VM translate to C, zig, tinygo, moonbit
# Lang -> LLVMIR path, LLVMIR to C, or LLVMIR to ASM?
#

# To use this common.mk, c just include ../common.mk; asm define LANG_SUFFIX=asm then include ../common.mk;
# For other languages, you need to define the following variables in your Makefile:
# 1. LANG_SUFFIX: the suffix of the source file, e.g., .nim, .v, .bas, .pas, .go, .zig, .swift, .f90
# 2. EXE_LANG_COMPILER: the executable name of the compiler, e.g., nim, v, fbc, fpc, go, zig, swift, gfortran
# 3. FLAGS_LANG_TO_C: the flags to pass to the compiler, e.g., -r, -freestanding, -c --genScript --cc:gcc --compileOnly --out:
# 4. Optional: FILES_SOURCE_SET: the source files set representation, e.g., . for V
# 5. Optional: FILES_SOURCE_DEPENDENCIES: the dependencies for the source file, e.g., common.$(LANG_SUFFIX), common_bios.$(LANG_SUFFIX)
# 6. Optional: FILES_SOURCE_ADDITIONAL_DEPENDENCIES: the additional dependencies for the source file, e.g., main.v
# 7. Optional: SCRIPT_LANG_TO_C_POST_PROCESSING: the post processing command to run after the source file is compiled to C,
#   e.g., cp ~/nimcache/$(BOOTSECTOR)_d/@m$(FILE_LANG_TO_C_INITIAL_RESULT) $(FILE_LANG_TO_C_INITIAL_RESULT) 
# 8. Optional: C_DEPENDENCIES: the dependencies for the C code, e.g., ../c/common_prefix.h ../c/bootsector.h ../c/common_suffix.h
# 9. Optional: C_LANG_DEPENDENCIES: the dependencies for the C code of LANG, e.g., common_prefix.$(LANG_SUFFIX).h common_suffix.$(LANG_SUFFIX).h $(C_DEPENDENCIES)
#
# common.mk assumes:
# 1. There is a filter_$(LANG_SUFFIX)_to_c_result.awk file to filter initial C code to final C code.
# 2. There is a common_prefix.$(LANG_SUFFIX).h, common_suffix.$(LANG_SUFFIX).h, and common_bios.$(LANG_SUFFIX) file.
# 3. The final C code will be compiled to an object file, and then linked to a binary file as target which named 'bootsector.bin'.
# 4. The target file will be verified by a verify script, and then tested by a test script to start QEMU VM load target as bootsector.
# 5. Under AV, the target file will be packed as a .pz file, and then verified by a verify script, and then tested by a test script to start QEMU VM load target as bootsector.
#
# common.mk provides the following targets:
# 1. default: the run target will build the binary file, verify it, and then run it.
# 2. build: the build target will build the binary file, verif it.
# 3. build_under_av: the build_under_av target will build the packed binary file, verify it.
# 4. run_under_av: the run_under_av target will build the packed binary file, verify it, and then run it.
# 5. neat: the neat target will remove all intermediate files.
# 6. clean: the clean target will remove all intermediate files and the target file.
# 7. check_asm: sometimes, you may want to check the generated asm code to debug ridiculous bug, for example,
#   currently i686-elf-gcc can't always generate 16bit asm code, especially, it uses 32bit stack registers for
#   params, which causes accessing the stack variable or passing param to function hang the VM. You can use
#   this target to generate the asm code for deep debugging.
#


# Disable default rules by overriding them with empty rules
.SUFFIXES:

all: run

ifneq ($(LANG_SUFFIX), asm)
.PHONY : run build neat clean run_under_av check_asm
else
.PHONY : run build neat clean run_under_av
endif

SHELL?=/usr/bin/bash

BOOTSECTOR=bootsector
BASE_DIR?=../../ch01_bootsector/
FILES_BUILD_RULES?=Makefile $(BASE_DIR)common.mk


ifdef LANG_SUFFIX
PIPE_LINE_SKIP_TO_C=false
ifeq ($(LANG_SUFFIX), asm)
EXE_LANG_COMPILER=nasm
FLAGS_COMPILER2TARGET?=-o 
else
PIPE_LINE_SKIP_TO_C=true
endif
endif

ifndef LANG_SUFFIX
LANG_SUFFIX=c
PIPE_LINE_SKIP_TO_C=true
endif

FILES_SOURCE_COMMOM_PREFIX?=$(BASE_DIR)$(LANG_SUFFIX)/
FILES_SOURCE_DEPENDENCIES?=$(FILES_SOURCE_COMMOM_PREFIX)common.$(LANG_SUFFIX) $(FILES_SOURCE_COMMOM_PREFIX)common_bios.$(LANG_SUFFIX)

# Common rules and variables
EXE_C_COMPILER=i686-elf-gcc
FLAGS_CC=-m16 -mregparm=3 -mno-push-args -fcall-used-eax -fcall-used-edx -ffreestanding -fno-pie \
        -nostdlib -nostdinc -fno-asynchronous-unwind-tables \
        -fno-builtin -fno-stack-protector -mno-mmx -mno-sse
FLAGS_C_TO_O=$(FLAGS_CC) -o 
FLAGS_C_TO_ASM=$(FLAGS_CC) -O0 -S -o 
EXE_LINK=i686-elf-ld
FLAGS_LINK=-T $(BASE_DIR)c/linker.ld --oformat binary -s

# CI_PIPE_LINE_START
FILE_SOURCE?=$(BOOTSECTOR).$(LANG_SUFFIX)
FILES_SOURCE_DEPENDENCIES?=common_bios.$(LANG_SUFFIX)

ifneq ($(PIPE_LINE_SKIP_TO_C), true)
# 1. Lang to C initial
# Define FILE_SOURCE and FILE_LANG_TO_C_INITIAL_RESULT
FILE_LANG_TO_C_INITIAL_RESULT?=$(FILE_SOURCE).c
SCRIPT_LANG_TO_C_POST_PROCESSING?=echo "\# $(FILE_SOURCE) to $(FILE_LANG_TO_C_INITIAL_RESULT) succeeded!"
# Rule to build FILE_LANG_TO_C_INITIAL_RESULT
FILES_SOURCE_SET?=$(FILE_SOURCE)
$(FILE_LANG_TO_C_INITIAL_RESULT): $(FILE_SOURCE) $(FILES_SOURCE_DEPENDENCIES) $(FILES_SOURCE_ADDITIONAL_DEPENDENCIES) $(FILES_BUILD_RULES)
	@echo "# Compile $(FILE_SOURCE) to $(FILE_LANG_TO_C_INITIAL_RESULT) by $(EXE_LANG_COMPILER)."
	@$(EXE_LANG_COMPILER) $(FLAGS_LANG_TO_C)$(FILE_LANG_TO_C_INITIAL_RESULT) $(FILES_SOURCE_SET)
	@$(SCRIPT_LANG_TO_C_POST_PROCESSING)

# 2. Filter C initial to final
FILE_LANG_TO_C_FINAL_RESULT=$(BOOTSECTOR).c
FILTER=awk
SCRIPT_FILTER_LANG_TO_C=filter_$(LANG_SUFFIX)_to_c_result.awk
$(FILE_LANG_TO_C_FINAL_RESULT): $(FILE_LANG_TO_C_INITIAL_RESULT) $(SCRIPT_FILTER_LANG_TO_C) $(FILES_BUILD_RULES)
	@echo "# Filter out unneeded code and add necessary reused functions and $(BOOTSECTOR) signature from ../c/$(BOOTSECTOR).h by $(FILTER)."
	@$(FILTER) -f $(SCRIPT_FILTER_LANG_TO_C) $(FILE_LANG_TO_C_INITIAL_RESULT) > $(FILE_LANG_TO_C_FINAL_RESULT)
else
FILE_LANG_TO_C_FINAL_RESULT=$(FILE_SOURCE)
endif

ifneq ($(LANG_SUFFIX), asm)
# 3.0 final C to O
FILE_OBJ_RESULT=$(BOOTSECTOR).o
FILE_C_TO_ASM_RESULT=$(BOOTSECTOR).s
C_DEPENDENCIES?=$(BASE_DIR)c/common_prefix.h $(BASE_DIR)c/bootsector.h $(BASE_DIR)c/common_suffix.h
ifndef C_LANG_DEPENDENCIES
C_LANG_DEPENDENCIES=$(C_DEPENDENCIES)
ifneq ($(LANG_SUFFIX), c)
C_LANG_DEPENDENCIES=$(C_DEPENDENCIES) common_prefix.$(LANG_SUFFIX).h common_suffix.$(LANG_SUFFIX).h
endif
endif

$(FILE_OBJ_RESULT): $(FILE_LANG_TO_C_FINAL_RESULT) $(C_LANG_DEPENDENCIES) $(FILES_BUILD_RULES)
ifneq ($(LANG_SUFFIX), c)
	@echo "# Compile processed C code to object by $(EXE_C_COMPILER)."
else
	@echo "# Compile C code to object by $(EXE_C_COMPILER)."
endif
	@$(EXE_C_COMPILER) $(FLAGS_C_TO_O)$(FILE_OBJ_RESULT) -c $(FILE_LANG_TO_C_FINAL_RESULT)

# 3.1 optional final C to ASM
$(FILE_C_TO_ASM_RESULT): $(FILE_LANG_TO_C_FINAL_RESULT) $(C_LANG_DEPENDENCIES) $(FILES_BUILD_RULES)
	@echo "# Generate asm code for checking by $(EXE_C_COMPILER)."
	@$(EXE_C_COMPILER) $(FLAGS_C_TO_ASM)$(FILE_C_TO_ASM_RESULT) $(FILE_LANG_TO_C_FINAL_RESULT)
endif

# 4. Link object to target
# Link object to binary
FILE_TARGET=$(BOOTSECTOR).bin
ifneq ($(LANG_SUFFIX), asm)
$(FILE_TARGET): $(FILE_OBJ_RESULT) $(FILES_BUILD_RULES)
	@echo "# Link object to binary by $(EXE_LINK)."
	@$(EXE_LINK) $(FLAGS_LINK) -o $(FILE_TARGET) $(FILE_OBJ_RESULT)
else
# 1. ASM to binary
$(FILE_TARGET): $(FILE_SOURCE) $(FILES_SOURCE_DEPENDENCIES) $(FILES_SOURCE_ADDITIONAL_DEPENDENCIES) $(FILES_BUILD_RULES)
	@echo "# Compile $(FILE_SOURCE) to $(FILE_TARGET) by $(EXE_LANG_COMPILER)."
	@$(EXE_LANG_COMPILER) $(FLAGS_COMPILER2TARGET) $(FILE_TARGET) $(FILE_SOURCE)
endif

# Verify and test scripts
SCRIPT_VERIFY?=$(BASE_DIR)verify_boot.sh
SCRIPT_TEST?=$(BASE_DIR)test.qemu.sh

# Build and run targets
build: $(FILE_TARGET) $(FILES_BUILD_RULES)
	@echo "# Verify $(FILE_TARGET) is valid $(BOOTSECTOR)."
	@$(SHELL) $(SCRIPT_VERIFY)

check_asm: $(FILE_C_TO_ASM_RESULT) $(FILES_BUILD_RULES)
	@echo "# Check $(FILE_C_TO_ASM_RESULT) for debugging."
	@code $(FILE_C_TO_ASM_RESULT)

neat:
	rm -f *.o *.s *.pz
ifneq (.$(LANG_SUFFIX), .c)
	rm -f *.c
endif

clean: neat
	rm -f $(FILE_TARGET)

run: build
	@echo "# Run QEMU VM with 1M memory to load $(FILE_TARGET) as disk image for boot device"
	$(SHELL) $(SCRIPT_TEST)
