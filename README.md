# electrs-docker

## A Dockerfile to containerize Electrs

_**Note:** This image is intended to connect to a local running Bitcoin node only._

**References:**

- Electrs repo: <https://github.com/romanz/electrs>

**Images:**

- Docker Hub: `waltersouto/electrs`
- GitHub Package: `ghcr.io/wsouto/electrs:main`

## How to use

Start by cloning this repository. In the repository directory, copy the file `env.example` to `.env` and edit it according to your environment.

Note: to simplify the work in this repository, load the `.env` file:

```bash
. ./.env
```

To build the image, run the following command:

```shell
docker build -t ${DOCKER_USER}/electrs:${TAG} .
```

You can run the container with the `docker run` command or with `docker compose`, a `compose.yml` file is provided.

See the `run.sh` command for details.

To push the image to the registry:

```shell
docker push ${DOCKER_USER}/electrs:${TAG}
```

After the build is done, you can use the `compose.yml` file to run the image:

```shell
docker compose up
```
