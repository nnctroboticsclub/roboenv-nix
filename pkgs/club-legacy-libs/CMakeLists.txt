cmake_minimum_required(VERSION 3.22)
project(club-legacy-libs)

install(
  FILES
    Findcan_servo.cmake
    Findcereal.cmake
    Findfmt.cmake
    FindFutaba_Puropo.cmake
    Findikako_rohm_md.cmake
    FindikakoMDC.cmake
    FindIkakoRobomas.cmake
    FindikarashiCAN_mk2.cmake
    Findim920_rs.cmake
    FindMotorController.cmake
    FindPS4_RX.cmake
    Findsrobo_base.cmake
    Findtcb_span.cmake
  DESTINATION lib/cmake
)
