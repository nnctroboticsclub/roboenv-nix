# ==============================================================================
# Clang ARM Toolchain File for arm-none-eabi
# ==============================================================================

# ------------------------------------------------------------------------------
# System Configuration
# ------------------------------------------------------------------------------
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_COMPILER "@ClangRootDir@/bin/clang")
set(CMAKE_CXX_COMPILER "@ClangRootDir@/bin/clang++")
set(CMAKE_ASM_COMPILER "@ClangRootDir@/bin/clang")
set(CMAKE_AR "@LLVMRootDir@/bin/llvm-ar" CACHE FILEPATH "Archiver")
set(CMAKE_RANLIB "@LLVMRootDir@/bin/llvm-ranlib" CACHE FILEPATH "Ranlib")
set(CMAKE_OBJCOPY "@ArmToolchainDir@/bin/arm-none-eabi-objcopy" CACHE FILEPATH "Objcopy")
set(CMAKE_OBJDUMP "@ArmToolchainDir@/bin/arm-none-eabi-objdump" CACHE FILEPATH "Objdump")
set(CMAKE_SIZE "@ArmToolchainDir@/bin/arm-none-eabi-size" CACHE FILEPATH "Size")

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

set(CMAKE_C_FLAGS_INIT "-target arm-none-eabi -ffunction-sections -fdata-sections")
set(CMAKE_CXX_FLAGS_INIT "-target arm-none-eabi -ffunction-sections -fdata-sections -fno-exceptions -fno-rtti")
set(CMAKE_ASM_FLAGS_INIT "-target arm-none-eabi")

# ------------------------------------------------------------------------------
# Linker Flags
# ------------------------------------------------------------------------------
set(ARM_LINKER_FLAGS
    "-target arm-none-eabi"
    "-Wl,--gc-sections"
    "-Wl,--no-dynamic-linker"
    "-L@ArmToolchainDir@/lib/gcc/arm-none-eabi/14.2.1/thumb/v7e-m+fp/softfp"
    "-L@ArmToolchainDir@/lib/gcc/arm-none-eabi/14.2.1"
    "-L@ArmToolchainDir@/arm-none-eabi/lib/thumb/v7e-m+fp/softfp"
    "-L@ArmToolchainDir@/arm-none-eabi/lib"
    "-Wl,--defsym=_start=Reset_Handler"
    "-Wl,--allow-multiple-definition"
    "-nostdlib++"
    "-fno-exceptions"
    "-fno-rtti"
    "-rtlib=libgcc"
    "-Wl,--start-group"
    "-lstdc++_nano"
    "-lsupc++"
    "-lm"
    "-lc_nano"
    "-lgcc"
    "-lnosys"
    "-Wl,--end-group"
    "--ld-path=@ArmLinker@"
)

string(REPLACE ";" " " ARM_LINKER_FLAGS_STR "${ARM_LINKER_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS "${ARM_LINKER_FLAGS_STR}")

# ------------------------------------------------------------------------------
# Cleanup: Unset Internal Variables
# ------------------------------------------------------------------------------
# Unset temporary variables used in this file
unset(ARM_LINKER_FLAGS)
unset(ARM_LINKER_FLAGS_STR)
unset(ARM_TARGET_TRIPLE)
