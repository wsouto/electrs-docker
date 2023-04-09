# electrs-docker

## A Dockerfile to Build from the Source

_This image is intended to connect to a local Bitcoin node, but you can use the file `config.toml` to authenticate in a remote node, just copy it to `HOST_ELECTRS_DIR` (see env.example file) and set the bitcoin node credentials._

**References:**

- Electrs repo: <https://github.com/romanz/electrs>
- Docker images: <https://hub.docker.com/r/waltersouto/electrs>

## How to use

Start by cloning this repository.

In the repository directory, copy the file `env.example` to `.env` and edit it according to your environment.

Next, to build the image run:

```shell
docker build -t <your-docker-hub-user>/electrs:<tag> .
```

Now you can run via a `docker run` command or via a docker-compose file. A compose file is intended when we need some kind of orchestration. To run only one container isolated is better to use the `docker run` command. With compose, you need to push the image to a register because docker-compose is meant to pull images.

Here is the run command (don't forget the `.env` file):

```shell
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

There is also a file `run.sh` containing the command.

To push the image to the register so docker-compose can use it:

```shell
docker push <your-docker-hub-user>/electrs:<tag>
```

After the build is done, use the `docker-compose.yml` to run the image:

```shell
docker compose up
```

_**Note**: Using the `config.toml` is the only way to authenticate into a remote Bitcoin server. See the `auth` directive._
