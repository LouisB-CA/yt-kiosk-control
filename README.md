# rpi4-kiosk-control

A minimal web-based control panel for managing a Chromium kiosk on a Raspberry Pi 4.
Served by a Flask app running as a systemd user service. Accessible from any device
on the local network — intended for use as a phone home screen shortcut.

## What it does

- One button kills Chromium (exits kiosk mode)
- The other button Reboots the RPi4
- Each button requires a confirmation tap

## Repo structure

```
yt-rpi4-kiosk-control/
├── README.md
├── docs
│   ├── llm-chat-01.md
│   ├── llm-chat-02.md
│   └── llm-chat-03.md
├── src
│   ├── app.py
│   ├── icon-192.png
│   ├── icon-512.png
│   ├── icon-512.svg
│   ├── index.html
│   └── manifest.json
├── systemd
│   └── yt-kiosk-control.service
├── extras
│   └── fix-png.sh
├── deploy.sh
├── environ.sh
├── setup.sh
└── uninstall.sh
```

## Requirements

- Raspberry Pi 4 running RaspiOS 12 (Bookworm)
- Python 3 with venv support (`python3-venv`)
- Flask (installed by setup.sh into a venv)

## Setup

### 1. Install system dependency if needed

```bash
sudo apt install python3-venv
```

### 2. Run setup script (creates venv, installs Flask)

```bash
chmod +x setup.sh
./setup.sh
```

### 3. Run deploy script (installs app and enables service)

```bash
chmod +x deploy.sh
./deploy.sh
```

### 4. Allow service to run without login session

```bash
sudo loginctl enable-linger $USER
```

### 5. Verify the service is running

```bash
systemctl --user status kiosk-control
```

### 6. Add to phone home screen

Open Chrome on your phone and navigate to:

```
http://<rpi4-ip>:5000
```

Tap the browser menu → **Add to Home Screen**. The page will open in standalone
mode (no browser UI) thanks to the web app manifest.

## Installed locations

| File | Destination |
|------|-------------|
| app, html, manifest | `~/.local/share/kiosk-control/` |
| venv | `~/.local/share/kiosk-control/venv/` |
| systemd service | `~/.config/systemd/user/kiosk-control.service` |

## Managing the service

```bash
systemctl --user start kiosk-control
systemctl --user stop kiosk-control
systemctl --user restart kiosk-control
systemctl --user status kiosk-control
```

## Logs

```bash
journalctl --user -u kiosk-control -f
```
