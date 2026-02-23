#include <cstdio>

#include <Nano/fixed_map.hpp>
#include <f3/console.hpp>
#include <f3/peripherals/rcc.hpp>

namespace Application {
// RCCConfig, ClockOrigin などを使えるようにする
using namespace stm32f3::rcc;

// 汎用的な RCC 設定の定義
using BaremetalRCC = RCCConfig<
    // HSI, HSE の周波数を定義
    ClockOrigin{.HSI = 8000000, .HSE = 8000000},
    // PLL に HSI を 1/2 倍したものを入力し、 10 倍したものを出力する
    PLLConfig<PLLSource_HSI_D2, 10>,
    // SystemClock (CPU クロック) に PLL の出力を利用する
    SystemClockConfig<SystemClockSource::kPLL>,
    // バスクロックを指定する
    // それぞれのクロックは SystemClock から提供される
    // AHB: SystemClock / 1 (Div 1)
    // APB1: SystemClock / 1 (Div 1)
    // APB2: SystemClock / 1 (Div 1)
    BusClockConfig<AHBPrescaler::kDiv1, APB1Prescaler::kDiv1,
                   APB2Prescaler::kDiv1>>;
// RCC 定義を検証しておく
static_assert(BaremetalRCC::GetAPB1Clock() ==
              40e6);  // APB1 クロックは 1Mhz か？
static_assert(BaremetalRCC::GetAPB2Clock() ==
              40e6);  // APB2 クロックは 1Mhz か？
static_assert(BaremetalRCC::GetAHBClock() == 40e6);  // AHB クロックは 1Mhz か？

extern "C" uint32_t SystemCoreClock __attribute__((weak));

// F3Baremetal に InitRCC を提供する
// main() が実行される前にこの関数が呼ばれる
extern "C" void InitRCC() {
  Application::BaremetalRCC::ApplyConfig();

  SystemCoreClock = Application::BaremetalRCC::GetSystemClock();
}

//* UART ポートを stdout として使うための UART 設定
// ST-Link につながるピンをデフォルトで指定する stm32f3::console を利用している
// stm32f3::console ではなく、 stm32f3::USART を利用しても良い
void InitConsole() {
  // stm32f3::console::Init<RCC 型, ボーレート>() の形式で記述する
  stm32f3::console::Init<BaremetalRCC, 921600>();
}

// Newlib に write 関数を提供する
// printf などによる出力は _write によって行われる
// 省略している変数名は、ファイル記述子に対応する
extern "C" int _write(int, char* ptr, int len) {
  stm32f3::console::SerialPeripheral::Write(ptr, len);
  return len;
}
}  // namespace Application

int main() {
  // InitConsole を呼ぶ
  Application::InitConsole();

  // とりあえず Hello world!
  printf("Hello world!\n");
}