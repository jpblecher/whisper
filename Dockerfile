FROM python:3.12.3

# ffmpeg für Whisper
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Whisper + Webserver installieren
RUN pip install --no-cache-dir \
      openai-whisper \
      fastapi \
      "uvicorn[standard]"

# App-Code in den Container kopieren
COPY app.py .

# Interner Port
EXPOSE 8000

# Nur 1 Worker, damit das Modell nicht doppelt im RAM liegt
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
