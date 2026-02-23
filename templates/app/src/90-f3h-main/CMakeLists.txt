# embedded_transform_target を使うため
include(TargetTransformer)

# Nano, F3Baremetal ライブラリを使うため
find_package(Nano REQUIRED)
find_package(F3Baremetal REQUIRED)

# 実行ファイルを作成する
add_executable(90-f3h-main
  src/main.cpp
)

# 使用するライブラリの指定
target_link_libraries(90-f3h-main PUBLIC
  F3Baremetal::f3-baremetal
  Nano::Nano
)

# 実行ファイルを小さくするためのフラグ
target_compile_options(90-f3h-main PUBLIC -fno-threadsafe-statics -fuse-cxa-atexit)

# nosys.specs: newlib 用の関数をデフォで作成する (何もしないものとして実装)
# 3 行目: リンカスクリプトを指定する (Flash レイアウトなどを指定している)
target_link_options(90-f3h-main PUBLIC
  -specs=nano.specs
  -specs=nosys.specs
  -Wl,-T,${CMAKE_CURRENT_SOURCE_DIR}/90-f3h-main.ld
)

# upload_... を実行できるようにする
embedded_transform_target(90-f3h-main)

