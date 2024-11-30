#! /bin/bash

pip install vastai
trap 'vastai destroy instance $CONTAINER_ID' EXIT

EXTRA_LABELS="vastai"

if [ -z "$CONTAINER_ID" ]; then
  echo "CONTAINER_ID not defined"
fi
if [ ! -f ~/.vast_api_key ]; then
  echo "~/.vast_api_key not found, regenerating"
  cat ~/.ssh/authorized_keys | md5sum | awk '{print $1}' > ssh_key_hv; echo -n $VAST_CONTAINERLABEL | md5sum | awk '{print $1}' > instance_id_hv; head -c -1 -q ssh_key_hv instance_id_hv > ~/.vast_api_key;
fi

if [ -n "$CONTAINER_ID" ]; then
  EXTRA_LABELS="${EXTRA_LABELS},${CONTAINER_ID}"
fi

bash ./register.sh
