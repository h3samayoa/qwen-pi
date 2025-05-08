#!/usr/bin/env bash
set -euo pipefail

cd "$src"

echo "list dir"
ls -la

echo "current dir"
pwd

cmake -B build
cmake --build build --config Release -j"$(nproc || sysctl -n hw.ncpu)"

#mkdir -p "$out"
cp -r . "$out/"

for i in "$out/build/bin/"*; do
  if [[ -f "$i" && -x "$i" ]]; then
    #echo "Adjusting rpath for: $i"
    if [[ "$(uname)" == "Darwin" ]]; then
      install_name_tool -add_rpath "@executable_path" "$i"
    else
      patchelf --set-rpath '$ORIGIN' "$i"
    fi
  fi
done
