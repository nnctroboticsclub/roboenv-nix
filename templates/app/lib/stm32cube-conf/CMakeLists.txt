# STM32 HAL の設定を定義するターゲット
# 設定ターゲットの名前は変更できない
# 簡素化のため、同じ include ディレクトリを用いている

# STM32HALF3xx の設定を定義するターゲット
add_library(STM32HALF3xxConfig INTERFACE)
target_include_directories(STM32HALF3xxConfig INTERFACE include)

# STM32HALF4xx の設定を定義するターゲット
add_library(STM32HALF4xxConfig INTERFACE)
target_include_directories(STM32HALF4xxConfig INTERFACE include)