# roboenv's Environment loader

#* Load Environment Variables
if (NOT "$ENV{CMAKE_MODULE_PATH}" STREQUAL "")
  set(CMAKE_MODULE_PATH "$ENV{CMAKE_MODULE_PATH};${CMAKE_MODULE_PATH}")
else()
  set(CMAKE_MODULE_PATH /usr/arm-none-eabi/share/cmake)
endif()

if (NOT "$ENV{CMAKE_PREFIX_PATH}" STREQUAL "")
  set(CMAKE_PREFIX_PATH "$ENV{CMAKE_PREFIX_PATH};${CMAKE_PREFIX_PATH}")
else()
  set(CMAKE_PREFIX_PATH /usr/arm-none-eabi)
endif()

#* Find ccache
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
  message(STATUS "ccache found: ${CCACHE_PROGRAM}")
  set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" CACHE STRING "C Compiler Launcher" FORCE)
  set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" CACHE STRING "CXX Compiler Launcher" FORCE)
  set(CMAKE_ASM_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" CACHE STRING "ASM Compiler Launcher" FORCE)
endif()

#* Chain loading toolchain file
if(DEFINED ROBO_TOOLCHAIN_FILE)
  include(${ROBO_TOOLCHAIN_FILE})
endif()
