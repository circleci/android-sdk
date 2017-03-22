#!/bin/bash
DOCKER_HASH=`docker images | grep android | awk '{split($0,array," ")} END{print array[3]}'`
set -e
set -o pipefail

echo "Testing for presence of sdkmanager"
docker run -it $DOCKER_HASH sdkmanager --list
echo "Testing for presence of avdmanager"
docker run -it $DOCKER_HASH avdmanager
echo "Testing for presence of mksdcard"
docker run -it $DOCKER_HASH mksdcard
