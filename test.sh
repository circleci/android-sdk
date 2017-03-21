#!/bin/bash
DOCKER_HASH=`docker images | grep android | awk '{split($0,array," ")} END{print array[3]}'`
set -e
set -o pipefail

echo "Testing for presence of sdkmanager"
docker run -it $DOCKER_HASH moo
docker run -it $DOCKER_HASH sdkmanager --list
