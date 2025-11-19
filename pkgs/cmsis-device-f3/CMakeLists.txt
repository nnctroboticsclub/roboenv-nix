cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

function (define_component)
    cmake_parse_arguments(DEF_CMP
        ""
        "INCLUDES;TARGET"
        ""
        ${ARGN}
    )

    add_library(${DEF_CMP_TARGET} INTERFACE)
    add_library(cmsis5::${DEF_CMP_TARGET} ALIAS ${DEF_CMP_TARGET})

    target_include_directories(${DEF_CMP_TARGET} INTERFACE
        $<BUILD_INTERFACE:${DEF_CMP_INCLUDES}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )

    # Install headers
    install(DIRECTORY ${DEF_CMP_INCLUDES}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )

    install(TARGETS ${DEF_CMP_TARGET}
        EXPORT ${CMSIS_EXPORT_NAME}
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
endfunction()

project(CMSIS VERSION 1.0.0 LANGUAGES C CXX)

# Nix configures following variables
# - SourceTree: CMSIS5 Installation

set(CMSIS_EXPORT_NAME "CMSISDeviceF3Targets")

#* Define Components
define_component(
    TARGET "F3"
    INCLUDES "${SourceTree}/Include/"
)

#* Install
# Targets
install(
    EXPORT ${CMSIS_EXPORT_NAME}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${CMSIS_EXPORT_NAME}
    NAMESPACE cmsis-device::
    FILE CMSISDeviceF3Targets.cmake
)

# Config
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/CMSISDeviceF3.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/CMSISDeviceF3.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/CMSISDeviceF3.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)
