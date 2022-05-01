#!/bin/sh

RUST_TRIPLET=$1

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable-${RUST_TRIPLET} -y
/root/.cargo/bin/rustup install 1.60.0
/root/.cargo/bin/rustc --version
/root/.cargo/bin/cargo --version
