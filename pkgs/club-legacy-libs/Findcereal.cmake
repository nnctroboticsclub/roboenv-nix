include(FetchContent)

FetchContent_Populate(cereal
  GIT_REPOSITORY https://github.com/USCiLab/cereal.git
  GIT_TAG v1.3.2
  SOURCE_DIR /usr/arm-none-eabi/src/cereal/src
  BINARY_DIR ${CMAKE_BINARY_DIR}/3rd-party/cereal/build
  SUBBUILD_DIR ${CMAKE_BINARY_DIR}/3rd-party/cereal/subbuild
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(cereal
  REQUIRED_VARS
    cereal_SOURCE_DIR
)

if(cereal_FOUND AND NOT TARGET cereal)
  add_library(cereal INTERFACE)
  target_include_directories(cereal INTERFACE
    ${cereal_SOURCE_DIR}/include
  )
endif()