#!/bin/bash

PIN_FILE="$HOME/.pin_vm"

clear

# ===== PIN SYSTEM =====
if [ ! -f "$PIN_FILE" ]; then
  echo "=== CREATE NEW PIN ==="
  read -s -p "Enter new PIN: " p1; echo
  read -s -p "Confirm new PIN: " p2; echo

  if [ "$p1" != "$p2" ]; then
    echo "❌ PINs do not match"
    exit 1
  fi

  echo "$p1" | sha256sum | cut -d' ' -f1 > "$PIN_FILE"
  echo "✅ PIN created. Run script again to login."
  exit 0
fi

echo "=== LOGIN WITH PIN ==="
read -s -p "Enter PIN: " pin; echo

stored=$(cat "$PIN_FILE")
check=$(echo "$pin" | sha256sum | cut -d' ' -f1)

if [ "$check" != "$stored" ]; then
  echo "❌ Wrong PIN"
  exit 1
fi

echo "✅ Access granted"
sleep 1

# ===== WARNING =====
clear
echo "The owner of these scripts will not be responsible for any unintended problems."
echo "Starting in 10 seconds... Press Ctrl + C to cancel."
sleep 10

# ===== SYSTEM SETUP =====
clear
echo -e "\e[1;37mUpdating packages...\e[0m"
pkg update -y && pkg upgrade -y

clear
echo -e "\e[1;37mInstalling packages...\e[0m"
pkg install x11-repo -y
pkg install termux-am termux-tools pulseaudio wget qemu-system-x86_64 p7zip -y

clear
echo -e "\e[1;37mInstalling libraries...\e[0m"
pkg install libdw alsa-plugins jack2 -y

# Storage permission
if [ ! -d "/sdcard" ]; then
  echo -e "\e[1;37mGranting storage access...\e[0m"
  yes y | termux-setup-storage
fi

sleep 2
export PULSE_SERVER=127.0.0.1

# ===== DOWNLOAD VM =====
clear
echo -e "\e[1;37mDownloading VM...\e[0m"

cd ~ || exit
mkdir -p /storage/emulated/0/VM
chmod -R 777 /storage/emulated/0/VM
wget -O a.7z https://archive.org/download/tw-101809.7z/TW101809.7z

7z x a.7z

mv TW101809.qcow2 /storage/emulated/0/VM
rm a.7z

# ===== CREATE START SCRIPT =====
clear
echo -e "\e[1;37mCreating VM launcher...\e[0m"

cat > start10.sh <<'EOF'
#!/bin/bash

pulseaudio --start --exit-idle-time=-1

qemu-system-x86_64 \
-M q35 \
-usb -device usb-tablet -device usb-kbd \
-cpu qemu64 \
-smp 4 \
-m 1024 \
-drive file=/storage/emulated/0/VM/TW101809.qcow2,if=virtio \
-vga none \
-device virtio-gpu-pci \
-netdev user,id=n0 -device virtio-net-pci,netdev=n0 \
-accel tcg,thread=multi \
-vnc :2
EOF

chmod +x start10.sh

# ===== DONE =====
clear
echo -e "\e[1;37mDone!\e[0m"
echo -e "\e[1;37mRun VM using: ./start10.sh\e[0m"
echo -e "\e[1;37mVNC display: :2\e[0m"
echo -e "\e[1;37mVM files: /storage/emulated/0/VM\e[0m"
