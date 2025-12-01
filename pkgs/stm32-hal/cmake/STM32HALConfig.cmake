if (NOT TARGET STM32HAL)
    # -------- STM32HALConfig.cmake --------
    find_package(CMSIS5 REQUIRED)

    file(GLOB HAL_SOURCES @HAL_ROOT@/Src/*.c)
    list(FILTER HAL_SOURCES EXCLUDE REGEX "template\.c$")
    add_library(STM32HAL ${HAL_SOURCES})
    unset(HAL_SOURCES)

    target_link_libraries(STM32HAL PUBLIC
        @HAL_DEPENDENCIES@
        CMSIS5::CoreM
        STM32HALConfig
    )

    target_include_directories(STM32HAL PUBLIC @HAL_ROOT@/Inc)

    target_compile_options(STM32HAL PUBLIC
        # Target CPU
        -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=soft -mthumb
        # Newlib
        -specs=nano.specs -specs=nosys.specs
        # Code optimization
        -ffunction-sections -fdata-sections -fno-exceptions -fshort-enums
        -Oz -g3 -gdwarf-3

        # Language specific options
        $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti -fno-threadsafe-statics -fuse-cxa-atexit>
        $<$<COMPILE_LANGUAGE:ASM>:-x assembler-with-cpp>
    )
    target_link_options(STM32HAL PUBLIC
        -Wl,-T,@HAL_LD@
        -Wl,--gc-sections
        -lc -lm
    )
endif()
