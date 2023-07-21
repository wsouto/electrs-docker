# Build Electrs from Github Repository

FROM debian:bookworm-slim AS base

LABEL maintainer="Walter Souto <wsouto@gmail.com>"

RUN apt update -qy
RUN apt install -qy librocksdb-dev

FROM base as build

# RUN apt install -qy git cargo clang cmake build-essential
RUN apt install -qy git cargo clang cmake

WORKDIR /build

ARG VERSION=v0.10.0
ENV REPO="https://github.com/romanz/electrs.git"

RUN git clone --branch $VERSION $REPO .
RUN cargo build --release --bin electrs

FROM base as deploy

COPY --from=build /build/target/release/electrs /bin/electrs

EXPOSE 50001

# ENTRYPOINT ["electrs"]
CMD ["electrs", "--conf", "/data/config.toml"]

