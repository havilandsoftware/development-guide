#!/usr/bin/env bash
# Upgrades Git to a current version via the official git-core PPA.
# Ubuntu only (PPAs don't apply to Debian); Ubuntu's default repo lags
# well behind the floor in dev-check.
set -e

sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
sudo apt install -y git

git --version
