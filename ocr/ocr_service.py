import socket
import os

from PIL import Image
from transformers import AutoFeatureExtractor, AutoTokenizer, \
    VisionEncoderDecoderModel
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
    img = Image.open('/tmp/daikon-capture.png')
    return infer(img)


def handle_request(conn, addr, input_data):
    res = f'{from_capture()}'
    conn.sendall(res.encode() + b'\n')


def main():
    # Create a listening socket
    listen_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Set options
    listen_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    # Bind and listen
    listen_sock.bind(("localhost", 9929))
    listen_sock.listen(1)

    # Accept connections and handle requests
    print('listening...')
    while True:
        conn, addr = listen_sock.accept()
        input_data = conn.recv(1024).decode('utf-8').strip()
        handle_request(conn, addr, input_data)
        conn.close()


if __name__ == "__main__":
    main()
