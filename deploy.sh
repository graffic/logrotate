#!/usr/bin/env bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 image_name tag_name"
fi

echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
echo "Pushing to hub: $1 -> $1:$2"
docker tag $1 $1:$2
docker push $1:$2