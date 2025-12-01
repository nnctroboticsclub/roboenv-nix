#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

function check_env_var_set() {
    local var_name="$1"
    if [[ -z "${!var_name:-}" ]]; then
        echo "Error: Environment variable '$var_name' is not set." >&2
        exit 1
    fi
}

# Ensure $LIB_NAME, $LIB_SRC, $LIB_INCLUDE, and $LIB_DEPS are set
check_env_var_set "LIB_NAME"
check_env_var_set "LIB_SRC"
check_env_var_set "LIB_INCLUDE"
check_env_var_set "LIB_DEPS"

IFS=';' read -r -a LIB_SRC_ARR <<< "$LIB_SRC"
IFS=';' read -r -a LIB_INCLUDE_ARR <<< "$LIB_INCLUDE"
IFS=';' read -r -a LIB_DEPS_ARR <<< "$LIB_DEPS"

#* Generate CMake target
echo "# Auto-generated CMake configuration for $LIB_NAME"
echo "if(NOT TARGET $LIB_NAME)"
for dep in "${LIB_DEPS_ARR[@]}"; do
    echo "find_package(${dep} REQUIRED)"
done
echo ""
echo "add_library($LIB_NAME"
for src in "${LIB_SRC_ARR[@]}"; do
    echo "    ${src}"
done
echo ")"
echo ""
echo "target_link_libraries($LIB_NAME PUBLIC"
for dep in "${LIB_DEPS_ARR[@]}"; do
    echo "    ${dep}"
done
echo ")"
echo ""
echo "target_include_directories($LIB_NAME PUBLIC"
for inc in "${LIB_INCLUDE_ARR[@]}"; do
    echo "    ${inc}"
done
echo ")"
echo "endif()"