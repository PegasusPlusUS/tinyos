__asm__(".code16\n");
__asm__(".global _start\n");

void __attribute__((section(".text.boot"))) _start(void) {
    __asm__ volatile (
        "jmp main\n"
    );
}

#define VIDEO_INT   0x10
#define TIMER_INT   0x1A

typedef struct {
    unsigned char hours;
    unsigned char minutes;
    unsigned char seconds;
} Time;

// Function declarations
void print_string_at(const char* str, char row, char col, char color);
Time get_rtc_time(void);
void print_time_at(Time time, char row, char col, char color);
void handle_adv_scroll(void);

// Messages
const char* HELLO_MSG = "Hello, bootsector!";
const char* SAFE_MSG = "Now it is safe to turn off your box.";
const char* ADV_MSG = "TinyOS is an open source tutorial at https://github.com/pegasusplus/tinyos";

// Colors
enum {
    COLOR_YELLOW = 0x0E,
    COLOR_WHITE = 0x0F,
    COLOR_GREEN = 0x0A
};

void __attribute__((noreturn)) __attribute__((no_instrument_function)) main(void) {
    // Set up segments
    __asm__ volatile (
        "xor %ax, %ax\n"
        "mov %ax, %ds\n"
        "mov %ax, %es\n"
        "mov %ax, %ss\n"
        "mov $0x7C00, %sp\n"
        "mov $0x0003, %ax\n"
        "int $0x10\n"
    );

    // Print hello message in yellow
    print_string_at(HELLO_MSG, 0, 0, COLOR_YELLOW);

    // Print safe message in green
    print_string_at(SAFE_MSG, 2, 0, COLOR_GREEN);

    while (1) {
        // Get and display time
        Time time = get_rtc_time();
        print_time_at(time, 1, 0, COLOR_WHITE);

        // Handle scrolling advertisement
        handle_adv_scroll();

        // Simple delay
        for (unsigned short i = 0; i < 0x2FFF; i++) {
            __asm__ volatile ("nop");
        }
    }
}

void print_string_at(const char* str, char row, char col, char color) {
    // Set cursor position
    __asm__ volatile (
        "mov $0x02, %%ah\n"
        "xor %%bh, %%bh\n"
        "int $0x10\n"
        :
        : "d" ((row << 8) | col)
        : "ax", "bx"
    );

    // Print string with color
    while (*str) {
        __asm__ volatile (
            "mov $0x09, %%ah\n"
            "mov $1, %%cx\n"
            "int $0x10\n"
            "mov $0x03, %%ah\n"
            "int $0x10\n"
            "inc %%dl\n"
            "mov $0x02, %%ah\n"
            "int $0x10\n"
            :
            : "a" (*str), "b" (color)
            : "cx"
        );
        str++;
    }
}

Time get_rtc_time(void) {
    Time time;
    unsigned char hours, minutes, seconds;

    __asm__ volatile (
        "movb $0x02, %%ah\n"
        "int $0x1A\n"
        "movb %%ch, %0\n"
        "movb %%cl, %1\n"
        "movb %%dh, %2\n"
        : "=m" (hours), "=m" (minutes), "=m" (seconds)
        :
        : "ax", "cx", "dx"
    );

    // Convert BCD to binary
    time.hours = ((hours >> 4) * 10) + (hours & 0x0F);
    time.minutes = ((minutes >> 4) * 10) + (minutes & 0x0F);
    time.seconds = ((seconds >> 4) * 10) + (seconds & 0x0F);

    return time;
}

void print_time_at(Time time, char row, char col, char color) {
    char time_str[9];

    // Format time string
    time_str[0] = '0' + (time.hours / 10);
    time_str[1] = '0' + (time.hours % 10);
    time_str[2] = ':';
    time_str[3] = '0' + (time.minutes / 10);
    time_str[4] = '0' + (time.minutes % 10);
    time_str[5] = ':';
    time_str[6] = '0' + (time.seconds / 10);
    time_str[7] = '0' + (time.seconds % 10);
    time_str[8] = 0;

    print_string_at(time_str, row, col, color);
}

static unsigned char scroll_pos = 0;
static unsigned char adv_color = 0x0C;

void handle_adv_scroll(void) {
    char temp = ADV_MSG[scroll_pos];
    ((char*)ADV_MSG)[scroll_pos] = 0;

    // Print from scroll_pos + 1
    print_string_at(&ADV_MSG[scroll_pos + 1], 6, 0, adv_color);
    
    // Print from beginning
    print_string_at(ADV_MSG, 6, 0, adv_color);

    // Restore character
    ((char*)ADV_MSG)[scroll_pos] = temp;

    // Update position and color
    scroll_pos++;
    if (scroll_pos >= sizeof(ADV_MSG) - 1) {
        scroll_pos = 0;
    }
    adv_color++;
}

void __attribute__((section(".text.boot"))) _start(void)
{
    // Your bootloader code here
    while(1);
}

