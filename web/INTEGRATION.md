# Web integration
The three files in this directory are deployed unmodified at `https://mychessplay.web.app/stockfish/`.
The Chess Analyzer Web app creates `new Worker('stockfish/stockfish-19-lite-single.js')`, sends UCI commands with
`postMessage(string)` and reads UCI output lines from `onmessage`. Source and build instructions: `../upstream/stockfish.js-19.0.0.tar.gz`, `../BUILD.md`.
