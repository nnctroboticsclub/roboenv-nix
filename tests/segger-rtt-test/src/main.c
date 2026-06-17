#include <SEGGER_RTT.h>
#include <stdio.h>

#define STR(x) #x
#define XSTR(x) STR(x)

const char* rtt_config_info = "RTT_VAL_UP=" XSTR(SEGGER_RTT_MAX_NUM_UP_BUFFERS) " RTT_VAL_DOWN=" XSTR(SEGGER_RTT_MAX_NUM_DOWN_BUFFERS);

int main(void) {
    SEGGER_RTT_Init();
    SEGGER_RTT_WriteString(0, "RTT initialized\n");
    SEGGER_RTT_WriteString(0, rtt_config_info);
    SEGGER_RTT_WriteString(0, "\n");

    return 0;
}