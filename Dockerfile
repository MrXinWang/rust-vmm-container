FROM ubuntu:18.04
ARG RUST_TOOLCHAIN="1.35.0"

# Adding rust binaries to PATH.
ENV PATH="$PATH:/root/.cargo/bin"

RUN apt-get update

RUN apt-get -y install gcc

# Installing rustup.
RUN apt-get -y install curl
# Install a fixed version of rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "$RUST_TOOLCHAIN"

# Installing rust tools used by the rust-vmm CI.
RUN rustup component add rustfmt
RUN rustup component add clippy
RUN cargo install cargo-kcov

# Installing other rust targets.
RUN rustup target add $(uname -m)-unknown-linux-musl

# Installing kcov dependencies.
RUN apt-get -y install cmake g++ pkg-config jq
RUN apt-get -y install libcurl4-openssl-dev libelf-dev libdw-dev binutils-dev libiberty-dev

# Installing kcov.
# For some strange reason, the command requires python3 to be installed
RUN apt-get -y install python3
RUN cargo kcov --print-install-kcov-sh | sh

# Installing python3.6 & pytest.
RUN apt-get -y install python3.6
RUN apt-get -y install python3-pip
RUN pip3 install pytest
