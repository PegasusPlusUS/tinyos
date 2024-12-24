include common_bios

proc start() =
  BIOS_CLEAR_SCREEN()
  BIOS_SET_CURSOR_POS_P_ROW_COL(10, 26)
  BIOS_PRINT_STRING_P_MSG("Hi, bare-metal world by Nim!")

start()
