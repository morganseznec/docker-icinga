# Docker image for Icinga2

[IN PROGESS]

This repository provides a non-official Docker image for Icinga2, based on Debian Stretch.

The Icinga2 Docker image can be run in multiple ways:

* Run the image in Docker Engine
* Install Icinga2 into a cluster
* Install Icinga2 using docker-compose

## Prerequisites

* Docker
* MySQL/MariaDB or PostgreSQL external database

Docker installation is required, see the [official installation docs](https://docs.docker.com/install/).

An external database is required for Icingaweb2, take a look at the [MySQL Docker images](https://hub.docker.com/_/mysql/) or [MariaDB Docker images](https://hub.docker.com/_/mariadb/).

## Download an Icinga2 Docker Image

```shell
docker pull morganseznec/icinga2
```

## Start an Icinga2 Instance

### Docker command line

```shell
docker run --name icinga2 -p 80:80 -d morganseznec/icinga2:latest
```

This will download and start a new Icinga2 instance and forward HTTP port from the container to the host.

As you are not using all the available variables to setup your Icinga2 instance, the Icingaweb2 setup wizard will be available by visiting the web page.

To generate the token:

```shell
docker exec -it icinga2 icingacli setup token create;

```

if an external database is used, the admin account can be created by passing `ICINGAWEB2_ADMIN_USER` and `ICINGAWEB2_ADMIN_PASSWORD` environment variables.

### Docker with docker-compose

```yaml
version: "3.6"
services:
  icinga2:
    image: morganseznec/icinga2:latest
    container_name: icinga2
    restart: on-failure
    ports:
      - "80:80"
      - "443:443"
      - "5665:5665"
```

### Docker with a Swarm cluster

```yaml
version: "3.6"
services:
  icinga2:
    image: morganseznec/icinga2:latest
    container_name: icinga2
    restart: on-failure
    ports:
      - "80:80"
      - "443:443"
      - "5665:5665"
    deploy:
      mode: replicated
      replicas: 1
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
        window: 120s
      placement:
        constraints: [node.role == manager]
```

## Volumes



## Docker Environment Variables