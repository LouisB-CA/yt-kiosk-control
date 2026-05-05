#!/bin/bash
# deploy.sh
# Copies app files to ~/.local/share/yt-kiosk-control and installs the
# systemd user service. Run after setup.sh.

set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/environ.sh"

# Verify venv exists
if [ ! -f "$VENV_DIR/bin/python" ]; then
    echo "ERROR: venv not found. Run ./setup.sh first."
    exit 1
fi

echo "==> Creating install directory at $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

echo "==> Copying app files"
cp "$REPO_DIR/src/app.py"        "$INSTALL_DIR/app.py"
cp "$REPO_DIR/src/index.html"    "$INSTALL_DIR/index.html"
cp "$REPO_DIR/src/manifest.json" "$INSTALL_DIR/manifest.json"
cp "$REPO_DIR/src/icon-192.png"  "$INSTALL_DIR/icon-192.png"
cp "$REPO_DIR/src/icon-512.png"  "$INSTALL_DIR/icon-512.png"

echo "==> Copying venv"
cp -r "$VENV_DIR" "$INSTALL_DIR/venv"

echo "==> Installing systemd user service"
mkdir -p "$SYSTEMD_DIR"

# Write the service file with the resolved install path and user
sed \
    -e "s|__INSTALL_DIR__|$INSTALL_DIR|g" \
    -e "s|__USER__|$USER|g" \
    "$REPO_DIR/systemd/$SERVICE_NAME.service" \
    > "$SYSTEMD_DIR/$SERVICE_NAME.service"

echo "==> Reloading systemd user daemon"
systemctl --user daemon-reload

echo "==> Enabling and starting $SERVICE_NAME"
systemctl --user enable "$SERVICE_NAME"
systemctl --user restart "$SERVICE_NAME"

echo ""
echo "Done. Service status:"
systemctl --user status "$SERVICE_NAME" --no-pager

echo ""
echo "Access the control panel at:"
hostname -I | awk '{print "  http://" $1 ":5000"}'
echo ""
echo "To allow the service to run without an active login session:"
echo "  sudo loginctl enable-linger $USER"


