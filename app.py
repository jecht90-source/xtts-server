# app.py
import os
import tempfile

from fastapi import FastAPI, Query
from fastapi.responses import Response

from TTS.api import TTS

app = FastAPI()

# Carica il modello XTTS v2 (multilingua)
MODEL_NAME = "tts_models/multilingual/multi-dataset/xtts_v2"
DEVICE = os.getenv("DEVICE", "cpu")

tts = TTS(MODEL_NAME).to(DEVICE)


@app.get("/tts")
async def tts_get(text: str = Query(..., min_length=1)):
    """
    GET /tts?text=...
    Restituisce audio/wav in italiano con XTTS v2.
    """
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
        out_path = f.name

    tts.tts_to_file(
        text=text,
        speaker_wav=None,
        language="it",
        file_path=out_path,
        split_sentences=True,
    )

    with open(out_path, "rb") as f:
        audio_bytes = f.read()

    os.remove(out_path)

    return Response(content=audio_bytes, media_type="audio/wav")


@app.get("/health")
async def health():
    return {"status": "ok", "device": DEVICE}
