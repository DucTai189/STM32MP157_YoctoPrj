# STM32MP1 Wi-Fi & Remote Development Environment
This repository provides a complete guide and metadata for enabling **RTL8192EU USB Wi-Fi** support on the STM32MP157D-DK1 Discovery Board.

## The Solution

### 1. Hardware Enablement (RTL8192EU)
Successfully enabled the **TP-Link TL-WN823N-V3** (USB ID `2357:0109`) which is not supported in the default OpenSTLinux kernel.
- **Driver:** `rtl8xxxu`
- **Firmware Integration:** Manual injection of `rtl8192eu_nic.bin` via custom Yocto layers.
## Setup & Rebuild Instructions
### Metadata Changes
Add the following to your `build/conf/local.conf`:
Build Command
   bitbake st-image-weston
📶 Network Configuration
Once booted, use the following commands on the board's serial console:
# Start Wi-Fi Handshake (Interface: wlu1u3)
wpa_supplicant -B -i wlu1u3 -c /etc/wpa_supplicant.conf

# Request IP via DHCP
udhcpc -i wlu1u3

# Verify Connection
ip addr show wlu1u3
📂 Repository Structure
  - conf/: Configuration files (local.conf, bblayers.conf).
  - recipes-kernel/: The linux-firmware bbappend and firmware blobs.
  - docs/: Detailed hardware enablement reports.

📜 Detailed Hardware Report
For a deep dive into the driver and firmware setup, see WIFI_CHIPSET_ENABLEMENT.md.
