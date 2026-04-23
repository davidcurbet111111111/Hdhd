#!/bin/bash

# Clean up any previous files silently
rm -rf ngrok ngrok.zip ng.sh > /dev/null 2>&1

echo "======================="
echo "Download ngrok"
echo "======================="

# Download ngrok zip silently
wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1

# Unzip ngrok silently
unzip ngrok.zip > /dev/null 2>&1

# Prompt user to paste ngrok authtoken
read -p "Paste Ngrok Authtoken: " CRP

# Configure ngrok authtoken
./ngrok authtoken $CRP

# Set password (replace $123 with your desired password)
echo -e "$123\n$123\n" | sudo passwd

# Clean up downloaded files silently
rm -rf ngrok ngrok.zip ng.sh > /dev/null 2>&1

clear

echo "======================="
echo "Choose ngrok region"
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"

# Read user choice for region
read -p "Choose ngrok region: " CRP

# Start ngrok TCP tunnel on port 3388 in background silently
./ngrok tcp --region $CRP 3388 &> /dev/null &

echo "===================================="
echo "Install RDP"
echo "===================================="

# Pull the Ubuntu XRDP Docker image
docker pull danielguerra/ubuntu-xrdp

clear

echo "===================================="
echo "Start RDP"
echo "===================================="
echo "===================================="
echo "Username : ubuntu"
echo "Password : ubuntu"
echo "RDP Address:"

# Fetch and display the public TCP URL from ngrok API
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:\/\/([^"]*).*/\1/p'

echo "===================================="
echo "===================================="
echo "Don't close this tab to keep RDP running"
echo "Keep support HACKTECHTV CHANNEL thank you"
echo "Wait 2 minutes to finish the setup then connect using the RDP Address"
echo "===================================="
echo "===================================="

# Run the XRDP Docker container mapping port 3388 to 3389 silently
docker run --rm -p 3388:3389 danielguerra/ubuntu-xrdp:kali > /dev/null 2>&1

# Note: To stop the RDP server, press Ctrl+C
