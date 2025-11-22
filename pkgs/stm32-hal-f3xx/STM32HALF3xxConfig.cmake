include(${CMAKE_CURRENT_LIST_DIR}/STM32HALF3xx-Locator.cmake)

find_package(CMSIS5 REQUIRED)
find_package(CMSIS5DeviceF3 REQUIRED)

file(GLOB HAL_SOURCES ${HAL_ROOT}/Src/*.c)
list(FILTER HAL_SOURCES EXCLUDE REGEX "template\.c$")
add_library(STM32_HAL ${HAL_SOURCES})
add_library(STM32::HAL ALIAS STM32_HAL)
unset(HAL_SOURCES)

target_link_libraries(STM32_HAL PUBLIC
    CMSIS5::Device::F3
    CMSIS5::CoreM
    STM32::HALConfig
)

target_include_directories(STM32_HAL PUBLIC ${HAL_ROOT}/Inc)

unset(HAL_ROOT)