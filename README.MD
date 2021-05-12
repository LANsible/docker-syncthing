# docker-syncthing
[![pipeline status](https://gitlab.com/lansible1/docker-syncthing/badges/master/pipeline.svg)](https://gitlab.com/lansible1/docker-syncthing/-/commits/master)
[![Docker Pulls](https://img.shields.io/docker/pulls/lansible/syncthing.svg)](https://hub.docker.com/r/lansible/syncthing)
[![Docker Version](https://images.microbadger.com/badges/version/lansible/syncthing:latest.svg)](https://microbadger.com/images/lansible/syncthing:latest)
[![Docker Size/Layers](https://images.microbadger.com/badges/image/lansible/syncthing:latest.svg)](https://microbadger.com/images/lansible/syncthing:latest)

Dockerized static syncthing


### Running locally

```
docker run -it -p 8384:8384 -p 22000:22000/tcp -p 22000:22000/udp -v "$PWD/config:/config" lansible/syncthing:master
```