# MiniCA

## About

Project Info:
- [jsha/minica](https://github.com/jsha/minica)

## Usage

Run:

```
$ docker run --user "$(id -u):$(id -g)" -it -v $PWD/certs:/output ruanbekker/minica --domains 192.168.0.20.nip.io
```

View:

```
$ find ./certs -type f
./certs/minica-key.pem
./certs/192.168.0.20.nip.io/key.pem
./certs/192.168.0.20.nip.io/cert.pem
./certs/minica.pem
```

## Cert Installation

Follow [this guide](https://gist.github.com/mwidmann/115c2a7059dcce300b61f625d887e5dc) for cert installation
