

#!/bin/bash

RUST_C="nightly-2022-07-09"

sudo apt install -y git clang curl libssl-dev llvm libudev-dev && \
curl https://sh.rustup.rs -sSf | sh -s -- -y && \
export PATH="$PATH:$HOME/.cargo/bin" && \
rustup toolchain uninstall $(rustup toolchain list) && \
rustup toolchain install $RUST_C && \
rustup target add wasm32-unknown-unknown --toolchain $RUST_C  && \
rustup default $RUST_C && \
rustup show
