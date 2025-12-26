set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_COMPILER_TARGET arm-none-eabi)
set(CMAKE_C_COMPILER "@ClangRootDir@/bin/clang")
set(CMAKE_C_FLAGS_INIT "-fshort-enums")

set(CMAKE_CXX_COMPILER_TARGET arm-none-eabi)
set(CMAKE_CXX_COMPILER "@ClangRootDir@/bin/clang++")
set(CMAKE_CXX_FLAGS_INIT "-fshort-enums")

set(CMAKE_ASM_COMPILER "@ArmToolchainDir@/bin/arm-none-eabi-gcc")

set(CMAKE_OBJCOPY "@ArmToolchainDir@/bin/arm-none-eabi-objcopy")
set(CMAKE_OBJDUMP "@ArmToolchainDir@/bin/arm-none-eabi-objdump")
set(CMAKE_SIZE "@ArmToolchainDir@/bin/arm-none-eabi-size")
set_property(GLOBAL PROPERTY ELF2BIN "@ArmToolchainDir@/bin/arm-none-eabi-objcopy")


set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)


# ------------------------------------------------------------------------------
# Compiler Flags
# ------------------------------------------------------------------------------
include_directories(SYSTEM
    "@ArmToolchainDir@/include"
    "@ArmToolchainDir@/arm-none-eabi/include/c++/14.2.1/backward"
    "@ArmToolchainDir@/arm-none-eabi/include/c++/14.2.1/arm-none-eabi"
    "@ArmToolchainDir@/arm-none-eabi/include/c++/14.2.1"
    "@ArmToolchainDir@/arm-none-eabi/include"
    "@ArmToolchainDir@/lib/gcc/arm-none-eabi/14.2.1/include-fixed"
    "@ArmToolchainDir@/lib/gcc/arm-none-eabi/14.2.1/include"
)

set(CMAKE_CXX_LINK_EXECUTABLE "@ArmToolchainDir@/bin/arm-none-eabi-g++ <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_C_LINK_EXECUTABLE "@ArmToolchainDir@/bin/arm-none-eabi-gcc <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")

set(USING_TOOLCHAIN "LLVM")