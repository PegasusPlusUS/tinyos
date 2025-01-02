include common

proc start() =
  asm_bios_clear_screen()
  c_print_string_at("Hi, bare-metal world by Nim!", 10, 26, ColorGreen)

start()
