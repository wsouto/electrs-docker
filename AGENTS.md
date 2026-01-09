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
| `TAG` | Electrs version tag (e.g., v0.11.0) | Yes |
| `BANNER` | Server banner string | No |
| `BITCOIN_DIR` | Host path to Bitcoin data | Yes |
| `ELECTRS_DIR` | Host path for electrs data | Yes |
| `BTC_ADDR` | Bitcoin node IP address | Yes |
| `BTC_RPC_PORT` | Bitcoin RPC port (default: 8332) | No |
| `BTC_P2P_PORT` | Bitcoin P2P port (default: 8333) | No |
| `HOST_ADDR` | Electrs listening address | No |
| `HOST_PORT` | Electrs exposed port (default: 50001) | No |
| `DB_DIR` | Database directory inside container | Auto |
| `DAEMON_DIR` | Bitcoin data directory inside container | Auto |

## Code Style Guidelines

### Dockerfile

- Multi-stage builds for minimal image size (follow the 2-stage pattern in existing Dockerfile)
- Use `debian:trixie-slim` or `ubuntu:noble` as base image
- Keep dependencies minimal: clang, cmake, libclang-dev, librocksdb-dev, cargo
- Clean apt cache after installs: `apt clean && rm -rf /var/lib/apt/lists/*`
- Expose port 50001 (Electrum RPC default)
- Use `CMD` for runtime arguments, not `ENTRYPOINT`
- Always use `--version` flag with `cargo install` for reproducibility
- Use `--locked` flag to ensure dependency versions match Cargo.lock

### Shell Scripts

- Shebang: `#!/bin/sh` (POSIX sh compatibility, no bashisms)
- Use tabs for indentation (2-4 spaces consistent with existing files)
- Include usage instructions and prerequisites in comments
- Load environment variables with `. ./.env` (source command)
- Quote variables: `"${VAR}"` not `$VAR`
- Use `--network host` for container networking (as shown in run.sh and compose.yml)

### Configuration Files (TOML)

- Use TOML format for electrs config
- Inline comments for each setting explaining purpose
- Example values should be commented out with `#`
- Include warnings: "Do NOT blindly copy this and expect it to work for you!"
- Reference docs or man page for advanced settings

### Docker Compose

- Use version "3" format
- Set `restart: unless-stopped` for production deployments
- Use environment variable substitution: `${VAR}`
- Comment non-obvious configuration choices
- Use `network_mode: host` for Bitcoin node connectivity

## GitHub Actions Workflow

- Workflow: `.github/workflows/build.yml`
- Triggers: Push to `main` branch, tags starting with `v`, pull requests to `main`, manual dispatch
- Uses Docker Buildx with GitHub Actions cache
- Builds and pushes to `ghcr.io` (GitHub Container Registry)
- Tags images as `latest` and version tag
- Platform: linux/amd64 only

## File Structure

```bash
.
├── compose.yml           # Docker Compose configuration
├── Dockerfile            # Multi-stage build (base + deploy stages)
├── run.sh               # Testing script (POSIX sh)
├── config.toml          # Electrs configuration example (TOML)
├── env.example          # Environment variables template
├── .dockerignore        # Exclude patterns (.github, .vscode, .env)
└── .github/workflows/   # CI/CD pipelines
```

## Important Notes

- Container connects to **local Bitcoin node only** (by design)
- Avoid exposing Electrum RPC publicly (use SSH tunneling)
- Database requires significant disk space (~70GB+)
- Always test with `run.sh` before pushing images
- Verify environment variables before building
- Keep electrs version updated via `TAG` in `.env`
- GitHub Copilot is enabled in VSCode settings
- **Never commit `.env` file** - it contains sensitive credentials

## Common Issues

- Connection failures: Check `BTC_ADDR` and ports in `.env`
- Permission errors: Verify volume mount paths and permissions
- Build failures: Ensure electrs tag is valid and reachable
- Slow indexing: RocksDB performance depends on storage speed
