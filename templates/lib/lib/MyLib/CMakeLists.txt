# ライブラリのターゲットを作成する
# `INTERFACE` はヘッダーのみのライブラリ
# `STATIC` はソースファイルを含むライブラリ
# リンクするライブラリはアプリケーション側からは変更できないので、 STATIC を扱う場合注意すること
add_library(MyLib STATIC
  # (STATIC の場合のみ) 空白区切りソースファイルのリスト
  src/lib.cpp
)

# インストール情報として名前空間付きのターゲットをエイリアスとして作成する
add_library(TheLibrary::MyLib ALIAS MyLib)

# インクルードパスの指定
# `INTERFACE` はこのライブラリがリンクされるターゲットに反映される指定子
# `PRIVATE` はこのライブラリをビルドする際にのみ適応される指定子
# `PUBLIC` はこのライブラリをビルドする際とリンクされるライブラリがビルドされる際に適応される
# また、このライブラリがリンクされるターゲットがリンクされるターゲットを含め、再帰的に適応される
target_include_directories(MyLib PUBLIC
  # ビルド時は ${CMAKE_CURRENT_SOURCE_DIR}/include を使う
  # ここで、 ${CMAKE_CURRENT_SOURCE_DIR} はこの CMakeLists.txt が配置されているフォルダを指す
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>

  # インストール時はインストール先からみて include/TheLibrary/MyLib をインクルードパスに指定する
  # ここでは、include/(プロジェクト名)/(ライブラリ名) の形式で指定している
  $<INSTALL_INTERFACE:include/TheLibrary/MyLib>
)

# ライブラリの指定
# `INTERFACE`, `PRIVATE`, `PUBLIC` は target_include_directories と同等の扱い
# ここで指定されたライブラリが対象ライブラリ・依存ターゲットのビルドに用いられる
# CMake ターゲット以外 (e.g. `m` (libm.a)) が指定されるとリンク時のみで使用される
# target_link_libraries(MyLib PUBLIC
#   SomeLibrary1 (ダミー)
#   SomeLibrary2 (ダミー)
# )

# ターゲット集合 `TheLibraryTargets` にターゲット `MyLib` を追加する
install(TARGETS MyLib
  # ターゲット集合 TheLibraryTargets を指定
  EXPORT TheLibraryTargets
  # インクルードパス INSTALL_INTERFACE と同じものにする
  # このコマンドでファイルを配置し、 target_include_directories でそれを使うように指示している
  INCLUDES DESTINATION include/TheLibrary/MyLib
)

install(DIRECTORY include/
  DESTINATION include/TheLibrary/MyLib
  FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)
