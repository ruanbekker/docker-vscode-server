# docker-vscode-server

Docker vscode server

## About

This project is built for [github.com/bekkerlabs](https://github.com/bekkerlabs) which provides you with a environment of your choice, accessible via a web-based vscode.

The main idea is, for example, if you want to learn mysql and python, the service will provision a environment with the required dependencies, and accessible via a web-based vscode with the markdown formatted labs to follow.

In vscode your workspace folder by default will be opened in `/home/coder/workspace` and you can use your host user inside the container by passing the `--user` flag and using the `DOCKER_USER` environment variable.

## Usage

You can either build it yourself or use my dockerhub images. 

The password is controlled by using the environment variable `PASSWORD`, if its not set, the password value will be in `~/.config/code-server/config.yaml`

### Build

Building:

```
$ docker build \
  --build-arg USER=${USER} \
  --build-arg UID=${UID} \
  --build-arg GID=${GID} \
  -f Dockerfile -t vscode:default .
```

Running with no extensions, using http and port 8080:

```
$ docker run -it \
  -e PASSWORD=password \
  -e DOCKER_USER=${USER} \
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  vscode:default
```

Running with no extensions, using https and port 8443 (see [docs/minica](https://github.com/ruanbekker/docker-vscode-server/blob/main/docs/minica.md) to generate certs for local use):

```
$ docker run -it \
  -e PASSWORD=password \
  -e HTTPS_ENABLED=true \
  -e APP_PORT=8443 \
  -e DOCKER_USER=${USER} \
  -p 8443:8443 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  -v $PWD/certs/cert.pem:/home/coder/.certs/cert.pem \
  -v $PWD/certs/key.pem:/home/coder/.certs/key.pem \
  vscode:default
```

Running with extensions, using http and port 8080:

```
$ docker run -it \
  -e PASSWORD=password \
  -e DOCKER_USER=${USER} \
  -e EXTENSIONS="ms-python.python,tushortz.python-extended-snippets,andyyaldoo.vscode-json,golang.go,redhat.vscode-yaml,vscode-icons-team.vscode-icons"
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  vscode:default
```

### Dockerhub Images

Running with no extensions, using http and port 8080:

```
$ docker run -it \
  -e PASSWORD=password \
  -e DOCKER_USER=${USER} \
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  ruanbekker/vscode-server:slim
```

Running with no extensions, using https and port 8443 (see [docs/minica](https://github.com/ruanbekker/docker-vscode-server/blob/main/docs/minica.md) to generate certs for local use):

```
$ docker run -it \
  -e PASSWORD=password \
  -e HTTPS_ENABLED=true \
  -e APP_PORT=8443 \
  -e DOCKER_USER=${USER} \
  -p 8443:8443 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  -v $PWD/certs/cert.pem:/home/coder/.certs/cert.pem \
  -v $PWD/certs/key.pem:/home/coder/.certs/key.pem \
  ruanbekker/vscode-server:slim
```

Running with extensions, using http and port 8080:

```
$ docker run -it \
  -e PASSWORD=password \
  -e DOCKER_USER=${USER} \
  -e EXTENSIONS="ms-python.python,tushortz.python-extended-snippets,andyyaldoo.vscode-json,golang.go,redhat.vscode-yaml,vscode-icons-team.vscode-icons"
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  ruanbekker/vscode-server:slim
```

### Persistence 

If you would like to persist your containers storage to your host for vscode's data, you can persist the follwing directories:

* `-v $PWD/config:/home/coder/.config` (configuration)
* `-v $PWD/userdata:/home/coder/.local` (logs, extensions, vscode settings, etc)

## Versions

### Slim

Docker Image:

- `ruanbekker/vscode-server:slim`

This image is the smallest one which includes the following os packages:

* `vim`
* `git`
* `curl`
* `wget`
* `ssh`

### Go

Docker Image:

- `ruanbekker/vscode-server:golang`

This image uses Go version `1.15.6`

### Python

Docker Image:

- `ruanbekker/vscode-server:python`

Includes the following python packages:

* `virtualenv`
* `requests`
* `flask`
* `pandas`
* `numpy`
* `sklearn`
* `matplotlib`
* `mysqlclient`
* `pymysql`
* `pysftp`

## Custom Builds

You can extend or add your own software on-top of the base image by using `ruanbekker/vscode-server-base:3.7.4` as your base image.

This is a sample:

```
FROM ruanbekker/vscode-server-base:3.7.4
USER root

# start of your custom modifications

RUN apt update \
    && apt install figlet-y \
    && rm -rf /var/lib/apt/lists/*

# end of your custom modifications

USER 1000
ENV USER=coder
WORKDIR /home/coder

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
```

## Docker Hub

- [ruanbekker/vscode-server](https://hub.docker.com/r/ruanbekker/vscode-server)
