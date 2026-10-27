#!/usr/bin/env bash
# Upgrades Git to a current version via the official git-core PPA.
# Ubuntu/Debian's default repo lags well behind the floor in dev-check.
set -e

sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
sudo apt install -y git

git --version
