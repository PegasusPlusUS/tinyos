#include "common_bios.bas"

Sub c_print_string_at(message As String, row As Byte, col As Byte, colour As BIOS_Colors)
    ' Print the message
    asm_bios_set_cursor_pos(row, col)
    asm_bios_set_print_color(colour)
    Print message
End Sub
