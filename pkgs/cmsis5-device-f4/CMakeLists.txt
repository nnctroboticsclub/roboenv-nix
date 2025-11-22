cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

project(CMSIS5DeviceF4 VERSION 1.0.0 LANGUAGES C CXX)
find_package(CMSIS5 REQUIRED)

function (define_component)
    cmake_parse_arguments(DEF_CMP
        ""
        "INCLUDES;TARGET"
        ""
        ${ARGN}
    )

    add_library(${DEF_CMP_TARGET} INTERFACE)
    add_library(CMSIS5::Device::${DEF_CMP_TARGET} ALIAS ${DEF_CMP_TARGET})

    target_link_libraries(${DEF_CMP_TARGET} INTERFACE
        CMSIS5::CoreM
    )

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


set(CMSIS_EXPORT_NAME "CMSIS5DeviceF4Targets")

#* Define Components
define_component(
    TARGET "F4"
    INCLUDES "${SourceTree}/Include/"
)

#* Install
# Targets
install(
    EXPORT ${CMSIS_EXPORT_NAME}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
    NAMESPACE CMSIS5::Device::
    FILE CMSIS5DeviceF4Targets.cmake
)

# Config
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/CMSIS5DeviceF4.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/CMSIS5DeviceF4Config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/CMSIS5DeviceF4Config.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)
