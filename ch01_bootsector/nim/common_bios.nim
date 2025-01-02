proc asm_bios_clear_screen() =
  # ANSI escape code to clear the screen
  #stdout.write("\033")   # clearScreen()
  discard

type
  Colors = enum
    Red = 1,
    Blue = 10,
    Yellow  # Automatically becomes 11
    ColorGreen = 15,

# Example usage
#var favoriteColor: Colors = Blue
#echo favoriteColor  # Output: Blue
#echo cast[int](favoriteColor)  # Output: 10
