# daikon
Reading assistant for JP manga combining OCR, LLMs, and Jisho.

## Motivation
TBA

## Setup
1. Install the `virtualenv` Python package.
```
pip install virtualenv
```

2. The OCR functionality relies on a screenshot utility to capture the text.
  - If you're on X11, install `maim`.
  - If you're on Wayland, install `flameshot`.

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
TBA
