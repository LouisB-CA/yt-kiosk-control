#!/usr/bin/env python3
# app.py
# Minimal Flask control server for RPi4 kiosk management.
# Listens on all interfaces, port 5000.

import subprocess
import logging
from flask import Flask, send_from_directory, request

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(message)s'
)
log = logging.getLogger(__name__)

app = Flask(__name__, static_folder=".")


@app.route("/")
def index():
    return send_from_directory(".", "index.html")


@app.route("/manifest.json")
def manifest():
    return send_from_directory(".", "manifest.json")


@app.route("/kill")
def kill():
    caller = request.remote_addr
    log.info('/kill requested by %s — running pkill -f chromium', caller)
    result = subprocess.run(["pkill", "-f", "chromium"], check=False)
    if result.returncode == 0:
        log.info('/kill succeeded (chromium terminated)')
    else:
        log.warning('/kill: pkill returned %d — no matching chromium process found', result.returncode)
    return ("", 204)


@app.route("/reboot")
def reboot():
    caller = request.remote_addr
    log.info('/reboot requested by %s — running sudo reboot', caller)
    result = subprocess.run(["sudo", "reboot"], check=False)
    # If we get here, reboot didn't fire immediately (unexpected)
    log.warning('/reboot: sudo reboot returned %d — reboot may not have triggered', result.returncode)
    return ("", 204)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
