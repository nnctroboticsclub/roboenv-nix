cmake_minimum_required(VERSION 3.22)
project(club-legacy-libs)

install(
  FILES
    Findcereal.cmake
    Findfmt.cmake
    Findtcb_span.cmake
  DESTINATION lib/cmake
)
