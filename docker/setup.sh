#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Chrome Remote (Guacamole + RDP) setup"
echo

# --- Step 1: .env file ---
if [ ! -f .env ]; then
  cp .env.example .env
  echo "[1/4] Created .env from .env.example"
  echo "      Edit .env and set POSTGRES_PASSWORD before sharing access."
else
  echo "[1/4] .env already exists"
fi

# shellcheck disable=SC1091
set -a
source .env
set +a

# --- Step 2: Guacamole database schema ---
if [ ! -f init/initdb.sql ]; then
  mkdir -p init
  echo "[2/4] Generating init/initdb.sql (one-time Guacamole DB schema)..."
  docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgresql > init/initdb.sql
  echo "      init/initdb.sql created"
else
  echo "[2/4] init/initdb.sql already exists"
fi

# --- Step 3: Build rdesktop image with Chrome ---
echo "[3/4] Building rdesktop image (XFCE + xrdp + Chrome)..."
docker compose build rdesktop

# --- Step 4: Start stack ---
echo "[4/4] Starting containers..."
docker compose up -d

echo
echo "Stack is up. Next steps:"
echo
echo "  1. Open Guacamole:  http://<server-ip>:${GUACAMOLE_PORT:-8080}/guacamole"
echo "     Default login:    guacadmin / guacadmin  (change immediately)"
echo
echo "  2. In Guacamole admin (Settings -> Connections -> New Connection):"
echo "     Name:      Chrome Desktop"
echo "     Protocol:  RDP"
echo "     Host:      rdesktop"
echo "     Port:      3389"
echo "     Username:  abc"
echo "     Password:  abc"
echo "     Enable:    Audio (+ Microphone if needed)"
echo
echo "  3. RDP desktop login (inside the session) is also abc / abc by default."
echo "     Change that password after first login."
echo
echo "  4. For your friend in another city: install Tailscale on both machines,"
echo "     then use the server's Tailscale IP instead of LAN IP."
echo
