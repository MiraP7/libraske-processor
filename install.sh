#!/usr/bin/env bash

set -euo pipefail

LINUX_PACKAGES="build-essential python3-venv python3-pip"
VENV_DIR=".venv"
PYTHON_BIN="$VENV_DIR/bin/python"
PIP_BIN="$VENV_DIR/bin/pip"

install_system_dependencies() {
  echo "Installing required system dependencies..."

  if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    apt-get update
    apt-get install -y $LINUX_PACKAGES
  elif command -v sudo >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y $LINUX_PACKAGES
  else
    echo "This script requires root access or sudo to install system packages." >&2
    return 1
  fi
}

create_virtualenv() {
  if [[ ! -x "$PYTHON_BIN" ]]; then
    echo "Creating Python virtual environment..."
    python3 -m venv "$VENV_DIR"
  fi
}

install_python_packages() {
  echo -e "\nInstalling required python packages..."
  "$PIP_BIN" install --upgrade pip setuptools wheel
  "$PIP_BIN" install -r requirements.txt
}

install_system_dependencies && \
create_virtualenv && \
install_python_packages && \

echo -e "\nSuccessful installation!" || echo -e "\nInstallation failed!"