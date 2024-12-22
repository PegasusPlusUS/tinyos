
const hello_msg := " Hello, world of Bare Metal in V! "
//const scroll_pos := 0
//const asm_char_1 := 0

fn start() {
    bios_clear_screen();
    bios_set_cursor_pos__row_col(10, 23);
    bios_print_string__msg(hello_msg.str);

    for {
        //scroll_print_hello()
    } 
}
/*
fn scroll_print_hello() {
    bios_print_string__msg(hello_msg.str + scroll_pos);
    asm_char_1 = hello_msg[scroll_pos];
    hello_msg[scroll_pos] = 0;
    bios_print_string__msg(hello_msg.str);

    if scroll_pos++ >= hello_msg.size {
        scroll_pos = 0;
    }
}
*/
fn bios_clear_screen() {}
fn bios_set_cursor_pos__row_col(row u8, col u8) {}
fn bios_set_print_color__color() {}
fn bios_print_string__msg(msg &char) {}
