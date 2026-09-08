#!/usr/bin/env bash
# Installs Docker Engine via Docker's official convenience script, and
# adds the current user to the docker group. See
# https://docs.docker.com/engine/install/ubuntu for what the script does.
set -e

curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh
rm -f /tmp/get-docker.sh
sudo usermod -aG docker "$USER"

docker --version
echo "Log out and back in for the docker group change to take effect."
