# Docker for MediaGoblin

## Pull

TBW

## Build 

    $ docker build -t mediagoblin .
    Uploading context 20480 bytes
    Step 1 : FROM lopter/raring-base:latest
     ---> 52dbc0e3cd5a
    ... snip ...
    Step 24 : CMD ["/usr/bin/supervisord", "-n"]
     ---> Running in 0d1c055df130
     ---> b10ed0e5267c
    Successfully built b10ed0e5267c
    $ docker images
    REPOSITORY           TAG                 ID                  CREATED             SIZE
    lopter/raring-base   latest              52dbc0e3cd5a        7 weeks ago         186.4 MB (virtual 347.9 MB)
    mediagoblin          latest              b10ed0e5267c        2 minutes ago       12.29 kB (virtual 1.029 GB)

## Running

TBW
