#!/usr/bin/env bash
# Installs Docker Engine via Docker's official convenience script, and
# adds the current user to the docker group. See
# https://docs.docker.com/engine/install/ubuntu for what the script does.
# Docker recommends the convenience script for dev machines, not production.
set -e

script=$(mktemp)
curl -fsSL https://get.docker.com -o "$script"
sudo sh "$script"
rm -f "$script"
sudo usermod -aG docker "$USER"

docker --version
echo "Log out and back in for the docker group change to take effect."
