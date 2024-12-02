#! /bin/bash

set -e 
set -o pipefail

pipx ensurepath
source ~/.bashrc
pipx install vastai
trap 'vastai destroy instance $CONTAINER_ID' EXIT

export EXTRA_LABELS="vastai"

if [ -z "$CONTAINER_ID" ]; then
  echo "CONTAINER_ID not defined"
fi
if [ ! -f ~/.vast_api_key ]; then
  echo "~/.vast_api_key not found, regenerating"
  echo "$CONTAINER_API_KEY" > ~/.vast_api_key
fi
if [ -z "$CONTAINER_API_KEY" ]; then
  echo "CONTAINER_API_KEY not defined"
fi
if [ -n "$CONTAINER_ID" ]; then
  EXTRA_LABELS="${EXTRA_LABELS},${CONTAINER_ID}"
fi

bash ./register.sh
