# Description

A docker image for mediagoblin with the `gmg_localfiles` plugin.

A quick way to serve up HTML5 browsing of media stored on a server.

# Getting the container

## Pull
This image is not on the docker hub yet.

## Clone
    $ git clone https://github.com/msm-/mediagoblin_docker.git

# Building the container

    $ docker-compose build
    $ docker images
    REPOSITORY                      TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    mediagoblindocker_mediagoblin   latest              772169736ac3        4 minutes ago       882.4 MB
    postgres                        latest              0e9ef8dc211f        3 days ago          213.9 MB

# Running the container

Set up the database:

    $ docker-compose run --rm mediagoblin gmg dbupdate

Create a user:

    $ docker-compose run --rm mediagoblin gmg adduser --username <user> --password <password> --email <email>

Run the site:

    $ docker-compose up

# Configuration

## Database
If you change the database name / user / etc from the postresql docker defaults, modify the `sql_engine` entry in `mediagoblin_local.ini` appropriately.

The data is stored in the postgres image's volume - you can start a container with volumes-from to back it up, or remove it with `docker rm -v mediagoblindocker_db_1` to delete the data.

## Local Files
This instance is configured to use the gmg\_localfiles plugin to serve existing media from the filesystem without copying it. This means that you can't upload files, only import existing files on the server.

By default the media is served from ./media - this can be a symlink. Change this in the volume specified in `docker-compose.yml`.

To perform the import run:

    $ docker-compose run --rm mediagoblin python -m mediagoblin.plugins.gmg_localfiles.import_files

To stop using localfiles, just remove the `[[gmg_localfiles]]` entry from `mediagoblin_local.ini`, and revert the storage settings in the same file to the mediagoblin defaults.

## Port
`docker-compose.yml` specifies the port that the web server is exposed on, 6543 by default.

## Plugins
To add additional plugins, add their dependencies to the Dockerfile, and an entry in `mediagoblin_local.ini`. Rebuild (`$ docker-compose build`) and update the database (`$ docker-compose run --rm mediagoblin gmg dbupdate`)

# Thanks

To [Mediatemple](https://mediatemple.net/), for [the original version](https://github.com/mediatemple/federated_services_oscon_2013)

# License

Copyright 2015 Michael Macnair

Copyright 2013 Media Temple, Inc.

This work is licensed under the [MIT license](LICENSE.md).
