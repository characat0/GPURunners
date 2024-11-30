#! /bin/bash

CONTAINER_LABEL=$(cat ~/.vast_containerlabel)
INSTANCE_ID=${CONTAINER_LABEL#"C."}

EXTRA_LABELS="vastai"

if [ -n "$INSTANCE_ID" ]; then
  EXTRA_LABELS="${EXTRA_LABELS},${INSTANCE_ID}"
fi

bash ./register.sh

