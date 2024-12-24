include common_bios

proc start() =
  BIOS_CLEAR_SCREEN()
  BIOS_SET_CURSOR_POS_1_ROW_COL(10, 30)
  BIOS_PRINT_STRING_1_MSG("Hi, bare-metal world by Nim!")

start()
