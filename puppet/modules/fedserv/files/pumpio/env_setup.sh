#!/bin/bash

# die on any error
set -e

# clone repo
git clone https://github.com/e14n/pump.io.git pumpio
cd pumpio

# install deps
npm install

# install databank-redis driver
cd node_modules/databank/
npm install databank-redis
