# roboenv's Environment loader

if (NOT "${ROBOENV_LOADED}")
  set(ROBOENV_LOADED TRUE)

  #* Load Environment Variables
  if (NOT "$ENV{CMAKE_MODULE_PATH}" STREQUAL "")
    set(CMAKE_MODULE_PATH "$ENV{CMAKE_MODULE_PATH};${CMAKE_MODULE_PATH}")
  else()
    set(CMAKE_MODULE_PATH "/usr/arm-none-eabi/share/cmake;${CMAKE_MODULE_PATH}")
  endif()

  if (NOT "$ENV{CMAKE_PREFIX_PATH}" STREQUAL "")
    set(CMAKE_PREFIX_PATH "$ENV{CMAKE_PREFIX_PATH};${CMAKE_PREFIX_PATH}")
  else()
    set(CMAKE_PREFIX_PATH "/usr/arm-none-eabi;${CMAKE_PREFIX_PATH}")
  endif()

  message("Roboenv loaded following variables")
  message("CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")
  message("CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

  #* Chain loading toolchain file
  if(DEFINED ROBO_TOOLCHAIN_FILE)
    message("Roboenv loading toolchain file: ${ROBO_TOOLCHAIN_FILE}")
    include(${ROBO_TOOLCHAIN_FILE})
  endif()
endif()