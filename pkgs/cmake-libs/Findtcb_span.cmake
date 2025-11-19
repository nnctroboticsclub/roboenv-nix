include(FetchContent)

FetchContent_Populate(
  tcb_span
  GIT_REPOSITORY https://github.com/tcbrindle/span.git
)

add_library(tcb_span INTERFACE)
target_compile_definitions(tcb_span INTERFACE
  -DTCB_SPAN_NO_CONTRACT_CHECKING
)
target_include_directories(tcb_span INTERFACE
  ${tcb_span_SOURCE_DIR}/include
)