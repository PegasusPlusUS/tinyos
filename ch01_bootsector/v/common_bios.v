module common_bios

pub fn bios_clear_screen() {}
pub fn bios_set_cursor_pos__row_col(row u8, col u8) {}
pub fn bios_set_print_color__color() {}
pub fn bios_print_string__msg(msg &char) {}
