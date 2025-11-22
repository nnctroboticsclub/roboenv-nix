add_library(STM32_HALConfig INTERFACE)
target_include_directories(STM32_HALConfig INTERFACE .)

add_library(STM32::HALConfig ALIAS STM32_HALConfig)