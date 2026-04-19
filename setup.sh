#!/bin/bash

clear
echo "🚀 Ubuntu 22.04 VPS + SSH + ngrok setup starting..."

# Generate username
USERNAME="user$(tr -dc a-z0-9 </dev/urandom | head -c6)"

# Generate 20-character password
PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c20)

echo "👤 Username: $USERNAME"
echo "🔑 Password: $PASSWORD"

# Create user
sudo useradd -m -s /bin/bash $USERNAME
echo "$USERNAME:$PASSWORD" | sudo chpasswd
sudo usermod -aG sudo $USERNAME

# Install packages
echo "📦 Installing packages..."
sudo apt update -y
sudo apt install -y openssh-server curl wget unzip

# Start SSH
echo "🔐 Starting SSH..."
sudo service ssh start
sudo service ssh restart

# Install ngrok (v3)
echo "🌐 Installing ngrok..."
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip
unzip -o ngrok-v3-stable-linux-amd64.zip
chmod +x ngrok

# Input authtoken
echo ""
read -p "🔑 Enter your ngrok authtoken: " NGROK_TOKEN

./ngrok authtoken $NGROK_TOKEN

# Start ngrok tunnel
echo "🌍 Starting ngrok TCP tunnel on port 22..."
./ngrok tcp 22 > /dev/null 2>&1 &

sleep 6

# Get public address
NGROK_ADDR=$(curl -s http://127.0.0.1:4040/api/tunnels \
| grep -o 'tcp://[^"]*' \
| sed 's/tcp:\/\///')

HOST=$(echo $NGROK_ADDR | cut -d: -f1)
PORT=$(echo $NGROK_ADDR | cut -d: -f2)

echo ""
echo "✅ SETUP COMPLETE"
echo "===================================="
echo "👤 Username: $USERNAME"
echo "🔑 Password: $PASSWORD"
echo "🌐 ngrok Address: $HOST:$PORT"
echo ""
echo "🔐 SSH Command:"
echo "ssh $USERNAME@$HOST -p $PORT"
echo "===================================="

# Keep VPS alive
echo "♻️ Keeping Ubuntu running... Press CTRL+C to stop 🛑"
while true; do
  echo "running..."
  sleep 60
done
