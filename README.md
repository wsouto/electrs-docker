# electrs-docker

Docker containerization for [electrs](https://github.com/romanz/electrs) — a lightweight Electrum Bitcoin Server.

_**Note:** This image connects to a local Bitcoin node only._

## Image Details

| Registry | Image | Size | Platform |
|----------|-------|------|----------|
| Docker Hub | `waltersouto/electrs` | ~235 MB | linux/amd64 |
| GHCR | `ghcr.io/wsouto/electrs` | ~235 MB | linux/amd64 |

### Architecture

The Dockerfile uses a **multi-stage build** with Fedora minimal images:

- **Builder stage**: Compiles electrs from source using `cargo install` from crates.io
- **Deploy stage**: Copies only the binary into a fresh minimal image with runtime dependencies

This approach keeps the final image at ~235 MB instead of the ~2.79 GB that would result from inheriting the full build environment.

## How to Use

### 1. Configure Environment

```bash
cp env.example .env
```

Edit `.env` with your Bitcoin node details. **Never commit `.env` to version control.**

### 2. Build

```bash
docker build -t ${DOCKER_USER}/electrs:${TAG} .
```

### 3. Run

Using Docker Compose:

```bash
docker compose up
```

Or manually with `run.sh`:

```bash
./run.sh
```

### 4. Push

```bash
docker push ${DOCKER_USER}/electrs:${TAG}
```

## Requirements

- Running Bitcoin node accessible at the configured address
- Valid credentials in `config.toml`
- Sufficient disk space for electrs index (~70 GB+)
