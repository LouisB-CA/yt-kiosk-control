#!/bin/bash
# uninstall.sh
# Stops and removes the yt-kiosk-control service and all installed files.

set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/environ.sh"

echo "==> Stopping and disabling $SERVICE_NAME"
systemctl --user stop "$SERVICE_NAME" 2>/dev/null || true
systemctl --user disable "$SERVICE_NAME" 2>/dev/null || true

echo "==> Removing service file"
rm -f "$SYSTEMD_DIR/$SERVICE_NAME.service"

echo "==> Reloading systemd user daemon"
systemctl --user daemon-reload

echo "==> Removing installed files"
rm -rf "$INSTALL_DIR"

echo ""
echo "Done. $SERVICE_NAME has been removed."
echo ""
echo "Note: if you ran 'sudo loginctl enable-linger $USER' during setup"
echo "and want to undo that, run:"
echo "  sudo loginctl disable-linger $USER"


