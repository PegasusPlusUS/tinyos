module common_bios

pub fn bios_clear_screen() {}
pub fn bios_set_cursor_pos_p_row_col(row u8, col u8) {}
pub fn bios_set_print_color_p_color() {}
pub fn bios_print_string_p_msg(msg &char) {}
