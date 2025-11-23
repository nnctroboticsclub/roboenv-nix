#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

dependencies=("$@")

# Remove "::" from dependency names to get package names
packageNames=()
for dep in "${dependencies[@]}"; do
  packageName="${dep//::/}"
  packageNames+=("$packageName")
done

#* Generate CMake target configuration file to stdout
# Dependencies
for pkg in "${packageNames[@]}"; do
  echo "find_package(${pkg} REQUIRED)"
done

cat STM32HALConfig.cmake | bash processTemplate
