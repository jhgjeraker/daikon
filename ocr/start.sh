#!/bin/bash

# Get the absolute path of the script.
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Change the working directory to the directory containing the script.
cd "$SCRIPT_DIR" || exit 1

source ../venv/bin/activate
python ocr_service.py

echo "done"