FROM python:3.12.3

# Install ffmpeg (required for Whisper)
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
RUN pip install --no-cache-dir \
    openai-whisper \
    fastapi \
    "uvicorn[standard]" \
    python-multipart

# Copy application code
COPY app.py .

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
