#!/bin/bash

# Define variables
RUNNER_VERSION="2.320.0"
RUNNER_ARCH="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_ARCH}"
sha256="93ac1b7ce743ee85b5d386f5c1787385ef07b3d7c728ff66ce0d3813d5f46900"

# Update and install dependencies
echo "Updating system and installing dependencies..."
apt-get update
apt-get install -y --no-install-recommends curl tar wget coreutils git tree python3-pip
rm -rf /var/lib/apt/lists/*

# Download the runner package
curl -o "$RUNNER_ARCH" -L "$RUNNER_URL"

# Check hash for integrity
echo "$sha256  $RUNNER_ARCH" | sha256sum --strict --check -
tar xzf "$RUNNER_ARCH"

apt-get purge -y --auto-remove
