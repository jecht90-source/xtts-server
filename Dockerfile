FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

# Installazione esplicita con versioni fisse
RUN pip install --no-cache-dir \
    transformers==4.37.2 \
    TTS==0.22.0 \
    fastapi==0.115.6 \
    uvicorn==0.34.0 \
    pydantic==2.10.4

COPY app.py .

ENV DEVICE=cpu
ENV PORT=8000
ENV COQUI_TOS_AGREED=1

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
