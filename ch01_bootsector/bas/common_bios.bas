Sub asm_bios_clear_screen()
    ' Clear the screen
    Cls
End Sub 

Sub asm_bios_set_cursor_pos(ByVal row As Byte, ByVal col As Byte)
    ' Set the cursor position
    Locate row, col
End Sub

Enum BIOS_Colors
     COLOR_BLACK = 0,
     COLOR_LIGHT_BLUE = 1,
     COLOR_WHITE = 15,
     COLOR_YELLOW = 14,
     COLOR_CYAN = 13,
     COLOR_RED = 12,
     COLOR_BLUE = 11,
     COLOR_GREEN = 10,
     COLOR_PURPLE = 9,
     COLOR_ORANGE = 8,
     COLOR_BROWN = 7,
     COLOR_GREY = 6,
     COLOR_LIGHT_GREY = 5,
     COLOR_DARK_GREY = 4,
     COLOR_GREY_BLUE = 3,
     COLOR_LIGHT_GREEN = 2,
End Enum

Sub asm_bios_set_print_color(ByVal colour As BIOS_Colors)
    ' Set the print color
    Color colour
End Sub
