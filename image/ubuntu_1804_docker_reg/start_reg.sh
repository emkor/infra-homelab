#!/usr/bin/env bash

set -e

docker pull registry:2
docker-compose -f ./docker-compose.yml up -d
