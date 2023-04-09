import socket
import os

from PIL import Image
from transformers import AutoFeatureExtractor, AutoTokenizer, VisionEncoderDecoderModel
import re
import jaconv

# load model
model_path = '../Japanese_OCR/model/'
image_processor = AutoFeatureExtractor.from_pretrained(model_path)
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = VisionEncoderDecoderModel.from_pretrained(model_path)
            
def post_process(text):
    text = ''.join(text.split())
    text = text.replace('…', '...')
    text = re.sub('[・.]{2,}', lambda x: (x.end() - x.start()) * '.', text)
    text = jaconv.h2z(text, ascii=True, digit=True)
    return text

def infer(image):
    image = image.convert('L').convert('RGB')
    pixel_values = image_processor(image, return_tensors="pt").pixel_values
    ouput = model.generate(pixel_values)[0]
    text = tokenizer.decode(ouput, skip_special_tokens=True)
    text = post_process(text)
    return text


def from_capture():
    img = Image.open('/tmp/capture.png')
    return infer(img)


def handle_request(conn, addr, input_data):
    res = f'{from_capture()}'
    # res = 'hello'
    conn.sendall(res.encode() + b'\n')


def main():
    # Get the listening socket information from systemd.
    LISTEN_FDS = int(os.environ.get("LISTEN_FDS", 0))
    if LISTEN_FDS != 1:
        raise RuntimeError("Expected exactly one socket from systemd")

    # Create a socket from the file descriptor provided by systemd
    listen_sock = socket.fromfd(3, socket.AF_INET, socket.SOCK_STREAM)

    # Accept connections and handle requests
    while True:
        conn, addr = listen_sock.accept()
        input_data = conn.recv(1024).decode('utf-8').strip()
        handle_request(conn, addr, input_data)
        conn.close()

if __name__ == "__main__":
    main()
