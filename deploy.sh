#!/bin/sh
if [ $CIRCLE_BRANCH == "master" ]
then
  echo "Deploying to DockerHub"
  docker login -u $DOCKERHUB_USER -p $DOCKERHUB_PASS
  docker push marcomorain/android:$TAG
else
  echo "Not on master, not deploying"
fi
