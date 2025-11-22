cmake_minimum_required(VERSION 3.19)

project(stm32-hal-f3xx-test VERSION 0.1.1)

find_package(STM32HALF3xx REQUIRED)
add_subdirectory(stm32hal-config)

target_compile_options(STM32_HAL PUBLIC -DSTM32F303x8=1)

add_executable(app main.cpp)
target_link_libraries(app PUBLIC STM32::HAL)

install(TARGETS app RUNTIME DESTINATION bin)
