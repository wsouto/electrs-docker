# Build Electrs from Github Repository
FROM ubuntu:kinetic AS base

LABEL maintainer="Walter Souto <wsouto@gmail.com>"

RUN apt update -qy
RUN apt install -qy librocksdb-dev

FROM base as builder

RUN apt install -qy git cargo clang cmake build-essential

WORKDIR /build

ARG VERSION=v0.9.11
ENV REPO=https://github.com/romanz/electrs.git

RUN git clone --branch $VERSION $REPO .
RUN cargo build --release --bin electrs

FROM base as deploy

COPY --from=builder /build/target/release/electrs /bin/electrs

EXPOSE 50001

ENTRYPOINT ["electrs"]
CMD ["--conf", "/data/config.toml"]
