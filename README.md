# electrs-docker

A Dockerfile to build from code and a docker-compose.yml to run Electrs. It's intended to connect to a local Bitcoin node only for now.

* Electrs repo: https://github.com/romanz/electrs
* Docker images: https://hub.docker.com/r/waltersouto/electrs

## How to use:

Clone the repo or dowload only the files you need.

To use the `docker-compose.yml` from this repo you are going to need the `.env` file for both steps bellow. **Check this file first** and edit according to your local environment, then:

**1. If you just want to run Electrs:**

- Run `docker compose up`

**2. If you want to build your own image:**

- Download the `Dockerfile` and `docker-compose.yml` if you have not cloned the repo.
- Run `docker build -t electrs:<tag>` to use locally or,
- Run `docker build -t <your-docker-hub-user>/electrs:<tag>` if you intend to push to Docker Hub.
- Edit the `docker-compose.yml` file to use your image.
- Run `docker compose up`
