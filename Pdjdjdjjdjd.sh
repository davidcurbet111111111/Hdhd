#!/data/data/com.termux/files/usr/bin/bash

URL="https://github.com/new"

# Ensure xdg-open exists
if ! command -v xdg-open >/dev/null 2>&1; then
  echo "[!] Installing xdg-utils..."
  pkg install -y xdg-utils
fi

echo "[*] Opening URL..."
xdg-open "$URL"

echo -e "Press Ctrl-C to exit\n"

# Dummy background process to allow wait
sleep infinity &
WAIT_PID=$!

# Wait until Ctrl+C
trap "kill $WAIT_PID 2>/dev/null; exit" INT TERM
wait $WAIT_PID
