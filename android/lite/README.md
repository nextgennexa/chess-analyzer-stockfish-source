# Android Stockfish 19 Lite

Vendored from https://github.com/nmrugg/stockfish.js/tree/v19.0.0 (GPL-3.0; see COPYING).
Source archive SHA-256: `183b576fa9c8610a9be48c6e5b97506502985e64a771e769a16dbecf2f125d54`.

Android CMake compiles this source with `USE_LITE_NET` and the `p_hm.cpp` feature set.
The embedded network is `nn-61e7af4bb97d.nnue` from
https://tests.stockfishchess.org/api/nn/nn-61e7af4bb97d.nnue.
Its complete SHA-256 is checked by CMake; no build-time downloads are required.
The larger iOS networks and sources are not compiled into Android.

Local upstream fix: `src/main.cpp` calls `uci->loop()` because the native UCI engine
is a unique_ptr. Android uses the adjacent `../ffi.cpp` bridge, preserving the
Dart wrapper's existing exported symbols and quit handshake. CMake renames the
engine entry point to `stockfish_engine_main` to avoid host executable symbol collisions.

Validation: NDK 28.2 release compilation passed for arm64-v8a, armeabi-v7a,
and x86_64. An ARM64 emulator FFI/UCI smoke test exercises initialization,
embedded-network loading, a 20,000-node search and shutdown.
A full Flutter release APK still needs building to measure total app size.
Lite uses a smaller network and can produce different evaluations than the full engine.
