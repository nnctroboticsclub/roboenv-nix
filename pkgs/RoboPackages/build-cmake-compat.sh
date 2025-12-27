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

check_env_var_set "LIB_NAME"
check_env_var_set "LIB_ROOT"

#* Generate CMake target
echo "# Auto-generated CMake configuration for $LIB_NAME"
echo "if(NOT TARGET $LIB_NAME)"
echo "  add_subdirectory($LIB_ROOT \$\{CMAKE_CURRENT_BINARY_DIR\}/$LIB_NAME)"
echo "endif()"