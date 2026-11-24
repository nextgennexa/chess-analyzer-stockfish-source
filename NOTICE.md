# Origin and modification notices

## Stockfish engine source (android/lite/src, 50 files)
- Origin: https://github.com/nmrugg/stockfish.js tag v19.0.0 — `src/` directory. Stockfish.js 19 is based on
  Stockfish (official-stockfish/Stockfish) by T. Romstad, M. Costalba, J. Kiiski, G. Linscott and the
  contributors listed in `AUTHORS`; the JS/WASM port is (c) Chess.com, LLC / Nathan Rugg. Licence: GPL-3.0.
- Upstream archive SHA-256: 183b576fa9c8610a9be48c6e5b97506502985e64a771e769a16dbecf2f125d54 (copy in `upstream/`).
- MODIFIED by Chess Analyzer (2026-10-17): `src/main.cpp` — one line, `uci.loop();` → `uci->loop();`
  (the native build holds the UCI engine in a std::unique_ptr). See `patches/main.cpp.patch`.
  The other 49 source files are byte-identical to upstream.

## NNUE network (android/lite/nn-61e7af4bb97d.nnue)
- Name nn-61e7af4bb97d, SHA-256 61e7af4bb97d51eeeb25d322916f86513b5cd3a827ce189c98c6e31946f99e5b, 1,166,381 bytes.
- Source: https://tests.stockfishchess.org/api/nn/nn-61e7af4bb97d.nnue — Stockfish 19 "lite" network credited by the
  upstream README to sscg13 (https://github.com/sscg13/Stockfish/tree/sf19-1mb). Unmodified. Embedded in the binary at
  build time (`USE_LITE_NET`). Licence: UNRESOLVED — see `CORRESPONDENCE.md` § Network licence.

## Flutter plugin `stockfish` 1.8.1 (Arjan Aswal, GPL-3.0)
- Origin: https://pub.dev/packages/stockfish version 1.8.1 (archive SHA-256
  b27956fa6c21f8637db62411c564d1ba1d0b0e9e27ee928f42a85367da891fa0, copy in `upstream/`).
- Unmodified: all Dart files (`dart-plugin/lib`), pubspec.yaml, LICENSE, Java plugin class, AndroidManifest,
  settings.gradle, gradle.properties.
- MODIFIED by Chess Analyzer (2026-10-14 / 2026-10-17):
  - `android/ffi.cpp` — derived from the plugin's `ios/FlutterStockfish/ffi.cpp`: calls `stockfish_engine_main`
    instead of `main`, passes argv[0] "stockfish-lite", drops iOS-only includes (`patches/android-ffi.cpp.patch`).
    `android/ffi.h` is identical to the plugin's iOS `ffi.h`.
  - `android/CMakeLists.txt` — rewritten: builds the lite engine from `lite/src`, embeds and SHA-256-checks the
    network, renames the engine entry point, -O2, 16 KB page alignment, per-ABI flags (`patches/android-CMakeLists.txt.patch`).
  - `android/build.gradle` — removed the obsolete buildscript/jcenter block (`patches/android-build.gradle.patch`).

## Web engine (web/)
- `stockfish-19-lite-single.js` / `.wasm` / `COPYING.txt`: byte-identical to the files published by the upstream
  author in npm package `stockfish@19.0.0` (archive SHA-256 b1579b00ca456768c637bd5e5313830fb535ade04e87a5da53182c0a5eb6e05d).
  Not modified. Source = `upstream/stockfish.js-19.0.0.tar.gz`.

## Acknowledgements
- Stockfish: by Tord Romstad, Marco Costalba, Joona Kiiski, Gary Linscott and the Stockfish developers (see `AUTHORS`),
  https://stockfishchess.org — free software under the GNU General Public License version 3 (`COPYING`).
- Stockfish.js: by Nathan Rugg / Chess.com, LLC (https://github.com/nmrugg/stockfish.js), GPL-3.0.
- Flutter plugin `stockfish`: by Arjan Aswal (https://github.com/ArjanAswal/stockfish), GPL-3.0.
- NNUE network nn-61e7af4bb97d: by sscg13 (https://github.com/sscg13). Licence UNRESOLVED (see CORRESPONDENCE.md).
- Training data: Stockfish networks are trained on data provided by the Leela Chess Zero project
  (https://lczero.org), made available under the Open Database License (ODbL),
  https://opendatacommons.org/licenses/odbl/1-0/. Whether this specific network used such data was not verified.
