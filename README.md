# docker-vscode-server
Docker vscode server

## Usage

Building:

```
$ docker build -f Dockerfile -t vscode:default .
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

Running with no extensions, using https and port 8443 (see minica to generate certs for local use):

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
  -e PLUGINS="ms-python.python,tushortz.python-extended-snippets,andyyaldoo.vscode-json,golang.go,redhat.vscode-yaml,vscode-icons-team.vscode-icons"
  -p 8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v $PWD/workspace:/home/coder/workspace \
  -v $PWD/config:/home/coder/.config \
  vscode:default
```

