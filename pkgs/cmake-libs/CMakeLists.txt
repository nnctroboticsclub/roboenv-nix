cmake_minimum_required(VERSION 3.22)
project(cmake-libs)

install(
  FILES
    TargetDumper.cmake
    DependencyFinder.cmake
    TargetTransformer.cmake
  DESTINATION lib/cmake
)
