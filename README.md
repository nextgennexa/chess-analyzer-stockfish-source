# Stockfish source code for Chess Analyzer 1.0.8 (versions 18 and 19)

Chess Analyzer (Android package `com.nextgennexa.chess`, Web app mychessplay.web.app) includes the
Stockfish chess engine, which is free software licensed under the GNU General Public License
version 3 (see `COPYING`). This package contains the complete corresponding source code, build
scripts and data needed to rebuild the Stockfish engine binaries distributed with:

- Android 1.0.8 (versionCode 18) and 1.0.8 (versionCode 19): `lib/<abi>/libstockfish.so` for arm64-v8a, armeabi-v7a, x86_64
- Web 1.0.8 builds 18 and 19: `stockfish/stockfish-19-lite-single.js` and `stockfish-19-lite-single.wasm`

The engine binaries are identical in versions 18 and 19 (see `CORRESPONDENCE.md`).

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
| `android/` | The exact Android build tree used: CMakeLists.txt, ffi.cpp/ffi.h bridge, plugin Gradle files, `lite/` engine source + NNUE network |
| `dart-plugin/` | The Dart side of the plugin (unmodified 1.8.1) that loads and talks to the engine |
| `patches/` | Unified diffs of every Chess Analyzer change against the upstream sources |
| `web/` | The distributed Web engine files (unmodified upstream release) and how the Web app runs them |
| `SHA256SUMS` | Checksums of every file in this package |

This package contains only Stockfish and its Flutter plugin. It does not contain Chess Analyzer's
own application code, which communicates with the engine through the UCI text protocol.

## Verification status
- Android: VERIFIED — rebuilding from this package reproduces the distributed libstockfish.so except the 20-byte build ID.
- Web: NOT REPRODUCED LOCALLY — the distributed files are byte-identical to the upstream author's release; not rebuilt here.
- NNUE network licence: UNRESOLVED.

## Getting this source
<SOURCE ACCESS STATEMENT — to be finalised with legal advice before publication; see the handoff wording review.>
