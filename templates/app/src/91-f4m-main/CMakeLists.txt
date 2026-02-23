# embedded_transform_target を使うため
include(TargetTransformer)

# NUCLEO_F446RE 向けの StaticMbedOS を扱うため
find_package(StaticMbedOS-NUCLEO_F446RE REQUIRED)

# 実行ファイルを作成する
add_executable(91-f4m-main src/main.cpp)

# 使用するライブラリの指定
target_link_libraries(91-f4m-main PUBLIC
  StaticMbedOS-NUCLEO_F446RE
)

# StaticMbedOS の後処理を行う
static_mbed_os_nucleo_f446re_app_target(91-f4m-main)

# upload_... を実行できるようにする
embedded_transform_target(91-f4m-main)
