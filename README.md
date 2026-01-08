# electrs-docker

## A Dockerfile to build from source

_**Note:** This image is intended to connect to a local running Bitcoin node only._

**References:**

- Electrs repo: <https://github.com/romanz/electrs>
- Docker images: <https://hub.docker.com/r/waltersouto/electrs>

## How to use

Start by cloning this repository. In the repository directory, copy the file `env.example` to `.env` and edit it according to your environment.

To build the image, run the following command:

```shell
docker build -t <your-docker-hub-user>/electrs:<tag> .
```

You can run the container with the `docker run` command or with `docker compose` since a `compose.yml` file is provided.

Here is the run command (don't forget to edit the `.env` file):

```shell
docker run --rm \
  --name electrs \
  --env-file=.env \
  --network host \
  -e ELECTRS_DB_DIR=${DB_DIR} \
  -e ELECTRS_NETWORK=bitcoin \
  -e ELECTRS_LOG_FILTERS=DEBUG \
  -e ELECTRS_SERVER_BANNER="${BANNER}" \
  -e ELECTRS_DAEMON_RPC_ADDR=${BTC_ADDR}:${BTC_RPC_PORT} \
  -e ELECTRS_DAEMON_P2P_ADDR=${BTC_ADDR}:${BTC_P2P_PORT} \
  -e ELECTRS_ELECTRUM_RPC_ADDR=${HOST_ADDR}:${HOST_PORT} \
  -v ${BITCOIN_DIR}:/root/.bitcoin:ro \
  -v ${ELECTRS_DIR}:/data \
  -p ${HOST_PORT}:50001 \
  ${DOCKER_USER}/electrs:${TAG}
```

There is also a file `run.sh` containing the command.

To push the image to the registry:

```shell
docker push <your-docker-hub-user>/electrs:<tag>
```

After the build is done, you can use the `compose.yml` file to run the image:

```shell
docker compose up
```
