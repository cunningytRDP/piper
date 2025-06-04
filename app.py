from flask import Flask, request, send_file
import os
import uuid
import subprocess
import json

app = Flask(__name__)

VOICE_PATH = "models/en_US-amy-low.onnx"
CONFIG_PATH = "config/en_US-amy-low.onnx.json"

@app.route("/tts", methods=["POST"])
def tts():
    data = request.get_json()
    text = data.get("text", "")
    voice = VOICE_PATH

    if not text:
        return {"error": "Text not provided"}, 400

    out_path = f"/tmp/{uuid.uuid4()}.wav"

    command = [
        "piper",
        "--model", voice,
        "--config", CONFIG_PATH,
        "--output_file", out_path,
        "--sentence_silence", "0.3"
    ]

    process = subprocess.Popen(command, stdin=subprocess.PIPE)
    process.communicate(input=text.encode())

    if not os.path.exists(out_path):
        return {"error": "Failed to synthesize voice"}, 500

    return send_file(out_path, mimetype="audio/wav")
