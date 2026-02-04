from fastapi import FastAPI, HTTPException, Form, BackgroundTasks
from fastapi.responses import FileResponse
import subprocess
import uuid
import os
import json
import sys
import tempfile

app = FastAPI()

DOWNLOAD_DIR = tempfile.mkdtemp(prefix="yt_downloads_")

@app.post("/video/info")
def video_info(url: str = Form(...)):
    try:
        result = subprocess.run(
            [
                sys.executable,
                "-m", "yt_dlp",
                "--dump-json",
                "--no-playlist",
                "--no-warnings",
                url
            ],
            capture_output=True,
            text=True,
            timeout=20
        )

        if result.returncode != 0:
            print("STDERR:", result.stderr)
            raise Exception(result.stderr)

        data = json.loads(result.stdout)

        return {
            "title": data.get("title"),
            "duration": data.get("duration"),
            "uploader": data.get("uploader"),
        }

    except subprocess.TimeoutExpired:
        raise HTTPException(
            status_code=408,
            detail="Timeout ao obter informações do vídeo"
        )

    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@app.post("/download")
def download(
    url: str = Form(...),
    format: str = Form(...)
):
    try:
        file_id = str(uuid.uuid4())
        output_template = os.path.join(DOWNLOAD_DIR, f"{file_id}.%(ext)s")

        if format == "mp3":
            command = [
                sys.executable,
                "-m", "yt_dlp",
                "--no-playlist",
                "-x",
                "--audio-format", "mp3",
                "-o", output_template,
                url
            ]
        else:
            command = [
                sys.executable,
                "-m", "yt_dlp",
                "--no-playlist",
                "-f", "mp4",
                "-o", output_template,
                url
            ]

        subprocess.run(command, check=True)

        for file in os.listdir(DOWNLOAD_DIR):
            if file.startswith(file_id):
                return {"file": file}

        raise Exception("Arquivo não encontrado")

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/file/{filename}")
def get_file(filename: str, background_tasks: BackgroundTasks):
    path = os.path.join(DOWNLOAD_DIR, filename)

    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail="Arquivo não encontrado")

    background_tasks.add_task(os.remove, path)

    return FileResponse(
        path,
        filename=filename,
        media_type="application/octet-stream"
    )
