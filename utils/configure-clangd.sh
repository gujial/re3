#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
cmake -S . -B build-clangd \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DREVC_VENDORED_LIBRW=ON \
  -DREVC_AUDIO=OAL \
  -DLIBRW_PLATFORM=GL3 \
  -DLIBRW_GL3_GFXLIB=GLFW
