package bootsector

/*
#cgo CFLAGS: -I../../c
#include "bootsector.c"
#include <stdlib.h>
*/
import "C"

import "unsafe"

// Function to call the C function
func printStringWithColor(msg string, color byte) {
	// Convert Go string to C string
	cMsg := C.CString(msg)
	defer C.free(unsafe.Pointer(cMsg)) // Free the C string after use

	// Call the C function
	C.asm_bios_print_string_p_msg_color(cMsg, C.uchar(color))
}

//export start
func start() {
	C.asm_bios_clear_screen()
	C.asm_bios_set_cursor_pos_p_row_col(10, 25)
	printStringWithColor("Hello, bare-metal world by Go!", C.COLOR_GREEN)
}
