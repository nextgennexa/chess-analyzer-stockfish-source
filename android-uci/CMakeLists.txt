# Builds Stockfish 19 Lite as a standalone Android executable that Chess
# Analyzer (Android 1.0.8 build 19 and later) launches as a separate process
# and talks to over UCI (stdin/stdout). Same sources, defines and embedded
# network as the earlier in-process build in ../android/CMakeLists.txt; only
# the entry point differs (the normal Stockfish `main`, no FFI bridge).
#
# The output is named libstockfish_uci.so so Android packages it under
# lib/<abi>/ and installs it into the app's read-only nativeLibraryDir, the
# only app location from which execution is permitted on Android 10+.
cmake_minimum_required(VERSION 3.18)
project(stockfish_uci LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

get_filename_component(LITE_ROOT
  "${CMAKE_CURRENT_SOURCE_DIR}/../android/lite" ABSOLUTE)
set(LITE_NET "${LITE_ROOT}/nn-61e7af4bb97d.nnue")
file(SHA256 "${LITE_NET}" NET_SHA)
if(NOT NET_SHA STREQUAL "61e7af4bb97d51eeeb25d322916f86513b5cd3a827ce189c98c6e31946f99e5b")
  message(FATAL_ERROR "Stockfish Lite NNUE checksum mismatch")
endif()
# incbin embeds the net from the working directory of the compile step.
configure_file("${LITE_NET}" "${CMAKE_CURRENT_BINARY_DIR}/nn-61e7af4bb97d.nnue" COPYONLY)
file(GLOB ENGINE_SOURCES "${LITE_ROOT}/src/*.cpp" "${LITE_ROOT}/src/nnue/*.cpp")
add_executable(stockfish_uci ${ENGINE_SOURCES}
  "${LITE_ROOT}/src/nnue/features/p_hm.cpp"
  "${LITE_ROOT}/src/syzygy/tbprobe.cpp")
set_target_properties(stockfish_uci PROPERTIES OUTPUT_NAME "libstockfish_uci.so")
target_compile_definitions(stockfish_uci PRIVATE USE_LITE_NET USE_PTHREADS NDEBUG)
target_compile_options(stockfish_uci PRIVATE -fno-exceptions -O2)
target_link_options(stockfish_uci PRIVATE -pie
  -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384)
if(ANDROID_ABI STREQUAL "arm64-v8a")
  target_compile_definitions(stockfish_uci PRIVATE IS_64BIT USE_POPCNT USE_NEON=8)
elseif(ANDROID_ABI STREQUAL "x86_64")
  target_compile_definitions(stockfish_uci PRIVATE IS_64BIT)
endif()
