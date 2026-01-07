# Build Electrs from Github Repository

FROM debian:trixie-slim AS base

LABEL maintainer="Walter Souto <wsouto@gmail.com>"

RUN apt update -qqy
RUN apt install -qqy librocksdb-dev
RUN apt clean

FROM base AS build

# RUN apt install -qqy git cargo clang cmake build-essential
RUN apt install -qqy git cargo clang cmake libclang-dev

WORKDIR /build

ARG TAG="v0.11.0"

RUN git clone --branch ${TAG} "https://github.com/romanz/electrs.git" .
RUN cargo build --release --bin electrs

FROM base AS deploy

COPY --from=build /build/target/release/electrs /bin/electrs

EXPOSE 50001

# ENTRYPOINT ["electrs"]
CMD ["electrs", "--conf", "/data/config.toml"]
