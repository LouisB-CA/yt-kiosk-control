#  rpi4-kiosk-control
* A minimal web-based control panel for managing a Chromium kiosk on a Raspberry Pi 4.

* Served by a Flask app running as a systemd user service. 

* Accessible from any device on the local network — intended for use as a phone home screen shortcut.

### What it can do
* Kill Chromium (exits kiosk mode)
* Reboot the RPi4
* All actions require a confirmation tap

Repo structure
```text
rpi4-kiosk-control/
├── README.md
├── setup.sh                        # creates venv, installs packages
├── deploy.sh                       # installs app and systemd service
├── src/
│   ├── app.py                      # Flask server
│   ├── index.html                  # control panel UI
│   └── manifest.json               # web app manifest (standalone mode)
└── systemd/
    └── kiosk-control.service       # systemd user service definition
```

## Requirements

Raspberry Pi 4 running RaspiOS 12 (Bookworm)
Python 3 with venv support (python3-venv)
Flask (installed by setup.sh into a venv)

## Setup
1. Install system dependency if needed
```bash
sudo apt install python3-venv
```

2. Run setup script (creates venv, installs Flask)
```bash
chmod +x setup.sh
./setup.sh
```

3. Run deploy script (installs app and enables service)
```bash
chmod +x deploy.sh
./deploy.sh
```

4. Allow service to run without login session
```bash
sudo loginctl enable-linger $USER
```

5. Verify the service is running
```bash
systemctl --user status kiosk-control
```

6. Add to phone home screen
* Open Chrome on your phone and navigate to: http://<rpi4-ip>:5000
* Tap the browser menu → Add to Home Screen. The page will open in standalone
mode (no browser UI) thanks to the web app manifest.

## Installed locations
| File | Destination |
| ---- | ---- |
| app, html, manifest | ~/.local/share/kiosk-control/ |
| venv | ~/.local/share/kiosk-control/venv/ |
| systemd service | ~/.config/systemd/user/kiosk-control.service |

## Managing the service
```bash
systemctl --user start kiosk-control
systemctl --user stop kiosk-control
systemctl --user restart kiosk-control
systemctl --user status kiosk-control
```

### Logs
```bash
journalctl --user -u kiosk-control -f
```


