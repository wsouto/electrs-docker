#!/bin/sh

# This script is intended for test the image.
# You need a bitcoin node to connect to.
# Just edit the varioble bellow with the address of your node.
# The crendentials to use can be found in the config.toml file.
# After the test succeed you can delete the data directory.

BITCOIN_NODE="bitcoin.local"

docker run --rm \
	--name electrs \
	-e ELECTRS_DB_DIR="/data/db" \
	-e ELECTRS_NETWORK="bitcoin" \
	-e ELECTRS_LOG_FILTERS="INFO" \
	-e ELECTRS_SERVER_BANNER="<<< ELECTRS TEST IMAGE >>>" \
	-e ELECTRS_DAEMON_RPC_ADDR="${BITCOIN_NODE}:8332" \
	-e ELECTRS_DAEMON_P2P_ADDR="${BITCOIN_NODE}:8333" \
	-e ELECTRS_ELECTRUM_RPC_ADDR="0.0.0.0:50001" \
	-v ./data:/data \
	-v ./config.toml:/data/config.toml:ro \
	-p 50001:50001 \
	waltersouto/electrs:latest
