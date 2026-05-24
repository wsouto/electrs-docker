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
docker build -t ${DOCKER_USER}/electrs:${TAG} .
```

### Run Container

```bash
docker compose up
```

### Manual Run

```bash
./run.sh
```

### Push to Registry

```bash
docker push ${DOCKER_USER}/electrs:${TAG}
```

## Testing

### Local Testing

Use `run.sh` for testing with a local Bitcoin node:

```bash
./run.sh
```

Test requirements:

- Running Bitcoin node accessible at configured address
- Valid credentials in `config.toml`
- Data directory for electrs index storage

## Environment Variables

### Configuration (.env)

Copy `env.example` to `.env` and edit. **Never commit `.env` to version control.**

| Variable | Description | Required |
| ---------- | ------------- | ---------- |
| `DOCKER_USER` | Docker Hub or GHCR username | Yes |
| `TAG` | Electrs version tag (e.g., v0.11.1) | Yes |
| `BANNER` | Server banner string (supports ${TAG} and ${ELECTRS_NETWORK} template vars) | No |
| `ELECTRS_NETWORK` | Bitcoin network (bitcoin=mainnet, signet) | No (default: bitcoin) |
| `ELECTRS_LOG_FILTERS` | Log level (DEBUG, INFO, WARN, ERROR) | No (default: INFO) |
| `BITCOIN_DIR` | Host path to Bitcoin data | Yes |
| `ELECTRS_DIR` | Host path for electrs data | Yes |
| `BTC_ADDR` | Bitcoin node IP address | Yes |
| `BTC_RPC_PORT` | Bitcoin RPC port (default: 8332) | No |
| `BTC_P2P_PORT` | Bitcoin P2P port (default: 8333) | No |
| `HOST_ADDR` | Electrs listening address | No |
| `HOST_PORT` | Electrs exposed port (default: 50001) | No |
| `DB_DIR` | Database directory inside container | `/data/db` |

## Code Style Guidelines

### Dockerfile

- Multi-stage builds for minimal image size (true separation: deploy stage must NOT inherit builder)
- Add `LABEL maintainer="Your Name <email>"` at the top of the builder stage
- Use `quay.io/fedora/fedora-minimal:44` as base image for both builder and deploy stages
- Keep dependencies minimal: clang, cmake, clang-devel, rocksdb-devel, cargo
- Install `rocksdb` runtime library in deploy stage via `microdnf`
- Use `microdnf` instead of `dnf` (available in minimal images)
- Clean package cache in same layer as install: `microdnf clean all && rm -rf /var/cache/yum`
- Clean cargo cache after install: `rm -rf ~/.cargo/registry ~/.cargo/git ~/.cargo/.package-cache`
- Expose port 50001 (Electrum RPC default)
- Use `CMD` for runtime arguments, not `ENTRYPOINT`
- Always use `--version` flag with `cargo install` for reproducibility
- Use `--locked` flag to ensure dependency versions match Cargo.lock
- RocksDB library path on Fedora: `/usr/lib64` (not `/usr/lib`)
- Target final image size: ~235 MB

### Shell Scripts

- Shebang: `#!/bin/sh` (POSIX sh compatibility, no bashisms)
- Use 2-space indentation (consistent with run.sh)
- Include usage instructions and prerequisites in comments
- Load environment variables with `. ./.env` (source command)
- Quote variables: `"${VAR}"` not `$VAR`
- Use `--network host` for container networking (as shown in run.sh and compose.yml)

## GitHub Actions Workflow

- Workflow: `.github/workflows/build.yml`
- Triggers: Push to `main` branch, tags starting with `v`, pull requests to `main`, manual dispatch
- Uses Docker Buildx with GitHub Actions cache
- Builds and pushes to `ghcr.io` (GitHub Container Registry) and Docker Hub (`waltersouto/electrs`)
- Tags images as `latest` and version tag
- Platform: linux/amd64 only

## File Structure

```bash
.
├── AGENTS.md             # Agent guidelines
├── compose.yml           # Docker Compose configuration
├── config.toml          # Electrs configuration example (TOML)
├── Dockerfile            # Multi-stage build (base + deploy stages)
├── env.example          # Environment variables template
├── .dockerignore        # Exclude patterns (.github, .vscode, .env)
├── .gitignore           # Git ignore patterns
├── LICENSE               # Project license
├── README.md            # Project documentation
├── run.sh               # Testing script (POSIX sh)
└── .github/workflows/   # CI/CD pipelines
```

## Important Notes

- Container can connect to any reachable Bitcoin node (local or remote)
- Avoid exposing Electrum RPC publicly (use SSH tunneling)
- Database requires significant disk space (~70GB+)
- Always test with `run.sh` before pushing images
- Verify environment variables before building
- Keep electrs version updated via `TAG` in `.env`
- **Never commit `.env` file** - it contains sensitive credentials
- Base images are pulled from `quay.io` (Fedora minimal), not Docker Hub
- Build does NOT require electrs source code in build context (installs from crates.io)

## Common Issues

- Connection failures: Check `BTC_ADDR` and ports in `.env`
- Permission errors: Verify volume mount paths and permissions
- Build failures: Ensure electrs tag is valid and reachable on crates.io
- Slow indexing: RocksDB performance depends on storage speed
- Quay.io pull errors: Ensure network access to `quay.io` for base images
