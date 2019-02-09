# Docker image for Taiga

Deploy a Taiga inside a docker container

More info about Taiga on [taiga.io](https://taiga.io)

# How to use it

## Standalone container directly from the docker hub

Environment Default

ENV TAIGA_HOST localhost

ENV TAIGA_DEBUG True

ENV TAIGA_PUBLIC True

## Email Setting

    $> Change file on taiga-file/local.py

## How To run:

    $> docker run -d -ti --name taiga -p 80:80 -p 8080:8080 -v /sys/fs/cgroup:/sys/fs/cgroup:ro andiwiryawan/taiga
docker run -ti --name taiga-postgres -e POSTGRES_DB=taiga -e POSTGRES_USER=taiga -e POSTGRES_PASSWORD=DBPassword -e POSTGRES_CONFIG_shared_buffers=512MB andiwiryawan/taiga-postgres