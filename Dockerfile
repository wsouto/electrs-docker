# Build Electrs from Github Repository

FROM ubuntu:jammy AS base

LABEL maintainer="Walter Souto <wsouto@gmail.com>"

RUN apt update -qy
RUN apt install -qy librocksdb-dev

FROM base as build

# RUN apt install -qy git cargo clang cmake build-essential
RUN apt install -qy git cargo clang cmake

WORKDIR /build

ARG TAG=v0.10.4

RUN git clone --branch $TAG "https://github.com/romanz/electrs.git" .
RUN cargo build --release --bin electrs

FROM base as deploy

COPY --from=build /build/target/release/electrs /bin/electrs

EXPOSE 50001

# ENTRYPOINT ["electrs"]
CMD ["electrs", "--conf", "/data/config.toml"]

