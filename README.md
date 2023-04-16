# daikon
Optical Character Recognition (OCR) to clipboard for Japanese.

## Prerequisites
1. Install the `virtualenv` Python package.
```
pip install virtualenv
```

2. The OCR functionality relies on a screenshot utility to capture the text. I've chosen `flameshot` as the default tool as it works in both X11 and Wayland sessions.

## Install
1. Verify that `install.sh` does nothing shady, then run it.
```
./install.sh
```

2. Enable the OCR service and socket.
```
systemctl enable --now daikon.socket
```

## Usage
Select an area to apply OCR. Result is copied to clipboard.
```
./daikon.sh
```

See `-h` for optional arguments.