FROM python:3.9-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone the Piper repository
RUN git clone https://github.com/rhasspy/piper.git /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Download a default voice model (e.g., en_US-amy-low)
RUN mkdir -p /app/models && \
    curl -L -o /app/models/en_US-amy-low.onnx https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US-amy-low.onnx && \
    curl -L -o /app/models/en_US-amy-low.onnx.json https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US-amy-low.onnx.json

# Expose port
EXPOSE 5000

# Set environment variables
ENV MODEL_PATH=/app/models/en_US-amy-low.onnx
ENV CONFIG_PATH=/app/models/en_US-amy-low.onnx.json

# Start the Piper server
CMD ["python", "server.py", "--model", "$MODEL_PATH", "--config", "$CONFIG_PATH", "--port", "5000"]
