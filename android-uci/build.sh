#!/bin/sh
# Builds libstockfish_uci.so for each ABI into android-uci/out/<abi>/.
# Requires the Android SDK with NDK 28.2.13676358 and CMake 3.22.1.
set -eu
cd "$(dirname "$0")"
SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
NDK="${ANDROID_NDK:-$SDK/ndk/28.2.13676358}"
CMAKE="$SDK/cmake/3.22.1/bin/cmake"
NINJA="$SDK/cmake/3.22.1/bin/ninja"
OUT=out
for ABI in arm64-v8a armeabi-v7a x86_64; do
  B="build/$ABI"
  "$CMAKE" -S . -B "$B" -G Ninja -DCMAKE_MAKE_PROGRAM="$NINJA" \
    -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$ABI" -DANDROID_PLATFORM=android-24 \
    -DANDROID_STL=c++_static -DCMAKE_BUILD_TYPE=Release >/dev/null
  # Run from the build dir so incbin finds the copied network file.
  (cd "$B" && "$NINJA" >/dev/null)
  mkdir -p "$OUT/$ABI"
  "$NDK/toolchains/llvm/prebuilt/$(uname -s | tr A-Z a-z)-x86_64/bin/llvm-strip" \
    -o "$OUT/$ABI/libstockfish_uci.so" "$B/libstockfish_uci.so"
  echo "$ABI: $(wc -c < "$OUT/$ABI/libstockfish_uci.so") bytes"
done
