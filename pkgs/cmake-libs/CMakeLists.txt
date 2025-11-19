cmake_minimum_required(VERSION 3.22)
project(cmake-libs)

install(
  FILES
    TargetDumper.cmake
    DependencyFinder.cmake
    TargetTransformer.cmake
    FindFutaba_Puropo.cmake
    Findfmt.cmake
    Findsrobo_base.cmake
    FindPS4_RX.cmake
    Findikako_rohm_md.cmake
    Findtcb_span.cmake
    Findcan_servo.cmake
    Findim920_rs.cmake
    Findcereal.cmake
  DESTINATION lib/cmake
)
