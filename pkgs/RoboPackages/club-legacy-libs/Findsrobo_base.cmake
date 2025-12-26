include(FetchContent)

FetchContent_Populate(srobo_base
  GIT_REPOSITORY git@github.com:nnctroboticsclub/srobo_base.git
  GIT_TAG 02a4a075264872246d83f3592f32fe59d1c858f6
  SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rd-party/srobo_base/src
  BINARY_DIR ${CMAKE_BINARY_DIR}/3rd-party/srobo_base/build
  SUBBUILD_DIR ${CMAKE_BINARY_DIR}/3rd-party/srobo_base/subbuild
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(srobo_base
  REQUIRED_VARS
    srobo_base_SOURCE_DIR
)

if(srobo_base_FOUND AND NOT TARGET srobo_base)
  add_subdirectory(${srobo_base_SOURCE_DIR} ${srobo_base_BINARY_DIR})
endif()