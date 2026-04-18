#!/bin/bash

export HOME="/data/data/com.termux/files/home"

cd ~/base_arm64/khanh 2>/dev/null || {
  echo "Directory not found!"
  exit 1
}

echo "VNC Server: 127.0.0.1:5901"

qemu-system-aarch64 \
  -M virt \
  -cpu cortex-a53 \
  -smp 4 \
  --accel tcg,thread=multi \
  -m 1024 \
  -bios BIOS.img \
  -device VGA \
  -device nec-usb-xhci \
  -device usb-kbd \
  -device usb-mouse \
  -device usb-storage,drive=boot \
  -drive if=none,id=boot,file="base_arm64.qcow2" \
  -vnc :1
