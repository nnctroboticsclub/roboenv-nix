cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

project(Segger-RTT VERSION 8.58.0 LANGUAGES C ASM)

set(INSTALL_INCLUDE "include/SeggerRTT")
set(INSTALL_SOURCE "src/SeggerRTT")

# Interface target for headers only
add_library(RTT INTERFACE)
add_library(Segger::RTT ALIAS RTT)
target_include_directories(RTT INTERFACE
    $<BUILD_INTERFACE:${RTT_SRC}/RTT>
    $<BUILD_INTERFACE:${RTT_SRC}/Syscalls>
    $<INSTALL_INTERFACE:${INSTALL_INCLUDE}>
    $<INSTALL_INTERFACE:${INSTALL_SOURCE}/RTT>
    $<INSTALL_INTERFACE:${INSTALL_SOURCE}/Syscalls>
)

# Source files for per-target compilation (config-dependent)
set(SEGGER_RTT_CONFIG_SOURCES
    ${RTT_SRC}/RTT/SEGGER_RTT.c
    ${RTT_SRC}/RTT/SEGGER_RTT_printf.c
)

# Source files for per-target compilation (config-independent)
set(SEGGER_RTT_CONFIG_INDEP_SOURCES
    ${RTT_SRC}/RTT/SEGGER_RTT_ASM_ARMv7M.S
    ${RTT_SRC}/Syscalls/SEGGER_RTT_Syscalls_GCC.c
)

# Install headers
install(
    FILES
        ${RTT_SRC}/RTT/SEGGER_RTT.h
        ${RTT_SRC}/RTT/SEGGER_RTT_ConfDefaults.h
    DESTINATION ${INSTALL_INCLUDE}
)

# Install source files for per-target compilation
install(
    FILES ${SEGGER_RTT_CONFIG_SOURCES} ${SEGGER_RTT_CONFIG_INDEP_SOURCES}
    DESTINATION ${INSTALL_SOURCE}/RTT
)
install(
    FILES ${RTT_SRC}/Syscalls/SEGGER_RTT_Syscalls_GCC.c
          ${RTT_SRC}/Syscalls/SEGGER_RTT_Syscalls_IAR.c
          ${RTT_SRC}/Syscalls/SEGGER_RTT_Syscalls_KEIL.c
          ${RTT_SRC}/Syscalls/SEGGER_RTT_Syscalls_SES.c
    DESTINATION ${INSTALL_SOURCE}/Syscalls
)

# Export variables for consumers
install(TARGETS RTT
    EXPORT SeggerRTTTargets
    INCLUDES DESTINATION ${INSTALL_INCLUDE}
)

install(EXPORT SeggerRTTTargets
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/SeggerRTT
    NAMESPACE Segger::
    FILE SeggerRTTTargets.cmake
)

# Config package
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/SeggerRTTConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/SeggerRTTConfig.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/SeggerRTT
)
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/SeggerRTTConfig.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/SeggerRTT
)
