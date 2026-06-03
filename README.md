# electrs-docker

Docker containerization for [electrs](https://github.com/romanz/electrs) — a lightweight Electrum Bitcoin Server.

## Image Details

| Registry | Image | Size | Platform |
| --- | --- | --- | --- |
| Docker Hub | `waltersouto/electrs` | ~235 MB | linux/amd64 |
| GHCR | `ghcr.io/wsouto/electrs` | ~235 MB | linux/amd64 |

### Architecture

The Dockerfile uses a **multi-stage build** with Fedora minimal images:

- **Builder stage**: Compiles electrs from source using `cargo install` from crates.io
- **Deploy stage**: Copies only the binary into a fresh minimal image with runtime dependencies

This approach keeps the final image at ~235 MB instead of the ~2.79 GB that would result from inheriting
 the full build environment.

### Migration Note

> This project migrated from **Debian trixie-slim** to **Fedora 44 minimal** (via `quay.io`). The key changes:
>
> - **Package manager**: `apt` → `microdnf`
> - **Package naming**: `libclang-dev`/`librocksdb-dev` → `clang-devel`/`rocksdb-devel`
> - **RocksDB lib path**: `/usr/lib` → `/usr/lib64`
> - **Image size reduced**: ~2.79 GB → ~235 MB (12x smaller)
> - **Multi-stage build fixed**: deploy stage no longer inherits build dependencies

## How to Use

### 1. Configure Environment and Server

```bash
cp env.example .env
```

Edit `.env` with your Bitcoin node details. **Never commit `.env` to version control.**

Also, create the electrs data directory and copy the configuration file:

```bash
mkdir -p ./data
cp config.toml ./data/
```

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
- Valid credentials in `config.toml` (cookie auth is recommended when bitcoind and electrs run on the same host)
- Sufficient disk space for electrs index (~70 GB+ for mainnet)

## Testing with Signet

Signet is Bitcoin's test network — smaller, faster, and ideal for testing electrs without mainnet's ~70 GB index.

### Prerequisites

1. **Run bitcoind on signet** with RPC enabled:

   ```bash
   bitcoind -signet -server -daemon
   ```

2. **Verify the node is synced**:

   ```bash
   bitcoin-cli -signet getblockchaininfo
   ```

   Look for `"initialblockdownload": false` and `"blocks"` matching the [signet explorer](https://mempool.space/signet).

### Setup

1. **Clone and configure**:

   ```bash
   git clone https://github.com/wsouto/electrs-docker.git
   cd electrs-docker
   cp env.example .env
   ```

2. **Edit `.env` for signet**:

   ```bash
   # Bitcoin Node
   BTC_ADDR="127.0.0.1"          # Use with --network host (Linux)
   BTC_RPC_PORT=38332             # Signet RPC port
   BTC_P2P_PORT=38333             # Signet P2P port

   # Electrs Network
   ELECTRS_NETWORK="signet"       # Test network

   # Log Level (DEBUG for testing, INFO for production)
   ELECTRS_LOG_FILTERS="DEBUG"

   # Data Directories
   BITCOIN_DIR="$HOME/.bitcoin"   # Your bitcoind data directory
   ELECTRS_DIR="./data"           # Electrs index storage
   ```

3. **Create the data directory and copy config**:

   ```bash
   mkdir -p ./data
   cp config.toml ./data/
   ```

### Run

Using `run.sh` (recommended for testing):

```bash
./run.sh
```

Or with Docker Compose:

```bash
docker compose up
```

### Verify

Once electrs starts indexing, you'll see log output like:

```text
[2026-05-21T17:47:45.445Z INFO electrs::index] indexing 1000 blocks
[2026-05-21T17:47:45.445Z DEBUG electrs::p2p] got 10 new headers
```

Test the Electrum RPC endpoint:

```bash
echo '{"id":0,"method":"server.version","params":["test","1.4"]}' | nc 127.0.0.1 50001
```

Expected response:

```json
{"id":0,"result":["electrs 0.11.1","1.4"]}
```

### Connection Methods

| Environment | BTC_ADDR | Network Mode |
| --- | --- | --- |
| Linux native | `127.0.0.1` | `--network host` |
| Docker Desktop | `host.docker.internal` | Default bridge |

> **Note**: `host.docker.internal` only works with Docker Desktop, not native Linux Docker.

### Log Levels

| Level | Use Case |
| --- | --- |
| `DEBUG` | Testing — shows headers, p2p messages, indexing details |
| `INFO` | Production — startup, indexing progress, general ops |
| `WARN` | Warnings and errors only |
| `ERROR` | Errors only (least verbose) |
