# 🎬 YouTube Downloader (Flutter + FastAPI + yt-dlp)

Aplicação local desenvolvida em **Flutter (frontend)** + **Python (FastAPI backend)** para:

- 📄 Obter informações de vídeos do YouTube  
- 🎵 Baixar áudio em **MP3**  
- 🎥 Baixar vídeo em **MP4**  
- 🖥️ Funcionar em **desktop**

---

## ⚠️ Aviso Legal

Este projeto é destinado **exclusivamente para fins educacionais**.

O usuário é totalmente responsável por respeitar os **Termos de Serviço do YouTube** e as leis de **direitos autorais** vigentes em seu país.

---

## 🧱 Arquitetura do Projeto

```text
youtube_downloader/
│
├── youtube_downloader/
│   └── lib/
│
└── youtube_downloader_backend/
    ├── main.py
```

## 🛠️ Tecnologias Utilizadas

- Flutter
- Dart
- Python 3.10+
- FastAPI
- Uvicorn
- yt-dlp
- HTTP REST

## 🚀 Como Rodar o Projeto

- Criar ambiente virtual ```python -m venv venv```
- Ativar (Windows) ```venv\Scripts\activate```
- Instalar dependências ```pip install fastapi uvicorn yt-dlp```
- Iniciar o servidor backend ```uvicorn main:app --reload```
- Saida esperada: Uvicorn running on http://127.0.0.1:8000

#### Swegger para testes backend: http://127.0.0.1:8000/docs

## 📱 Frontend (Flutter)

- Instalar dependências do Flutter ```flutter pub get```
- Executar o aplicativo ```flutter run -d windows```

### Endpoints Utilizados

| Método | Endpoint           | Descrição                    |
| ------ | ------------------ | ---------------------------- |
| POST   | `/video/info`      | Obtém informações do vídeo   |
| POST   | `/download`        | Realiza o download           |
| GET    | `/file/{filename}` | Retorna o arquivo para o app |

