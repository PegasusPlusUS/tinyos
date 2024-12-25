# Makefile for nim
# Specific rules and variables for Makefile 2
LANG_SUFFIX = .nim
FILE_SOURCE=$(BOOTSECTOR)$(LANG_SUFFIX)
FILE_LANG_TOC_INITIAL_RESULT=~/nimcache/$(BOOTSECTOR)_d/@m$(FILE_SOURCE).c
EXE_LANG_TOC_COMPILER=nim
LANG2C_FLAGS=c --genScript --cc:gcc --compileOnly --out:
#LANG_TOC_POST_PROCESSING=cp ~/nimcache/$(BOOTSECTOR)_d/@m$(FILE_LANG_TOC_INITIAL_RESULT) $(FILE_LANG_TOC_INITIAL_RESULT)
#FILES_SOURCE_ADDITIONAL_DEPENDENCY=

include ../common.mk
