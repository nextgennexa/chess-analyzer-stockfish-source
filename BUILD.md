# Building the distributed Stockfish binaries

## Android (libstockfish.so) — VERIFIED (see CORRESPONDENCE.md)
Toolchain used for 1.0.8 (18 and 19): Android NDK 28.2.13676358, CMake 3.22.1 + Ninja (Android SDK), macOS host.
The Flutter/Android Gradle build invokes CMake on `android/CMakeLists.txt` with these settings (from the release
build's CMakeCache): build type RelWithDebInfo, `ANDROID_PLATFORM=android-21`, `CMAKE_CXX_FLAGS=-std=c++17`,
ABIs arm64-v8a, armeabi-v7a, x86_64; Android Gradle then strips debug info with `llvm-strip --strip-unneeded`.

Standalone equivalent (run from this package root):
```sh
NDK=$ANDROID_HOME/ndk/28.2.13676358
CM=$ANDROID_HOME/cmake/3.22.1/bin
for ABI in arm64-v8a armeabi-v7a x86_64; do
  $CM/cmake -S android -B build-$ABI -G Ninja -DCMAKE_MAKE_PROGRAM=$CM/ninja \
    -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=$ABI -DANDROID_PLATFORM=android-21 -DANDROID_NDK=$NDK \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_CXX_FLAGS=-std=c++17
  $CM/ninja -C build-$ABI
  $NDK/toolchains/llvm/prebuilt/<host>/bin/llvm-strip --strip-unneeded \
    -o libstockfish-$ABI.so build-$ABI/libstockfish.so
done
```
CMake verifies the network checksum and stops if `lite/nn-61e7af4bb97d.nnue` does not match.
Result: identical to the distributed library except the 20-byte GNU build ID (derived from build paths).

### Using a modified engine
The Dart plugin loads `libstockfish.so` by name (`DynamicLibrary.open('libstockfish.so')`) and talks UCI through the
`stockfish_init` / `stockfish_main` / `stockfish_stdin_write` / `stockfish_stdout_read` functions in `ffi.cpp`. A rebuilt library with the
same exported functions can replace `lib/<abi>/libstockfish.so` inside an APK; the APK must then be re-aligned
(`zipalign`) and re-signed (`apksigner`) with your own key and installed as a separate installation (Android will
not update the Play-signed app with a differently signed APK).

## Android 1.0.8 (19) and later — standalone engine program (libstockfish_uci.so) — VERIFIED
Toolchain: Android NDK 28.2.13676358, CMake 3.22.1 + Ninja (Android SDK). From this package root:
```sh
sh android-uci/build.sh        # writes android-uci/out/<abi>/libstockfish_uci.so
```
Settings: Release, `ANDROID_PLATFORM=android-24`, static libc++, -O2, PIE, 16 KB page alignment, the same `lite/`
sources, defines and embedded network as the library build. Result: identical to the distributed files except the
GNU build ID (which depends on the build directory).

### Using a modified engine (19 and later)
The app runs `libstockfish_uci.so` from its native library directory with no arguments and speaks standard UCI on
stdin/stdout. Any UCI engine built as an Android executable can replace `lib/<abi>/libstockfish_uci.so` inside the
APK; the APK must then be re-aligned (`zipalign`) and re-signed (`apksigner`) with your own key and installed as a
separate installation.

## Web (stockfish-19-lite-single.js / .wasm) — NOT REPRODUCED LOCALLY
The distributed files are the upstream author's release files (byte-identical to npm `stockfish@19.0.0`).
Upstream build instructions (README of stockfish.js v19.0.0): install emscripten 3.1.7, then from the extracted
`upstream/stockfish.js-19.0.0.tar.gz` run `./build.js` (see `./build.js --help`; `--all` builds every flavour,
including lite single-threaded). Reproducing the exact .wasm also depends on the upstream build environment;
this has not been re-verified here (emscripten is not installed on the build machine).

## How the apps run the engine
- Android 18: the app's Dart code uses the `stockfish` plugin (dart-plugin/), which loads libstockfish.so in the app
  process and exchanges UCI text lines with it.
- Android 19 and later: the app starts `libstockfish_uci.so` as a separate process and exchanges UCI text lines
  over its standard input and output.
- Web: the app starts `stockfish/stockfish-19-lite-single.js` as a Web Worker (`new Worker(...)`) and exchanges UCI
  text lines with `postMessage` / `onmessage`. The worker script loads the .wasm from the same directory.
