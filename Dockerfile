# Build Electrs from Github Repository

FROM quay.io/fedora/fedora-minimal:44 AS builder

LABEL maintainer="Walter Souto <wsouto@gmail.com>"

ARG VERSION="0.11.1"

RUN dnf5 install -y clang cmake clang-devel rocksdb-devel cargo && \
    dnf5 clean all && \
    rm -rf /var/cache/yum

ENV ROCKSDB_INCLUDE_DIR=/usr/include
ENV ROCKSDB_LIB_DIR=/usr/lib64

RUN cargo install electrs --version ${VERSION} --locked && \
    rm -rf ~/.cargo/registry ~/.cargo/git ~/.cargo/.package-cache


FROM quay.io/fedora/fedora-minimal:44 AS deploy

RUN dnf5 install -y rocksdb && \
    dnf5 clean all && \
    rm -rf /var/cache/yum

ENV ROCKSDB_LIB_DIR=/usr/lib64

COPY --from=builder /root/.cargo/bin/electrs /bin/electrs

EXPOSE 50001

CMD ["electrs", "--conf", "/data/config.toml"]
