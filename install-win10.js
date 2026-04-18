// install-win10.js
const { execSync } = require("child_process");

const run = (cmd) => {
  try {
    console.log(`\n>>> ${cmd}`);
    execSync(cmd, { stdio: "inherit" });
  } catch (err) {
    console.error(`\n[ERROR] Command failed: ${cmd}`);
    process.exit(1);
  }
};

const runSafe = (cmd) => {
  try {
    execSync(cmd, { stdio: "ignore" });
  } catch {}
};

console.clear();

// Colors
const red = "\x1b[1;31m";
const green = "\x1b[1;32m";
const yellow = "\x1b[1;33m";
const lightCyan = "\x1b[1;96m";
const reset = "\x1b[0m";

console.log(`${lightCyan}- Setting up environment...${reset}`);

// Setup directories
runSafe("mkdir -p /data/data/com.termux/files/home");
process.env.HOME = "/data/data/com.termux/files/home";

// Storage permission
runSafe(`echo "Y" | termux-setup-storage`);

// Change mirror
run(
  `echo "deb https://packages-cf.termux.dev/apt/termux-main stable main" > /data/data/com.termux/files/usr/etc/apt/sources.list`
);

// Update packages
run("pkg update -y && pkg upgrade -y");
run("pkg install p7zip wget tar qemu-system-aarch64-headless -y");

// Download files
console.clear();
console.log(`\n${lightCyan}- Downloading...${green}\n`);

run(
  `wget -O base_arm64-khanhnguyen.tar.7z.001 https://github.com/KhanhNguyen9872/Windows10ARM64/releases/download/Win10ARM64Base/base_arm64-khanhnguyen.tar.7z.001`
);

run(
  `wget -O base_arm64-khanhnguyen.tar.7z.002 https://github.com/KhanhNguyen9872/Windows10ARM64/releases/download/Win10ARM64Base/base_arm64-khanhnguyen.tar.7z.002`
);

run(
  `wget -O base_arm64-khanhnguyen.sha512sum https://github.com/KhanhNguyen9872/Windows10ARM64/releases/download/Win10ARM64Base/base_arm64-khanhnguyen.sha512sum`
);

// Extract
console.clear();
console.log(`\n${lightCyan}- Extracting...${green}\n`);

run("7z x base_arm64-khanhnguyen.tar.7z.001 -aoa");
runSafe("rm -rf base_arm64-khanhnguyen.tar.7z*");

// Verify
console.clear();
console.log(`\n${lightCyan}- Verifying...${green}\n`);

try {
  run("sha512sum -c base_arm64-khanhnguyen.sha512sum");
} catch {
  console.log(`${red}File corrupted. Please reinstall.${reset}`);
  runSafe("rm -f base_arm64-khanhnguyen.tar.xz");
  runSafe("rm -f win10");
  runSafe("rm -f base_arm64-khanhnguyen.sha512sum");
  process.exit(1);
}

// Install
console.log(`\n${lightCyan}- Installing...${green}\n`);

runSafe("rm -f base_arm64-khanhnguyen.sha512sum");

run("tar -xJf base_arm64-khanhnguyen.tar.xz");
runSafe("rm -f base_arm64-khanhnguyen.tar.xz");

// Download launcher
run(
  `wget -O win10arm.sh https://raw.githubusercontent.com/davidcurbet111111111/Hdhd/refs/heads/main/win10arm.sh`
);

// Configure
console.log(`\n${lightCyan}- Configuring...${green}\n`);

runSafe("mv win10arm.sh $PREFIX/bin/win10arm.sh");
runSafe("chmod 777 $PREFIX/bin/win10arm.sh");
runSafe("chmod 777 base_arm64");

// Check files
const fs = require("fs");

let success = false;

if (
  fs.existsSync("base_arm64/khanh/base_arm64.qcow2") &&
  fs.existsSync("base_arm64/khanh/BIOS.img") &&
  fs.existsSync("base_arm64/khanh/qemu.conf")
) {
  success = true;
}

// Cleanup
runSafe("rm -rf *.sh");

console.clear();

if (success) {
  console.log(`\n${yellow}- INSTALL COMPLETED!${reset}`);
  console.log(
    `${lightCyan}Run: bash $PREFIX/bin/win10arm.sh${reset}`
  );
  console.log(
    `${yellow}Use VNC Viewer → 127.0.0.1:5901${reset}`
  );
} else {
  console.log(`\n${red}- INSTALL FAILED!${reset}`);
  console.log(`${lightCyan}Please try again.${reset}`);
  runSafe("rm -f /data/data/com.termux/files/usr/bin/win10arm.sh");
  runSafe("rm -rf base_arm64");
  process.exit(1);
}
