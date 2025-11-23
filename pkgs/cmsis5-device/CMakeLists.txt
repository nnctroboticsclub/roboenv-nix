cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

set(PROJECT_NAME CMSIS5Device${BuildTarget})

project(${PROJECT_NAME} VERSION 1.0.0 LANGUAGES C CXX)
find_package(CMSIS5 REQUIRED)

set(CMSIS_EXPORT_NAME "${PROJECT_NAME}Targets")

#* Define library
add_library(${BuildTarget} INTERFACE)
add_library(CMSIS5::Device::${BuildTarget} ALIAS ${BuildTarget})

target_link_libraries(${BuildTarget} INTERFACE
    CMSIS5::CoreM
)

target_include_directories(${BuildTarget} INTERFACE
    $<BUILD_INTERFACE:${SourceTree}/Include/>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Install headers
install(DIRECTORY ${SourceTree}/Include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(TARGETS ${BuildTarget}
    EXPORT ${CMSIS_EXPORT_NAME}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

#* Install
# Targets
install(
    EXPORT ${CMSIS_EXPORT_NAME}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
    NAMESPACE CMSIS5::Device::
    FILE ${PROJECT_NAME}Targets.cmake
)

# Config
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
)
