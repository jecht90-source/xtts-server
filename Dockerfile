FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENV DEVICE=cpu
ENV PORT=8000
ENV COQUI_TOS_AGREED=1

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
