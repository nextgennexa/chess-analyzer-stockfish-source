cmake_minimum_required(VERSION 3.18)
project(stockfish_lite LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Pin and embed the Lite network. Android never downloads the full-size net.
set(LITE_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/lite")
set(LITE_NET "${LITE_ROOT}/nn-61e7af4bb97d.nnue")
file(SHA256 "${LITE_NET}" NET_SHA)
if(NOT NET_SHA STREQUAL "61e7af4bb97d51eeeb25d322916f86513b5cd3a827ce189c98c6e31946f99e5b")
  message(FATAL_ERROR "Stockfish Lite NNUE checksum mismatch")
endif()
configure_file("${LITE_NET}" "${CMAKE_CURRENT_BINARY_DIR}/nn-61e7af4bb97d.nnue" COPYONLY)
file(GLOB ENGINE_SOURCES "${LITE_ROOT}/src/*.cpp" "${LITE_ROOT}/src/nnue/*.cpp")
set_source_files_properties("${LITE_ROOT}/src/main.cpp" PROPERTIES COMPILE_DEFINITIONS "main=stockfish_engine_main")
add_library(stockfish SHARED ffi.cpp ${ENGINE_SOURCES}
  "${LITE_ROOT}/src/nnue/features/p_hm.cpp"
  "${LITE_ROOT}/src/syzygy/tbprobe.cpp")
target_compile_definitions(stockfish PRIVATE USE_LITE_NET USE_PTHREADS NDEBUG)
# Keep the engine itself optimized in Flutter debug builds too. Grading is
# based on fixed node counts, and matching native optimization avoids making
# development builds unnecessarily slow without changing the requested work.
target_compile_options(stockfish PRIVATE -fno-exceptions -O2)
target_link_options(stockfish PRIVATE -Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384)
if(ANDROID_ABI STREQUAL "arm64-v8a")
  target_compile_definitions(stockfish PRIVATE IS_64BIT USE_POPCNT USE_NEON=8)
elseif(ANDROID_ABI STREQUAL "x86_64")
  target_compile_definitions(stockfish PRIVATE IS_64BIT)
endif()
