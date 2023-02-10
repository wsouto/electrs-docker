# electrs-docker

## A Dockerfile to build from the source code and a docker-compose.yml to run Electrs

_It's intended to connect to a local Bitcoin node, but you can use the file `config.toml` to authenticate in a remote node, just copy it to `HOST_ELECTRS_DIR` and set the node credentials._

**References:**

* Electrs repo: <https://github.com/romanz/electrs>
* Docker images: <https://hub.docker.com/r/waltersouto/electrs>

### How to use

Start by cloning this repository.

In the repository directory, copy the file `env.example` to `.env` and edit it according to your environment.

Next, to build the image run:

```shell
docker build -t <your-docker-hub-user>/electrs:<tag>
```

After the build is done, use the `docker-compose.yml` to run the image:

```shell
docker compose up
```

_**Note**: Using the `config.toml` is the only way to authenticate into a remote Bitcoin server. See `auth` directive._
