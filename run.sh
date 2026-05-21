#!/bin/sh
#
# This script is intended for testing the image.
# You need a bitcoin node to connect to.
#
# Create a data directory for electrs and copy the config:
# mkdir data
# cp config.toml data/
#
# Check the .env and config.toml files for configuration.
# OBS: in this case all configuration comes from the .env file.
#
# Log levels: DEBUG (testing), INFO (prod), WARN, ERROR
# Set ELECTRS_LOG_FILTERS in .env to override the default (INFO).
#
###

# Load environment variables
. ./.env

# Run the electrs container
docker run --rm \
	--name electrs \
	--env-file=.env \
	--network host \
	-e ELECTRS_DB_DIR=${DB_DIR} \
	-e ELECTRS_NETWORK=${ELECTRS_NETWORK:-bitcoin} \
	-e ELECTRS_LOG_FILTERS=${ELECTRS_LOG_FILTERS:-INFO} \
	-e ELECTRS_SERVER_BANNER="${BANNER}" \
	-e ELECTRS_DAEMON_RPC_ADDR=${BTC_ADDR}:${BTC_RPC_PORT} \
	-e ELECTRS_DAEMON_P2P_ADDR=${BTC_ADDR}:${BTC_P2P_PORT} \
	-e ELECTRS_ELECTRUM_RPC_ADDR=${HOST_ADDR}:${HOST_PORT} \
	-v ${BITCOIN_DIR}:/root/.bitcoin:ro \
	-v ${ELECTRS_DIR}:/data \
	${DOCKER_USER}/electrs:${TAG}
