### A few things worth noting:

* `deploy.sh` uses `sed` to substitute the actual install path and username into the service file at deploy time, so the service file in the repo stays generic with `__INSTALL_DIR__` placeholders — you don't need to edit anything manually.

* `app.py` uses `pkill -f chromium` rather than just `pkill chromium` — the `-f` flag matches against the full command line, which is more reliable when Chromium is launched via a .desktop file.

* One thing to verify: `sudo reboot` requires passwordless sudo for the pi user. On RaspiOS that's typically already the case, but if reboot doesn't work, check `/etc/sudoers`.

