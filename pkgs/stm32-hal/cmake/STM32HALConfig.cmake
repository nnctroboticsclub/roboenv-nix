find_package(CMSIS5 REQUIRED)

# Dynamic target generator with macro define (e.g. Define STM32F303x8=1)
function(@LIB_NAME@ target_name device_macro)
    if (TARGET ${target_name})
        return()
    endif()

    file(GLOB HAL_SOURCES @HAL_ROOT@/Src/*.c)
    list(FILTER HAL_SOURCES EXCLUDE REGEX "template\.c$")
    add_library(${target_name} STATIC ${HAL_SOURCES})
    unset(HAL_SOURCES)

    target_link_libraries(${target_name} PUBLIC
        @HAL_DEPENDENCIES@
        CMSIS5::CoreM
        @LIB_NAME@Config
        m
    )

    target_include_directories(${target_name} PUBLIC @HAL_ROOT@/Inc)

    target_compile_options(${target_name} PUBLIC
        -ffunction-sections -fdata-sections -fno-exceptions
        # Language specific options
        $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti -fno-threadsafe-statics -fuse-cxa-atexit>
        $<$<COMPILE_LANGUAGE:ASM>:-x assembler-with-cpp>
    )
    if ("${USING_TOOLCHAIN}" STREQUAL "GNU")
        target_compile_options(${target_name} PUBLIC -specs=nano.specs -specs=nosys.specs)
    endif()

    target_link_options(${target_name} PUBLIC -Wl,-T,@HAL_LD@)
    target_link_options(${target_name} PUBLIC -specs=nano.specs -specs=nosys.specs)
    target_compile_definitions(${target_name} PUBLIC ${device_macro}=1)
endfunction()