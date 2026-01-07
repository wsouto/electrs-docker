# Agent Guidelines for electrs-docker

This repository provides Docker infrastructure for running electrs (Electrum Bitcoin Server).

## Project Overview

- **Type**: Docker containerization project
- **Purpose**: Build and run electrs from source in Docker
- **Reference**: <https://github.com/romanz/electrs>
- **Image**: <https://hub.docker.com/r/waltersouto/electrs>

## Build Commands

### Local Build

```bash
docker build -t <your-docker-hub-user>/electrs:<tag> .
```

### Using Environment File

```bash
# Set DOCKER_USER and TAG in .env first
docker build -t ${DOCKER_USER}/electrs:${TAG} .
```

### Run Container

```bash
docker compose up
```

### Manual Run

```bash
docker run --rm \
  --name electrs \
  --env-file=.env \
  -e ELECTRS_DB_DIR=${DB_DIR} \
  -e ELECTRS_DAEMON_DIR=${DAEMON_DIR} \
  -e ELECTRS_NETWORK=bitcoin \
  -e ELECTRS_LOG_FILTERS=INFO \
  -e ELECTRS_SERVER_BANNER="${BANNER}" \
  -e ELECTRS_DAEMON_RPC_ADDR=${BTC_ADDR}:${BTC_RPC_PORT} \
  -e ELECTRS_DAEMON_P2P_ADDR=${BTC_ADDR}:${BTC_P2P_PORT} \
  -e ELECTRS_ELECTRUM_RPC_ADDR=${HOST_ADDR}:${HOST_PORT} \
  -v ${HOST_BITCOIN_DIR}:${DAEMON_DIR}:ro \
  -v ${HOST_ELECTRS_DIR}:/data \
  -p ${HOST_PORT}:50001 \
  ${DOCKER_USER}/electrs:${TAG}
```

### Push to Registry

```bash
docker push <your-docker-hub-user>/electrs:<tag>
```

## Testing

### Local Testing

Use `run.sh` for testing with a local Bitcoin node:

```bash
# Edit BITCOIN_NODE variable in run.sh first
./run.sh
```

Test requirements:

- Running Bitcoin node accessible at configured address
- Valid credentials in `config.toml`
- Data directory for electrs index storage

## Configuration

### Environment Variables (.env)

- `DOCKER_USER`: Docker Hub username
- `TAG`: Electrs version tag (e.g., v0.11.0)
- `BANNER`: Server banner string
- `BITCOIN_DIR`: Host path to Bitcoin data
- `ELECTRS_DIR`: Host path for electrs data
- `BTC_ADDR`: Bitcoin node IP address
- `BTC_RPC_PORT`: Bitcoin RPC port (default: 8332)
- `BTC_P2P_PORT`: Bitcoin P2P port (default: 8333)
- `HOST_ADDR`: Electrs listening address (use with caution)
- `HOST_PORT`: Electrs exposed port (default: 50001)
- `DB_DIR`: Database directory inside container
- `DAEMON_DIR`: Bitcoin data directory inside container

### Electrs Configuration (config.toml)

- `auth`: Authentication credentials (format: "user:password")
- `cookie_file`: Bitcoind cookie file path
- `daemon_rpc_addr`: Bitcoind RPC address
- `daemon_p2p_addr`: Bitcoind P2P address
- `db_dir`: Index storage location (requires ~70GB)
- `network`: Network type ("bitcoin" for mainnet)
- `electrum_rpc_addr`: Listening address for Electrum RPC
- `log_filters`: Logging level (INFO, WARN, DEBUG, TRACE)

## Code Style Guidelines

### Dockerfile

- Multi-stage builds for minimal image size
- Use `ubuntu:noble` as base image
- Keep dependencies minimal (`librocksdb-dev`, build tools)
- Clean apt cache after installs
- Expose port 50001 (Electrum RPC default)
- Use CMD for runtime arguments

### Shell Scripts

- Shebang: `#!/bin/sh`
- No complex bashisms (POSIX sh compatibility)
- Use tabs for indentation
- Comment purpose and prerequisites
- Include usage instructions

### Configuration Files

- TOML format for electrs config
- Inline comments for each setting
- Example values prefixed with `#`
- Warn users not to blindly copy examples

## GitHub Actions

- Workflow: `.github/workflows/build.yml`
- Triggers: Push to `main` branch, manual dispatch
- Builds and pushes to `ghcr.io`
- Tags images as `latest`

## File Structure

```text
.
├── compose.yml           # Docker Compose configuration
├── Dockerfile            # Multi-stage build
├── run.sh               # Testing script
├── config.toml          # Electrs configuration example
├── .env.example         # Environment variables template
├── .dockerignore        # Exclude patterns
└── .github/workflows/   # CI/CD pipelines
```

## Important Notes

- Container connects to **local Bitcoin node only** (by design)
- Avoid exposing Electrum RPC publicly (use SSH tunneling)
- Database requires significant disk space (~70GB+)
- Always test with `run.sh` before pushing images
- Verify environment variables before building
- Keep electrs version updated via `TAG` in `.env`

## Common Issues

- Connection failures: Check `BTC_ADDR` and ports in `.env`
- Permission errors: Verify volume mount paths and permissions
- Build failures: Ensure electrs tag is valid and reachable
- Slow indexing: RocksDB performance depends on storage speed
