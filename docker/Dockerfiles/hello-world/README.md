# Hello world

This image contains 5 versions. To update the version, you will need to run the [docker build](https://docs.docker.com/engine/reference/commandline/build/) command, with [argument](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg) option.

To build version 1:

```bash
$ docker build --build-arg APP_VERSION=v1 -t hello-world:1.0
```
Build version 2:
```bash
$ docker build --build-arg APP_VERSION=v2 -t hello-world:2.0
```