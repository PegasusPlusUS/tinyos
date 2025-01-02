#include "common.bas"

Dim shared hello_message As String
hello_message = "Hello, world of Bare Metal in FreeBASIC!"

asm_bios_clear_screen()
c_print_string_at(hello_message, 10, 20, COLOR_GREEN)
