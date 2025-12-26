include(FetchContent)

FetchContent_Populate(im920_rs
  GIT_REPOSITORY git@github.com:nnctroboticsclub/im920_rs.git
  GIT_TAG 2901c4ead3e00257d13c7344183c331147c9f36c
  SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rd-party/im920_rs/src
  BINARY_DIR ${CMAKE_BINARY_DIR}/3rd-party/im920_rs/build
  SUBBUILD_DIR ${CMAKE_BINARY_DIR}/3rd-party/im920_rs/subbuild
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(im920_rs
  REQUIRED_VARS
    im920_rs_SOURCE_DIR
)

if(im920_rs_FOUND AND NOT TARGET im920_rs)
  add_subdirectory(${im920_rs_SOURCE_DIR} ${im920_rs_BINARY_DIR})
endif()