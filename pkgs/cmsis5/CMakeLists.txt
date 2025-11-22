cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

# Nix configures following variables
# - CMSIS5_DIR: CMSIS5 Installation

function (define_cmsis_component)
    cmake_parse_arguments(CMSIS_CMP
        ""
        "COMPONENT;TARGET;HAS_SOURCE"
        ""
        ${ARGN}
    )

    set(CMP_DIR "${CMSIS5_DIR}/CMSIS/${CMSIS_CMP_COMPONENT}")
    set(CMP_INSTALL_INCLUDE "include/CMSIS5-${CMSIS_CMP_TARGET}")

    if (NOT ${CMSIS_CMP_HAS_SOURCE})
        add_library(${CMSIS_CMP_TARGET} INTERFACE)
        set(CMP_SCOPE "INTERFACE")
    else()
        file (GLOB_RECURSE CMP_SOURCES
            "${CMP_DIR}/Source/*.c"
            "${CMP_DIR}/Source/*.cpp"
        )
        add_library(${CMSIS_CMP_TARGET} STATIC ${CMP_SOURCES})
        set(CMP_SCOPE "PUBLIC")
    endif()
    add_library(CMSIS5::${CMSIS_CMP_TARGET} ALIAS ${CMSIS_CMP_TARGET})

    target_include_directories(${CMSIS_CMP_TARGET} ${CMP_SCOPE}
        $<BUILD_INTERFACE:${CMP_DIR}/Include>
        $<INSTALL_INTERFACE:${CMP_INSTALL_INCLUDE}>
        )
        target_include_directories(${CMSIS_CMP_TARGET} ${CMP_SCOPE}
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
        $<INSTALL_INTERFACE:${CMP_INSTALL_INCLUDE}>
    )


    # Install headers
    install(DIRECTORY ${CMP_DIR}/Include/
        DESTINATION ${CMP_INSTALL_INCLUDE}
    )

    install(TARGETS ${CMSIS_CMP_TARGET}
        EXPORT ${CMSIS_EXPORT_NAME}
        INCLUDES DESTINATION ${CMP_INSTALL_INCLUDE}
        PUBLIC_HEADER DESTINATION ${CMP_INSTALL_INCLUDE}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
endfunction()

project(CMSIS VERSION 1.0.0 LANGUAGES C CXX)

set(CMSIS_EXPORT_NAME "CMSIS5_Targets")

#* Define Components
define_cmsis_component(
    COMPONENT "Core"
    TARGET "CoreM"
    HAS_SOURCE FALSE
)

#* Install
# Targets
install(
    EXPORT ${CMSIS_EXPORT_NAME}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
    NAMESPACE CMSIS5::
    FILE CMSIS5Targets.cmake
)

# Config
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/CMSIS5Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/CMSIS5Config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/CMSIS5Config.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)
