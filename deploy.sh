#!/usr/bin/env bash

echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
docker tag graffic/logrotate graffic/logrotate:$TRAVIS_TAG
docker push graffic/logrotate:$TRAVIS_TAG