#!/bin/bash

# Script to check for updates in rsgain repo and rebuild the Docker image if needed

REPO_URL="https://github.com/complexlogic/rsgain.git"
IMAGE_NAME="rsgain-runner"

# Get the latest commit hash from remote
LATEST_COMMIT=$(git ls-remote $REPO_URL HEAD | awk '{print $1}')

# Get the commit hash used in the last build (store it in a file)
LAST_BUILD_FILE=".last_build_commit"

if [ -f "$LAST_BUILD_FILE" ]; then
    LAST_COMMIT=$(cat $LAST_BUILD_FILE)
else
    LAST_COMMIT=""
fi

if [ "$LATEST_COMMIT" != "$LAST_COMMIT" ]; then
    echo "New version available. Rebuilding Docker image..."
    docker build -t $IMAGE_NAME .
    if [ $? -eq 0 ]; then
        echo $LATEST_COMMIT > $LAST_BUILD_FILE
        echo "Image rebuilt successfully."
    else
        echo "Build failed."
        exit 1
    fi
else
    echo "No updates available."
fi