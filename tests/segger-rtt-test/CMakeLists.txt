cmake_minimum_required(VERSION 3.19)
project(segger-rtt-test VERSION 1.0.0 LANGUAGES C ASM)

# ARM architecture flags
add_compile_options(-mthumb -mcpu=cortex-m4)
add_link_options(-mthumb -mcpu=cortex-m4 --specs=nosys.specs)

find_package(SeggerRTT REQUIRED)

# Config-dependent sources (must be compiled per-target with their config)
set(SEGGER_RTT_CONFIG_SOURCES
    ${SeggerRTT_SOURCE_DIR}/RTT/SEGGER_RTT.c
    ${SeggerRTT_SOURCE_DIR}/RTT/SEGGER_RTT_printf.c
)

# Config-independent sources (can be shared, but compile per-target for simplicity)
set(SEGGER_RTT_COMMON_SOURCES
    ${SeggerRTT_SOURCE_DIR}/RTT/SEGGER_RTT_ASM_ARMv7M.S
    ${SeggerRTT_SOURCE_DIR}/Syscalls/SEGGER_RTT_Syscalls_GCC.c
)

# Board A: minimal config
add_executable(board_a_firmware
    src/main.c
    ${SEGGER_RTT_CONFIG_SOURCES}
    ${SEGGER_RTT_COMMON_SOURCES}
)
target_include_directories(board_a_firmware PRIVATE config/board_a)
target_include_directories(board_a_firmware PUBLIC ${SeggerRTT_INCLUDE_DIRS})

# Board B: full config
add_executable(board_b_firmware
    src/main.c
    ${SEGGER_RTT_CONFIG_SOURCES}
    ${SEGGER_RTT_COMMON_SOURCES}
)
target_include_directories(board_b_firmware PRIVATE config/board_b)
target_include_directories(board_b_firmware PUBLIC ${SeggerRTT_INCLUDE_DIRS})

message(STATUS "Board A config: config/board_a/SEGGER_RTT_Conf.h")
message(STATUS "Board B config: config/board_b/SEGGER_RTT_Conf.h")

install(TARGETS board_a_firmware board_b_firmware DESTINATION bin)
