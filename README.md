# electrs-docker

A Dockerfile to build from the source code and a docker-compose.yml to run Electrs.
It's intended to connect to a local Bitcoin node only.

* Electrs repo: https://github.com/romanz/electrs
* Docker images: https://hub.docker.com/r/waltersouto/electrs

## How to use:

Clone the repository or download only the files you need.

To run Electrs from the `docker-compose.yml`, you will need the `.env` file as well, so, download these two files at least.

**Check the `.env` file first** and edit it according to your local environment, then:

**1. If you just want to run Electrs:**

- Just run `docker compose up`

**2. If you want to build your image:**

- Download the `Dockerfile`, `docker-compose.yml` and `.env` if you have not cloned the repo.
- Run `docker build -t electrs:<tag> .` to only use it locally or,
- Run `docker build -t <your-docker-hub-user>/electrs:<tag> .` if you intend to push to your Docker Hub repository.
- Edit the `docker-compose.yml` file to use your image.
- Check the `.env` file and it according to your environment.
- Then run `docker compose up`

**3. Copy the `config.toml` file to the `HOST_DATA_DIR` (optional):**

You can set any Electrs configuration parameters in this file as you like or need in it.

_**Note**: Using the `config.toml` is the only way to authenticate into a remote Bitcoin server. See `auth` directive._
