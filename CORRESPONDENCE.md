# Binary-to-source correspondence (verified 2026-11-23)

## Distributed binaries
| Release artifact | File | SHA-256 |
|---|---|---|
| AAB 1.0.8 (18) chess-1.0.8-18-release.aab and AAB 1.0.8 (19) chess-1.0.8-19-release.aab — identical in both | base/lib/arm64-v8a/libstockfish.so (2,649,912 B) | 1a17fc46fa2e497a0f065e1c4ecc5579638c0c0fb54e704931d749f1e9d1050e |
| same | base/lib/armeabi-v7a/libstockfish.so (2,193,336 B) | ca8d71b2fc73dd19cfebc06d36b36b9dd32d4ce42034a097e9da2b9eafdbd8b7 |
| same | base/lib/x86_64/libstockfish.so (2,686,984 B) | 619e971d5ff2e2aae1b0b929a127e44b70ce7cc926b7fdc8315ffe6b7fb0ece2 |
| Web 18 and Web 19 (identical) | stockfish/stockfish-19-lite-single.js | d3344124ab067fb0b90ee77873bb8e9fbf5fc01bc525fe714b0f942581e889e6 |
| same | stockfish/stockfish-19-lite-single.wasm | 57ac2d72312aba346760e3f173f687a8c211208e97a87268436f7f0e10bb5387 |
| same | stockfish/COPYING.txt | 0b383d5a63da644f628d99c33976ea6487ed89aaa59f0b3257992deac1171e6b |

## Android evidence
Rebuilt from THIS package's `android/` tree (copied to a scratch directory) with NDK 28.2.13676358, CMake 3.22.1,
RelWithDebInfo, android-21, -std=c++17, then `llvm-strip --strip-unneeded`:
| ABI | Rebuilt size = shipped size | Differing bytes | Where |
|---|---|---|---|
| arm64-v8a | 2,649,912 = 2,649,912 | 20 | bytes 737–756 = GNU build-ID descriptor (shipped d828ec0d…, rebuilt 7b095185…) |
| armeabi-v7a | 2,193,336 = 2,193,336 | 20 | bytes 509–528 = GNU build-ID descriptor |
| x86_64 | 2,686,984 = 2,686,984 | 20 | bytes 737–756 = GNU build-ID descriptor |
All code, data, symbol and network bytes are identical. The build ID is a hash that includes build-machine paths
from the (stripped) debug information, so it differs between build directories.

## Web evidence
The distributed .js/.wasm/COPYING.txt are byte-identical to the upstream author's npm release `stockfish@19.0.0`
(npm archive SHA-256 b1579b00ca456768c637bd5e5313830fb535ade04e87a5da53182c0a5eb6e05d), whose source is
`upstream/stockfish.js-19.0.0.tar.gz`. NOT REPRODUCED LOCALLY: the Web .js/.wasm were not rebuilt from source here (emscripten 3.1.7 not installed); their
correspondence rests on byte-identity with the upstream author's published release, not on a local build.

## Android 1.0.8 (19) and later — libstockfish_uci.so (verified 2026-11-26)
| ABI | Size | SHA-256 of the distributed file |
|---|---|---|
| arm64-v8a | 2,036,368 B | 40f289e3f58163f663befda92f1749ab317b1470be9a0dd0edaef668050889b8 |
| armeabi-v7a | 1,746,452 B | 39e879231bcc58a403c29c8bb262ebc725ea51215fa7edb69977fe54191441d7 |
| x86_64 | 2,084,456 B | a99dde6db7fa03ff1838375ab9df10b71feeb4dec599498c619afd3102da4ea4 |
Rebuilt with `android-uci/build.sh` from this package: same size; after removing the `.note.gnu.build-id` section
from both, the files are byte-identical. The build ID differs because it depends on the build directory.

## Network licence — CC0 1.0
- The file is byte-identical to https://tests.stockfishchess.org/api/nn/nn-61e7af4bb97d.nnue
  (SHA-256 61e7af4bb97d51eeeb25d322916f86513b5cd3a827ce189c98c6e31946f99e5b, 1,166,381 bytes).
- The official Fishtest network page (https://tests.stockfishchess.org/nns?network_name=nn-61e7af4bb97d) lists this
  network, uploaded by sscg13 on 2026-08-03, under the Fishtest upload terms: "By uploading, you license your network
  under a CC0 license."
- Author attribution: sscg13 (https://github.com/sscg13).
