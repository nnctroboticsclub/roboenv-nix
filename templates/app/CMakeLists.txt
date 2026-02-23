# CMake のバージョン要求
cmake_minimum_required(VERSION 3.25)
cmake_policy(VERSION 3.25)

# プロジェクト名
set(ROBO_PJ_NAME "Robotics Project")
# 使うコンパイラ
# GccArmToolchain: GCC Arm embedded をつかう
# ClangArmToolchain: コンパイルに Clang を使いリンクに GCC Arm Embedded を使う
set(ROBO_TOOLCHAIN_FILE ClangArmToolchain)

enable_testing() # CTest を使うための宣言
project(${ROBO_PJ_NAME}) # コンパイラ等の読み込み
enable_language(C CXX ASM) # C/C++/アセンブリ を使えるようにしておく

# C++ の標準を指定する
set(CMAKE_CXX_STANDARD 20) # C++20 を利用
set(CMAKE_CXX_STANDARD_REQUIRED ON) # C++20 を必須とする
set(CMAKE_CXX_EXTENSIONS OFF) # GCC 拡張を使わない

# 「Cortex M4 向けのビルド」と指定する
add_compile_options(-mfloat-abi=softfp -mfpu=fpv4-sp-d16 -mthumb -mcpu=cortex-m4)
add_link_options(-mfloat-abi=softfp -mfpu=fpv4-sp-d16 -mthumb -mcpu=cortex-m4)

# デバッグ情報を付与する (デバッガで処理を追いやすくなる)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -gfull -fstandalone-debug -gdwarf-5 -gz")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -gfull -fstandalone-debug -gdwarf-5 -gz")

# バイナリサイズを小さくするためのオプション
# -Os はコードサイズを重視して最適化する
# それ以外は使わない変数・関数を排除するフラグ
add_compile_options(-Os -ffunction-sections -fdata-sections)
add_link_options(-Wl,--gc-sections)

#* ライブラリ定義
# Nano ライブラリ
find_package(Nano REQUIRED)

# StaticMbedOS
find_package(StaticMbedOS-NUCLEO_F446RE REQUIRED)

# F446RE 向けの NanoHW MbedImpl
nano_hw_mbed_impl(NanoHWImpl_F446RE StaticMbedOS-NUCLEO_F446RE)

# STM32 HAL ライブラリは F3, F4 などのシリーズ別で提供される
# そのため、 find_package し、その後関数を実行することで、
# 特定ターゲット向けのライブラリを生成する

# STM32 F3 系の HAL ライブラリ
find_package(STM32HALF3xx REQUIRED)
# HAL ライブラリの名前を STM32HALF303x8 として作成する
STM32HALF3xx(STM32HALF303x8 STM32F303x8)

# STM32 F4 系の HAL ライブラリ
find_package(STM32HALF4xx REQUIRED)
# HAL ライブラリの名前を STM32HALF446RE として作成する
STM32HALF4xx(STM32HALF446RE STM32F446xx)

# src/CMakeLists.txt を読み込む
add_subdirectory(src) # プロジェクトの実行ファイルを定義するフォルダ

# lib/CMakeLists.txt を読み込む
add_subdirectory(lib) # プロジェクトのライブラリを定義するフォルダ
