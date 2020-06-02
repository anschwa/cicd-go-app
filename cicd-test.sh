#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

app="cicd-go-app"

docker build \
       --file="test.Dockerfile" \
       --build-arg BUILD_NUMBER="$BUILD_NUMBER" \
       --tag "$app:tmp" .
