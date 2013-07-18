#!/bin/bash

# load up virtualenv
. bin/activate

# update the database
./bin/gmg dbupdate
