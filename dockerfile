FROM debian:bullseye-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip curl unzip git \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Install Piper binary
RUN curl -LO https://github.com/rhasspy/piper/releases/download/v1.2.0/piper-linux-x86_64 \
    && chmod +x piper-linux-x86_64 \
    && mv piper-linux-x86_64 /usr/local/bin/piper

# Create voices directory and download a voice model
RUN mkdir -p /app/voices \
    && curl -L https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/en_US-amy-low.onnx -o voices/en_US-amy-low.onnx \
    && curl -L https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/en_US-amy-low.onnx.json -o voices/en_US-amy-low.json

COPY . /app

EXPOSE 5000

CMD ["python3", "app.py"]
