#include "../c/common_prefix.h"

typedef struct string string;

typedef unsigned char* byteptr;
#define _SLIT(s) ((string){.str=(byteptr)("" s), .len=(sizeof(s)-1), .is_lit=1})
//typedef char string[];
typedef unsigned char u8;
struct string {
	u8* str;
	int len;
	int is_lit;
};

BEGIN_ASM_BOOTSECTOR;
