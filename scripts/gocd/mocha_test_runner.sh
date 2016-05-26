#!/bin/bash
set -e

if [ "$IMAGE_TAG" == "" ]; then
  echo "Please specify IMAGE_TAG"
  exit 1
fi

ostype=`uname`
if [ "$ostype" == "Darwin"]; then
  # Only needed for OS X
  eval $(docker-machine env)
fi

image=localhost:5000/mocha-test-image:"$IMAGE_TAG"

# Pull docker image from local repository
docker pull "$image"

# Run test
docker run --name mocha-test-container "$image"

# Fetch test results
docker cp mocha-test-container:/usr/src/app/test-results.xml ./

# Remove container
docker rm mocha-test-container

# Delete image
docker rmi "$image"
