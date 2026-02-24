# CMake のバージョン要求
cmake_minimum_required(VERSION 3.25)
cmake_policy(VERSION 3.25)

# 使うコンパイラ
# GccArmToolchain: GCC Arm embedded をつかう
# ClangArmToolchain: コンパイルに Clang を使いリンクに GCC Arm Embedded を使う
set(ROBO_TOOLCHAIN_FILE ClangArmToolchain)

enable_testing() # CTest を使うための宣言
project("TheLibrary") # プロジェクト名
enable_language(C CXX ASM) # C/C++/アセンブリ を使えるようにしておく

# C++ の標準を指定する
set(CMAKE_CXX_STANDARD 20) # C++20 を利用
set(CMAKE_CXX_STANDARD_REQUIRED ON) # C++20 を必須とする
set(CMAKE_CXX_EXTENSIONS OFF) # GCC 拡張を使わない

# 「Cortex M4 向けのビルド」と指定する
# 対象のターゲットが違う場合修正すること
add_compile_options(-mfloat-abi=softfp -mfpu=fpv4-sp-d16 -mthumb -mcpu=cortex-m4)

# デバッグ情報を付与する (デバッガで処理を追いやすくなる)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -gfull -fstandalone-debug -gdwarf-5 -gz")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -gfull -fstandalone-debug -gdwarf-5 -gz")

# バイナリサイズを小さくするためのオプション
# -Os はコードサイズを重視して最適化する
# それ以外は使わない変数・関数を排除するフラグ
add_compile_options(-Os -ffunction-sections -fdata-sections)

# src/CMakeLists.txt を読み込む
add_subdirectory(src) # プロジェクトの実行ファイルを定義するフォルダ

# lib/CMakeLists.txt を読み込む
add_subdirectory(lib) # プロジェクトのライブラリを定義するフォルダ


# ターゲット集合をインストールするように指示する
install(
  # ターゲット集合 TheLibraryTargets を指定
  EXPORT TheLibraryTargets
  # ターゲットリストファイル名を指定 (TheLibraryTargets.cmake)
  FILE TheLibraryTargets.cmake

  # TheLibrary:: を接頭辞にする
  NAMESPACE TheLibrary::

  # lib/cmake/TheLibrary にターゲットリストファイルを保存する
  # lib/cmake/TheLibrary/TheLibraryTargets.cmake が作成される
  DESTINATION lib/cmake/TheLibrary
)

# configure_package_config_file を使うための宣言
include(CMakePackageConfigHelpers)

# TheLibraryConfig.cmake.in を基に TheLibraryConfig.cmake を作成する
# この時点ではまだインストールしていない
configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/TheLibraryConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/TheLibraryConfig.cmake

  # このファイルがインストールされる際にどこにインストールされるかを指定している
  INSTALL_DESTINATION lib/cmake/TheLibrary
)

# 作成した TheLibraryConfig.cmake を lib/cmake/TheLibrary 配下に配置するように指示
install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/TheLibraryConfig.cmake
  DESTINATION lib/cmake/TheLibrary
)
