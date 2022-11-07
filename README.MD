# docker-syncthing
[![Build Status](https://github.com/LANsible/docker-syncthing/actions/workflows/docker.yml/badge.svg)](https://github.com/LANsible/docker-syncthing/actions/workflows/docker.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/lansible/syncthing.svg)](https://hub.docker.com/r/lansible/syncthing)
[![Docker Version](https://img.shields.io/docker/v/lansible/syncthing.svg?sort=semver)](https://hub.docker.com/r/lansible/syncthing)
[![Docker Size/Layers](https://img.shields.io/docker/image-size/lansible/syncthing.svg?sort=semver)](https://hub.docker.com/r/lansible/syncthing)

Dockerized static syncthing


### Running locally

```
docker run -it -p 8384:8384 -p 22000:22000/tcp -p 22000:22000/udp -v "$PWD/config:/config" lansible/syncthing:master
```