#include "common_bios.bas"
' Main program
Dim message As String
message = "Hello, world of Bare Metal in FreeBASIC!"
BIOS_PRINT_STRING__MSG(message)
