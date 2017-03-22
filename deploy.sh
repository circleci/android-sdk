#!/bin/bash
if [ $CIRCLE_BRANCH == "master" ]
then
  echo "Deploying to DockerHub"
  docker login -u $DOCKER_USER -p $DOCKER_PASS
  TAG=1.0.$CIRCLE_BUILD_NUM
  docker push drazisil/android-sdk:$TAG
else
  echo "Not on master, not deploying"
fi
