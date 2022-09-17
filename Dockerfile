# Build Electrs from Github Repository
FROM rust:1.63.0-slim-bullseye AS builder

LABEL maintainer="Walter Souto <wsouto@gmail.com>"

ARG VERSION=v0.9.9
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

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

HEALTHCHECK CMD curl -fSs http://localhost:4224/ || exit 1

ENTRYPOINT ["electrs"]
CMD ["--conf", "/data/config.toml"]
