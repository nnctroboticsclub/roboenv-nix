cmake_minimum_required(VERSION 3.19)

project(static-mbed-os-test VERSION 0.1.1)


find_package(CMSISDeviceF3 REQUIRED)

add_executable(app main.cpp)
target_link_libraries(app PUBLIC CMSIS5::Device::F3)

install(TARGETS app RUNTIME DESTINATION bin)
