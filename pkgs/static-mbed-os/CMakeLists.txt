cmake_minimum_required(VERSION 3.19)
cmake_policy(VERSION 3.19)

set(CMAKE_INSTALL_MESSAGE NEVER)
set(MBED_APP_JSON_PATH mbed_app.json)
set(MBED_TOOLCHAIN GCC_ARM)
set(MBED_ENABLE_TESTING OFF)
set(MBED_CREATE_PYTHON_VENV OFF)
set(SMO_VERBOSE_INSTALL_LOG OFF)
set(SMO_V1_COMPAT OFF)

set(static_mbed_os_target_name "static-mbed-os-${MBED_TARGET}")
string(TOLOWER ${MBED_TARGET} MBED_TARGET_LOWER)

include(TargetDumper)
include(DependencyFinder)

function(fix_toolchain_bin)
  set(CMAKE_C_COMPILER "${CMAKE_C_COMPILER}" CACHE FILEPATH "C Compiler" FORCE)
  set(CMAKE_CXX_COMPILER "${CMAKE_CXX_COMPILER}" CACHE FILEPATH "CXX Compiler" FORCE)
  set(CMAKE_ASM_COMPILER "${CMAKE_ASM_COMPILER}" CACHE FILEPATH "ASM Compiler" FORCE)
  set(CMAKE_OBJCOPY "${CMAKE_OBJCOPY}" CACHE FILEPATH "Elf to bin/hex conversion program" FORCE)
  set(CMAKE_OBJDUMP "${CMAKE_OBJDUMP}" CACHE FILEPATH "Objdump program" FORCE)
  set(CMAKE_SIZE "${CMAKE_SIZE}" CACHE FILEPATH "Size program" FORCE)
  message(STATUS "Using Toolchain")
  message(STATUS "  - CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
  message(STATUS "  - CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
  message(STATUS "  - CMAKE_ASM_COMPILER: ${CMAKE_ASM_COMPILER}")
  message(STATUS "  - CMAKE_OBJCOPY: ${CMAKE_OBJCOPY}")
  message(STATUS "  - CMAKE_OBJDUMP: ${CMAKE_OBJDUMP}")
  message(STATUS "  - CMAKE_SIZE: ${CMAKE_SIZE}")
endfunction()

if(TOOLCHAIN_MODE STREQUAL "GNU")
  include(GccArmToolchain)
  fix_toolchain_bin()

  include(MbedCE-Toolchain)
  include(GccArmToolchain)

  string(REPLACE " -Wl,--cref" "" CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT}")
elseif(TOOLCHAIN_MODE STREQUAL "LLVM")
  include(ClangArmToolchain)
  fix_toolchain_bin()

  include(MbedCE-Toolchain)
  set(MBED_C_FLAGS ${CMAKE_C_FLAGS_INIT})
  set(MBED_CXX_FLAGS ${CMAKE_CXX_FLAGS_INIT})
  set(MBED_ASM_FLAGS ${CMAKE_ASM_FLAGS_INIT})
  set(MBED_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS_INIT})
  string(REPLACE "-Wno-packed-bitfield-compat" "-Wno-padded-bitfield" MBED_C_FLAGS "${MBED_C_FLAGS}")
  string(REPLACE "-Wno-packed-bitfield-compat" "-Wno-padded-bitfield" MBED_CXX_FLAGS "${MBED_CXX_FLAGS}")

  include(ClangArmToolchain)
  set(CMAKE_C_FLAGS_INIT "${MBED_C_FLAGS}")
  set(CMAKE_CXX_FLAGS_INIT "${MBED_CXX_FLAGS}")
  set(CMAKE_ASM_FLAGS_INIT "${MBED_ASM_FLAGS}")
  set(CMAKE_EXE_LINKER_FLAGS_INIT "${MBED_EXE_LINKER_FLAGS}")
  unset(MBED_C_FLAGS)
  unset(MBED_CXX_FLAGS)
  unset(MBED_ASM_FLAGS)
  unset(MBED_EXE_LINKER_FLAGS)

  string(REPLACE " -Wl,--cref" "" CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT}")

  add_compile_options(-Wno-register)
  add_compile_options(-fshort-enums)

  message(STATUS "Using Toolchain Flags")
  message(STATUS "  - CMAKE_C_FLAGS_INIT: ${CMAKE_C_FLAGS_INIT}")
  message(STATUS "  - CMAKE_CXX_FLAGS_INIT: ${CMAKE_CXX_FLAGS_INIT}")
  message(STATUS "  - CMAKE_ASM_FLAGS_INIT: ${CMAKE_ASM_FLAGS_INIT}")
  message(STATUS "  - CMAKE_EXE_LINKER_FLAGS_INIT: ${CMAKE_EXE_LINKER_FLAGS_INIT}")
else()
  message(FATAL_ERROR "Unsupported TOOLCHAIN_MODE: ${TOOLCHAIN_MODE}")
endif()

# ccache support
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
  message(STATUS "ccache found: ${CCACHE_PROGRAM}")
  set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" CACHE STRING "C Compiler Launcher" FORCE)
  set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" CACHE STRING "CXX Compiler Launcher" FORCE)
  set(CMAKE_ASM_COMPILER_LAUNCHER "${CCACHE_PROGRAM}" CACHE STRING "ASM Compiler Launcher" FORCE)
endif()

project(static-mbed-os VERSION 1.0.4 LANGUAGES CXX)
include(MbedCE)

message(STATUS "Flags")
message(STATUS "  - CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(STATUS "  - CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(STATUS "  - CMAKE_ASM_FLAGS: ${CMAKE_ASM_FLAGS}")
message(STATUS "  - CMAKE_EXE_LINKER_FLAGS: ${CMAKE_EXE_LINKER_FLAGS}")

#* Target

add_library(${static_mbed_os_target_name} STATIC mbed-os.cpp)
target_link_libraries(${static_mbed_os_target_name} PRIVATE mbed-os)

#* Dump target info
# Include files
list_dep_targets(${static_mbed_os_target_name} mbed_os_dependencies)

set(include_files "")
foreach(dep ${mbed_os_dependencies})
  if(NOT TARGET ${dep})
    continue()
  endif()

  get_target_property(includes ${dep} INTERFACE_INCLUDE_DIRECTORIES)
  if (NOT includes)
    continue()
  endif()

  foreach(include ${includes})
    if (NOT IS_DIRECTORY ${include})
      continue()
    endif()

    if (${SMO_VERBOSE_INSTALL_LOG})
      message(STATUS "include: ${include}")
    endif()

    # If ${include} contains 'include' in the path, install it as a directory
    # else fallthrough to file installation
    string(FIND ${include} "include" pos)
    string(FIND ${include} "STM32Cube_FW" pos)
    if (pos EQUAL -1)
      if (${SMO_VERBOSE_INSTALL_LOG})
        message(STATUS "  mode: file")
      endif()
      set(full_install FALSE)
    else()
      if (${SMO_VERBOSE_INSTALL_LOG})
        message(STATUS "  mode: directory")
      endif()
      set(full_install TRUE)
    endif()

    if (${full_install} EQUAL FALSE)
      # Selects file with no extension
      set(remove_list "")
      foreach(file ${files_no_ext})
        # ${file} is a directory, remove it from the list
        if (IS_DIRECTORY ${file})
          if (${SMO_VERBOSE_INSTALL_LOG})
            message(STATUS "  ${file} is a directory, remove it from the list")
          endif()
          list(APPEND remove_list "${file}")
          continue()
        endif()

        # ${file} is a file with extension, remove it from the list
        get_filename_component(file_ext ${file} EXT)
        if (NOT file_ext STREQUAL "")
          if (${SMO_VERBOSE_INSTALL_LOG})
            message(STATUS "  ${file} is a file with extension, remove it from the list")
          endif()
          list(APPEND remove_list "${file}")
        endif()
      endforeach()
      list(REMOVE_ITEM files_no_ext ${remove_list})

      # Selects *.h or *.hpp
      file(GLOB files_header "${include}/*.h" "${include}/*.hpp")

      set(entries "")
      list(APPEND entries ${files_no_ext})
      list(APPEND entries ${files_header})
    else()
      file(GLOB entries "${include}/*")
    endif()

    list(LENGTH entries num_entries)
    if (${SMO_VERBOSE_INSTALL_LOG})
      message(STATUS "  num_entries: ${num_entries}")
    endif()

    set(dirs "")
    set(files "")
    foreach(entry ${entries})
      # ${entry} is a directory, remove it from the list
      if (IS_DIRECTORY ${entry})
        list(APPEND dirs "${entry}")
      else()
        list(APPEND files "${entry}")
      endif()
    endforeach()

    if (${SMO_VERBOSE_INSTALL_LOG})
      message(STATUS "  files: ${files}")
    endif()
    foreach(file ${files})
      # If ${file} starts with '/' fullpath = ${file}, else fullpath = ${include}/${file}
      string(FIND ${file} "/" pos)
      if (pos EQUAL 0)
        set(fullpath ${file})
      else()
        string(REPLACE "/" "${CMAKE_CURRENT_SOURCE_DIR}/" fullpath ${file})
      endif()

      if (EXISTS ${fullpath})
        list(APPEND include_files "${fullpath}")
      endif()
    endforeach()

    if (${SMO_VERBOSE_INSTALL_LOG})
      message(STATUS "  dirs: ${dirs}")
    endif()
    foreach(dir ${dirs})
      install(
        DIRECTORY ${dir}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
      )
    endforeach()
  endforeach()
endforeach()

list(REMOVE_DUPLICATES include_files)

#* Install
set(STATIC_MBED_OS_INSTALL_NAME "StaticMbedOS-${MBED_TARGET}")

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Archive
install(
  TARGETS ${static_mbed_os_target_name}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# Includes
set(include_directories ${CMAKE_INSTALL_INCLUDEDIR})
install(
  FILES
    ${include_files}
    ${CMAKE_BINARY_DIR}/mbed-ce/generated-headers/mbed-target-config.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Linker script
get_target_property(linker_script mbed-os LINKER_SCRIPT_PATH)
set(linker_script_installation "${CMAKE_INSTALL_PREFIX}/share/cmake/StaticMbedOS@${MBED_TARGET}.ld")
install(
  FILES ${linker_script}
  DESTINATION ${CMAKE_INSTALL_PREFIX}/share/cmake
  RENAME StaticMbedOS@${MBED_TARGET}.ld
)

# Toolchain file
string(REPLACE " " ";" c_flags_list "${CMAKE_C_FLAGS_INIT}")
string(REPLACE " " ";" cxx_flags_list "${CMAKE_CXX_FLAGS_INIT}")
string(REPLACE " " ";" asm_flags_list "${CMAKE_ASM_FLAGS_INIT}")

get_target_property(compile_options_ mbed-os INTERFACE_COMPILE_OPTIONS)
set(compile_options "")
foreach(compile_option ${compile_options_})
  string(REPLACE "${CMAKE_BINARY_DIR}/mbed-ce/generated-headers" "${CMAKE_INSTALL_INCLUDEDIR}" compile_option "${compile_option}")
  list(APPEND compile_options "${compile_option}")
endforeach()

foreach(flag ${c_flags_list})
  list(APPEND compile_options "$<$<COMPILE_LANGUAGE:C>:${flag}>")
endforeach()
foreach(flag ${cxx_flags_list})
  list(APPEND compile_options "$<$<COMPILE_LANGUAGE:CXX>:${flag}>")
endforeach()
foreach(flag ${asm_flags_list})
  list(APPEND compile_options "$<$<COMPILE_LANGUAGE:ASM>:${flag}>")
endforeach()


get_target_property(compile_definitions mbed-os INTERFACE_COMPILE_DEFINITIONS)
list(APPEND compile_definitions "__MBED__=1")

get_target_property(link_options_ mbed-os INTERFACE_LINK_OPTIONS)
set(link_options "")
foreach(link_option ${link_options_})
  list(APPEND link_options "${link_option}")
endforeach()
foreach(flag ${c_flags_list})
  list(APPEND link_options "$<$<LINK_LANGUAGE:C>:${flag}>")
endforeach()
foreach(flag ${cxx_flags_list})
  list(APPEND link_options "$<$<LINK_LANGUAGE:CXX>:${flag}>")
endforeach()
foreach(flag ${asm_flags_list})
  list(APPEND link_options "$<$<LINK_LANGUAGE:ASM>:${flag}>")
endforeach()

string(REPLACE " " ";" linker_flags_list "${CMAKE_EXE_LINKER_FLAGS}")
foreach(flag ${linker_flags_list})
  list(APPEND link_options "${flag}")
endforeach()

configure_file(
  StaticMbedOSConfig-TARGET.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/cmake/StaticMbedOS-${MBED_TARGET}Config.cmake
  @ONLY
)

install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/StaticMbedOS-${MBED_TARGET}Config.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/StaticMbedOS-${MBED_TARGET}
)

if (${SMO_V1_COMPAT})
  configure_file(
    StaticMbedOSConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/StaticMbedOSConfig.cmake
    @ONLY
  )
  configure_file(
    StaticMbedOSToolchain.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/StaticMbedOSToolchain-${MBED_TARGET}.cmake
    @ONLY
  )

  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/StaticMbedOSToolchain-${MBED_TARGET}.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake
  )

  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/StaticMbedOSConfig.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/StaticMbedOS
  )
endif()