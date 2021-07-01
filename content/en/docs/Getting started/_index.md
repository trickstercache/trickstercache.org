---
title: "Getting Started"
linkTitle: "Getting Started"
weight: 3
description: >
  What does your user need to know to try your project?
---
<!-- Got this docker compose demo from https://github.com/trickstercache/trickster/tree/main/examples/docker-compose  -->

{{< alert title="Try Trickster" >}}To try a demo of Trickster with Docker before installing, see our end-to-end [Quickstart](/docs/quickstart/) for a zero-configuration running environment.{{< /alert >}}

## Installing with Docker

Docker images are available on Docker Hub. To install Trickster with Docker, run the following command:

```
$ docker run --name trickster -d -v /path/to/trickster.conf:/etc/trickster/trickster.conf -p 0.0.0.0:8480:8480 tricksterproxy/trickster
```

See the [Deployment](/docs/quick-start/deployment/) documentation for more information about using or creating Trickster Docker images.

## Installing with Kubernetes

To install Trickster with Kubernetes, see [Deployment](/docs/quick-start/deployment/).

## Helm

Trickster Helm Charts are located at <https://helm.tricksterproxy.io> for installation, and maintained at <https://github.com/tricksterproxy/helm-charts>. We welcome chart contributions.

## Building from source

To build Trickster from the source code yourself you need to have a working
Go environment with [version 1.9 or greater installed](http://golang.org/doc/install).

You can directly use the `go` tool to download and install the `trickster`
binary into your `GOPATH`:

    $ go get github.com/tricksterproxy/trickster
    $ trickster -origin-url http://prometheus.example.com:9090 -origin-type prometheus

You can also clone the repository yourself and build using `make`:

    $ mkdir -p $GOPATH/src/github.com/tricksterproxy
    $ cd $GOPATH/src/github.com/tricksterproxy
    $ git clone https://github.com/tricksterproxy/trickster.git
    $ cd trickster
    $ make build
    $ ./OPATH/trickster -origin-url http://prometheus.example.com:9090 -origin-type prometheus

The Makefile provides several targets, including:

* *build*: build the `trickster` binary
* *docker*: build a docker container for the current `HEAD`
* *clean*: delete previously-built binaries and object files
* *test*: runs unit tests
* *bench*: runs benchmark tests
* *rpm*: builds a Trickster RPM
