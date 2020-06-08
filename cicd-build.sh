#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

BUILD_NUMBER="$SEMAPHORE_WORKFLOW_NUMBER"

app="cicd-go-app"
build_number=$(printf %03d "$BUILD_NUMBER")
branch=$(git rev-parse --abbrev-ref HEAD)

echo "Building docker image..."
docker build \
       --build-arg BUILD_NUMBER="$build_number" \
       --tag="$app:$branch" .

echo "Done."
