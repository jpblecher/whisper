from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
import whisper
import tempfile
import shutil

MODEL_NAME = "small"
model = whisper.load_model(MODEL_NAME)

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok", "model": MODEL_NAME}

@app.post("/transcribe")
async def transcribe(file: UploadFile = File(...)):
    with tempfile.NamedTemporaryFile(suffix=file.filename, delete=True) as tmp:
        shutil.copyfileobj(file.file, tmp)
        tmp.flush()
        result = model.transcribe(tmp.name, fp16=False)

    return JSONResponse({"text": result.get("text", ""), "model": MODEL_NAME})
