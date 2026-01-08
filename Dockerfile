# Build Electrs from Github Repository

FROM debian:trixie-slim AS base

LABEL maintainer="Walter Souto <wsouto@gmail.com>"

ARG VERSION="0.11.0"

RUN apt update -qqy
RUN apt install -qqy clang cmake libclang-dev librocksdb-dev cargo

ENV ROCKSDB_INCLUDE_DIR=/usr/include
ENV ROCKSDB_LIB_DIR=/usr/lib

RUN cargo install electrs --version ${VERSION} --locked


FROM base AS deploy

COPY --from=base /root/.cargo/bin/electrs /bin/electrs

EXPOSE 50001

CMD ["electrs", "--conf", "/data/config.toml"]
