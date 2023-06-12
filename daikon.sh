#!/bin/bash

tmp_capture='/tmp/daikon-capture.png'
clipboard=false
delay=0
session=$XDG_SESSION_TYPE

function usage() {
  echo "$0 (-d | --delay <INT>) (--clipboard)"
}

while (( "$#" )); do
  case "$1" in
    -d|--delay)
      if [ -n "$2" ] && [ "$2" -eq "$2" ] 2>/dev/null; then
        delay=$2
        shift 2
      else
        echo "Error: Invalid value for --delay/-d option"
        exit 1
      fi
      ;;
    --clipboard)
      clipboard=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: Invalid option $1"
      exit 1
      ;;
  esac
done

# Delete existing capture before taking a new one.
# This is mainly to deal with `flameshot` not overwriting
# but rather appending indices to new captures if one is already present.
if [[ -f "$tmp_capture" ]]; then
    rm -f "$tmp_capture"
fi
flameshot gui --path $tmp_capture -d $((delay * 1000)) --accept-on-select > /dev/null 2>&1

# Trigger the OCR service that runs on the specified port.
# The service will use the most recent capture in $tmp_capture.
ocr_text=$(echo "<args>" | nc 127.0.0.1 9929)

if $clipboard; then
    if [[ "$session" == "x11" ]]; then
        echo "$ocr_text" | xclip -sel clip
    elif [[ "$session" == "wayland" ]]; then
        wl-copy "$ocr_text"
    else
        echo "Error: Unsupported session type $session"
        exit 1
    fi
else
    echo "$ocr_text"
fi
