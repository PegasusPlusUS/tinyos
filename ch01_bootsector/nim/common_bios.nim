proc BIOS_PRINT_STRING_p_MSG(msg: string) =
    discard

proc BIOS_CLEAR_SCREEN() =
  # ANSI escape code to clear the screen
  stdout.write("\033")   # clearScreen()

proc BIOS_SET_CURSOR_POS_p_ROW_COL(row: uint8, col: uint8) =
    discard
