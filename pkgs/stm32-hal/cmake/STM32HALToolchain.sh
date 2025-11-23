#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

dependencies=("$@")

#* Generate CMake target configuration file to stdout
cat STM32HALToolchain.cmake | bash processTemplate
