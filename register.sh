#!/bin/bash

if [ -z "$GITHUB_REPOSITORY" ]; then
  echo "Container failed to start, don't forget to pass -e GITHUB_REPOSITORY=your_user/repository_name"
  exit 1
fi

if [ -z "$RUNNER_TOKEN" ]; then
  echo "Container failed to start, don't forget to pass -e RUNNER_TOKEN=your_dynamically_generated_token"
  exit 1
fi

labels="gpu"
if [ -n "$EXTRA_LABELS" ]; then
    labels="$labels,$EXTRA_LABELS"
fi

# Setup the runner package
echo "https://github.com/$GITHUB_REPOSITORY"
RUNNER_ALLOW_RUNASROOT=1 ./config.sh \
    --unattended --url https://github.com/$GITHUB_REPOSITORY \
    --token $RUNNER_TOKEN --labels $labels --disableupdate --ephemeral

# Setup the runner package
RUNNER_ALLOW_RUNASROOT=1 ./run.sh
