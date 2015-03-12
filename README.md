# Description

A docker image for mediagoblin.

After the VM is done provisioning, point your web browser at <http://localhost:9000>.

Look in `/var/log/mediagoblin/mediagoblin-paster.log` for the MediaGoblin log.  This is necessary to view the account verification link.

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

# Configuration

## Database
Set up the database:
    $ docker-compose run --rm mediagoblin gmg dbupdate

If you change the database name / user / etc, modify the `sql_engine` entry in `mediagoblin_local.ini` appropriately.

The data is stored in the postgres image's volume - you can start a container with volumes-from to back it up.

## Local Files
This instance is configured to use the gmg\_localfiles plugin to serve existing media from the filesystem without copying it.

By default the media is served from ./media - this can be a symlink. Change this in the volume specified in docker-compose.yml

To perform the import run:
    $ docker-compose run --rm mediagoblin python -m mediagoblin.plugins.gmg_localfiles.import_files

To stop using localfiles, just remove the `[[gmg_localfiles]]` entry from `mediagoblin_local.ini`, and revert the storage settings in the same file to the mediagoblin defaults.

## Port
docker-compose.yml specifies the port that the web server is exposed on.

## Plugins
To add additional plugins, add their dependencies to the Dockerfile, and an entry in the ini file. Rebuild ($ docker-compose build) and update the database ($ docker-compose run --rm mediagoblin gmg dbupdate)

# Running the container

Run the app:
    $ docker-compose up

Access the website on port 6543 in a browser and click on `Create an account at this site`.  After filling out the information, there will be a message about the email verification being printed on the server. You'll find the link on the output from docker-compose, in the form:
    http://localhost:6543/auth/verify_email/?token=MQ.BNCKgQ.GLcqe3l61XNibYjH88VJ7Bv2g4U
(if you ran `docker-compose up -d`, then you'll need to run `docker-compose logs`)

# Thanks

To [Mediatemple](https://mediatemple.net/), for [the original version](https://github.com/mediatemple/federated_services_oscon_2013)

# License

Copyright 2015 Michael Macnair
Copyright 2013 Media Temple, Inc.

This work is licensed under the [MIT license](LICENSE.md).
