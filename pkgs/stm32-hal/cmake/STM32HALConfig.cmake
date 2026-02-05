if (NOT TARGET @LIB_NAME@)
    find_package(CMSIS5 REQUIRED)

    file(GLOB HAL_SOURCES @HAL_ROOT@/Src/*.c)
    list(FILTER HAL_SOURCES EXCLUDE REGEX "template\.c$")
    add_library(@LIB_NAME@ ${HAL_SOURCES})
    unset(HAL_SOURCES)

    target_link_libraries(@LIB_NAME@ PUBLIC
        @HAL_DEPENDENCIES@
        CMSIS5::CoreM
        @LIB_NAME@Config
    )

    target_include_directories(@LIB_NAME@ PUBLIC @HAL_ROOT@/Inc)

    target_compile_options(@LIB_NAME@ PUBLIC
        -ffunction-sections -fdata-sections -fno-exceptions
        # Language specific options
        $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti -fno-threadsafe-statics -fuse-cxa-atexit>
        $<$<COMPILE_LANGUAGE:ASM>:-x assembler-with-cpp>
    )
    if ("${USING_TOOLCHAIN}" STREQUAL "GNU")
        target_compile_options(@LIB_NAME@ PUBLIC -specs=nano.specs -specs=nosys.specs)
    endif()

    target_link_options(@LIB_NAME@ PUBLIC
        -Wl,-T,@HAL_LD@
        -lc -lm
    )
    if ("${USING_TOOLCHAIN}" STREQUAL "GNU")
        target_link_options(@LIB_NAME@ PUBLIC -specs=nano.specs -specs=nosys.specs)
    endif()
endif()