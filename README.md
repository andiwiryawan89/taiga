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

## How to Build image taiga

    $> docker build --rm -t [image_name] .

## How To run:

    $> docker-compose up -d --build

Timeline update:

python3.6 manage.py rebuild_timeline --purge
python3.6 manage.py rebuild_timeline_iterating_per_projects
pg_dump -U username dbname > data.pgsql
psql -U username dbname < dbexport.pgsql
\l
\c database
drop database [name];
CREATE DATABASE taiga OWNER taiga;