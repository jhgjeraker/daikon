# daikon
A mini-project where I've linked Optical Character Recognition (OCR) with Large Language Model (LLM) queries for assisting with reading, grammar, and word lookup of non-selectable Japanese text.

![](https://f002.backblazeb2.com/file/bb-gjeraker/projects/daikon/example-usage-3.jpeg)

Note that native OCR is not available in Large Language Models (LLMs) at the time of this project, but I fully expect this to become a feature in the future. I made this little implementation simply because I don't want to wait. The power of querying LLMs for explaining unselectable text is just too convenient.

See https://gjeraker.com/content/projects/daikon.html for more background.

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
Call the script with the `llm` and `ocr` arguments.
```
./daikon llm ocr
```
This will allow you to capture JP text, then format a question around the result which is promptly sent to GPT using the OpenAI API as shown in the image above.

There are more functionality, mostly for convenience, but this is not some production-ready code, so you'll have to play around with the script if you're interested.
