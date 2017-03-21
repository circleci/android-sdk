#!/bin/bash
DOCKER_HASH=`docker images | grep android | awk '{split($0,array," ")} END{print array[3]}'`
set -e
set -o pipefail

echo "Testing for presence of sdkmanager"
docker run -it $DOCKER_HASH sdkmanager --lis
echo "Testing ability to create AVD with sdcard
docker run -it $DOCKER_HASH echo "n" | avdmanager -v create avd -n androidlearn -k "system-images;android-25;google_apis;armeabi-v7a" -c 512M -g google_apis  -d "Nexus 7 2013"
