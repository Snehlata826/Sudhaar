#!/usr/bin/env bash
# Usage: ./run.sh            (http://localhost:8000)
# Camera access needs HTTPS or localhost. For a phone on the same Wi-Fi use a tunnel (e.g. `cloudflared tunnel --url http://localhost:8000`)
set -e
cd "$(dirname "$0")"
python3 -m pip install -q -r requirements.txt 2>/dev/null || true
exec python3 -m uvicorn backend.main:app --host 0.0.0.0 --port "${PORT:-8000}"
