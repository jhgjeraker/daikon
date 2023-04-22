#!/bin/bash

# Install distro packages required for a quick setup.
distro=$(cat /etc/os-release | grep -i ID= | grep -P -o '(?<==).*$' | head -1)
if [[ "$distro" =~ ^(fedora)$ ]]; then
    sudo dnf install $(cat packages/fedora)
else
    echo "No automation for \"$distro\"."
    exit 1
fi

# Install virtualenv to system Python.
pip install virtualenv

# Create virtual Python environment.
python -m virtualenv --clear venv
source venv/bin/activate
pip install --upgrade pip -r requirements.txt

# Create a symlink in path to the OCR service startup script.
service_symlink=/usr/bin/daikon-ocr-service
if [[ -L "$service_symlink" ]]; then
    sudo rm -f $service_symlink
fi
sudo ln -s "$(pwd)/ocr/start.sh" "$service_symlink"

# Deploy, start, and enable systemd service for OCR socket.
# Note that user must enable service manually with
# systemctl enable --now daikon.socket
sudo cp -r ./systemd/* /etc/systemd/system/

# Pull model files from Hugging Face.
# Target directory has already been added to gitignore.
model_dir='./Japanese_OCR/'
if [[ ! -d "$model_dir" ]]; then
    git clone https://huggingface.co/spaces/jhgjeraker/Japanese_OCR
fi