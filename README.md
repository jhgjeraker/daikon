# daikon
Reading assistant for JP manga combining OCR, LLMs, and Jisho.

## Install
1. Make sure you have the `virtualenv` Python package.

```
pip install virtualenv
```

2. Verify that `install.sh` does nothing shady, the run it.

```
./install.sh
```

3. Enable the OCR service and socket.

```
systemctl enable --now daikon.socket
```
