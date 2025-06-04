FROM python:3.10-slim

# Install dependencies
RUN apt-get update && apt-get install -y espeak-ng wget git

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
