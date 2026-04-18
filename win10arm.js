const { spawn } = require("child_process");
const path = require("path");

// === export HOME ===
process.env.HOME = "/data/data/com.termux/files/home";

// === cd ~/base_arm64/khanh (silent like 2>/dev/null) ===
const targetDir = path.join(process.env.HOME, "base_arm64", "khanh");

try {
  process.chdir(targetDir);
} catch (e) {
  // silent ignore like "2>/dev/null"
}

// === VNC message ===
console.log("QEMU VNC Server running on 127.0.0.1:5901");

// === QEMU args ===
const args = [
  "-M", "virt",
  "-cpu", "cortex-a53",
  "-smp", "4",
  "--accel", "tcg,thread=multi",
  "-m", "1024",
  "-bios", "BIOS.img",
  "-device", "VGA",
  "-device", "nec-usb-xhci",
  "-device", "usb-kbd",
  "-device", "usb-mouse",
  "-device", "usb-storage,drive=boot",
  "-drive", "if=none,id=boot,file=base_arm64.qcow2",
  "-vnc", ":1"
];

// === Start VM ===
const vm = spawn("qemu-system-aarch64", args, {
  stdio: "inherit",
  shell: true
});

// === Status ===
vm.on("spawn", () => {
  console.log("[✔] QEMU VM started");
});

vm.on("error", (err) => {
  console.error("[✘] Failed to start VM:", err.message);
});

vm.on("close", (code) => {
  console.log("[!] VM exited with code:", code);
});
