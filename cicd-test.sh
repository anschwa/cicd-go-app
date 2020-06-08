#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

BUILD_NUMBER="$SEMAPHORE_WORKFLOW_NUMBER"

app="cicd-go-app"

docker build \
       --file="test.Dockerfile" \
       --build-arg BUILD_NUMBER="$BUILD_NUMBER" \
       --tag "$app:tmp" .
