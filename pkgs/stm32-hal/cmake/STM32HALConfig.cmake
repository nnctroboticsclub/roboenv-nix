if (NOT TARGET @LIB_NAME@)
    find_package(CMSIS5 REQUIRED)

    file(GLOB HAL_SOURCES @HAL_ROOT@/Src/*.c)
    list(FILTER HAL_SOURCES EXCLUDE REGEX "template\.c$")
    add_library(@LIB_NAME@ ${HAL_SOURCES})
    unset(HAL_SOURCES)

    target_link_libraries(@LIB_NAME@ PUBLIC
        @HAL_DEPENDENCIES@
        CMSIS5::CoreM
        STM32HALConfig
    )

    target_include_directories(@LIB_NAME@ PUBLIC @HAL_ROOT@/Inc)

    target_compile_options(@LIB_NAME@ PUBLIC
        # Target CPU
        -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=soft -mthumb
        # Code optimization
        -ffunction-sections -fdata-sections -fno-exceptions -fshort-enums
        -Oz -g3 -gdwarf-3
        # Language specific options
        $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti -fno-threadsafe-statics -fuse-cxa-atexit>
        $<$<COMPILE_LANGUAGE:ASM>:-x assembler-with-cpp>
    )
    if ("${USING_TOOLCHAIN}" STREQUAL "GNU")
        target_compile_options(@LIB_NAME@ PUBLIC -specs=nano.specs -specs=nosys.specs)
    endif()

    target_link_options(@LIB_NAME@ PUBLIC
        # Target CPU
        -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=soft -mthumb
        # Linker script
        -Wl,-T,@HAL_LD@
        # HAL
        -Wl,--gc-sections
        -lc -lm
    )
    target_link_options(@LIB_NAME@ PUBLIC -specs=nano.specs -specs=nosys.specs)
endif()
