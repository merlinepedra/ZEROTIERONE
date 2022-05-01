#!/bin/sh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
/root/.cargo/bin/rustup install 1.60.0
/root/.cargo/bin/rustc --version
/root/.cargo/bin/cargo --version
