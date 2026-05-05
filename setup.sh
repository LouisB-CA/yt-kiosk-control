#!/bin/bash
# setup.sh
# Creates a Python virtual environment and installs required packages.
# Run this once from the repo root before deploying.

set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/environ.sh"

echo "==> Creating virtual environment at $VENV_DIR"
python3 -m venv "$VENV_DIR"

echo "==> Upgrading pip"
"$VENV_DIR/bin/pip" install --upgrade pip --quiet

echo "==> Installing Flask"
"$VENV_DIR/bin/pip" install flask --quiet

echo ""
echo "Done. Run ./deploy.sh to install the app and enable the service."

