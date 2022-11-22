# Build Electrs from Github Repository
FROM rust:1.65.0-slim-bullseye AS builder

LABEL maintainer="Walter Souto <wsouto@gmail.com>"

ARG VERSION=v0.9.10
ENV REPO=https://github.com/romanz/electrs.git

RUN apt-get update
RUN apt-get install -y git cargo clang cmake libsnappy-dev

WORKDIR /build

RUN git clone --branch $VERSION $REPO .
RUN cargo build --release --bin electrs

FROM debian:bullseye-slim

COPY --from=builder /build/target/release/electrs /bin/electrs

# Electrum RPC Mainnet
EXPOSE 50001

STOPSIGNAL SIGINT

ENTRYPOINT ["electrs"]
CMD ["--conf", "/data/config.toml"]
