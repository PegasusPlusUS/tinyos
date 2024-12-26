#include "common.bas"

Dim shared hello_message As String
hello_message = "Hello, world of Bare Metal in FreeBASIC!"

BIOS_CLEAR_SCREEN()
BIOS_SET_CURSOR_POS_P_ROW_COL(10, 20) ' 40 - message length / 2
BIOS_PRINT_STRING_P_MSG(hello_message)
