# Stockfish source code for Chess Analyzer 1.0.8

Chess Analyzer (Android package `com.nextgennexa.chess`, Web app mychessplay.web.app) includes the
Stockfish chess engine, which is free software licensed under the GNU General Public License
version 3 (see `COPYING`). This package contains the complete corresponding source code, build
scripts and data needed to rebuild the Stockfish engine binaries distributed with:

- Android 1.0.8 (versionCode 18): `lib/<abi>/libstockfish.so` (engine library loaded in the app), built from `android/`
- Android 1.0.8 (versionCode 19) and later: `lib/<abi>/libstockfish_uci.so` (standalone engine program that the app
  starts as a separate process and talks to over UCI), built from `android-uci/` (package r3)
- Web 1.0.8: `stockfish/stockfish-19-lite-single.js` and `stockfish-19-lite-single.wasm`

All builds use the same engine source (`android/lite/`) and network. See `CORRESPONDENCE.md`.

## Contents
| Path | What it is |
|---|---|
| `COPYING` | GNU GPL v3 licence text |
| `AUTHORS` | Stockfish authors (from upstream) |
| `NOTICE.md` | Origin of every component and the modifications made by Chess Analyzer, with dates |
| `BUILD.md` | Toolchains and commands to rebuild the Android and Web engine binaries |
| `CORRESPONDENCE.md` | Evidence that this source produces the distributed binaries; checksums |
| `upstream/stockfish.js-19.0.0.tar.gz` | Unmodified upstream source archive (nmrugg/stockfish.js tag v19.0.0) |
| `upstream/flutter-stockfish-plugin-1.8.1.tar.gz` | Unmodified upstream Flutter plugin `stockfish` 1.8.1 (pub.dev) |
| `android-uci/` | Build files for the standalone Android engine program (versionCode 19 and later): `CMakeLists.txt`, `build.sh` |
| `android/` | The exact Android build tree used for versionCode 18: CMakeLists.txt, ffi.cpp/ffi.h bridge, plugin Gradle files, `lite/` engine source + NNUE network |
| `dart-plugin/` | The Dart side of the plugin (unmodified 1.8.1) that loads and talks to the engine |
| `patches/` | Unified diffs of every Chess Analyzer change against the upstream sources |
| `web/` | The distributed Web engine files (unmodified upstream release) and how the Web app runs them |
| `SHA256SUMS` | Checksums of every file in this package |

This package contains only Stockfish and its Flutter plugin. It does not contain Chess Analyzer's
own application code, which communicates with the engine through the UCI text protocol.

## Verification status
- Android 18: VERIFIED — rebuilding from `android/` reproduces the distributed libstockfish.so except the 20-byte build ID.
- Android 19+: VERIFIED — rebuilding with `android-uci/build.sh` reproduces the distributed libstockfish_uci.so except the GNU build ID.
- Web: NOT REPRODUCED LOCALLY — the distributed files are byte-identical to the upstream author's release; not rebuilt here.
- NNUE network licence: CC0 1.0 (see `CORRESPONDENCE.md`).

## Getting this source
This source is available free of charge at https://github.com/nextgennexa/chess-analyzer-stockfish-source
(each package is a tagged release). We keep it available for as long as we distribute the matching app versions.
If the page is unavailable, write to nextgennexa.support@gmail.com and we will send the same package free of charge.
