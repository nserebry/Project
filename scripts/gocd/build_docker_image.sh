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

# Build docker image
docker build --rm -t "$image" .

# Upload it to docker registry
docker push "$image"


# Delete docker image from local once image is uploaded to registry
docker rmi "$image"
