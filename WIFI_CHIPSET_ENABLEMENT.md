1. Hardware Overview
Device: TP-Link TL-WN823N (USB Wi-Fi Adapter)

Chipset: Realtek RTL8192EU

Host Platform: STM32MP157D-DK1 Discovery Board

Operating System: OpenSTLinux (Yocto Project based)

2. The Identification Phase
Initially, the device was plugged into the USB port but did not create a network interface (wlan0).

Command: lsusb

Result: The device was detected with ID 2357:0109, confirming the RTL8192EU chipset.

Symptom: dmesg showed the USB device connection, but no driver was binding to it, and ifconfig -a showed no wireless interface.

3. Kernel Driver Configuration
The kernel needed the rtl8xxxu driver enabled, which supports various Realtek USB chips.

Tool: bitbake -c menuconfig virtual/kernel

Path: * Device Drivers -> Network device support -> Wireless LAN -> Realtek devices

Selected Options:

Realtek 802.11n USB wireless chip support (CONFIG_RTL8XXXU)

Include support for RTL8192EU (CONFIG_RTL8XXXU_8192EU)

4. Firmware Integration (The Blocker)
Even with the driver, the device failed to initialize with the error: rtl8xxxu: Loading firmware rtlwifi/rtl8192eu_nic.bin failed with error -2

Resolution:

Acquired Firmware: Downloaded rtl8192eu_nic.bin from the official Linux-firmware upstream repository.

Yocto Layer Modification: Created a .bbappend for the firmware recipe to inject the missing binary into the build.

File Path: layers/meta-st/meta-st-openstlinux/recipes-kernel/linux-firmware/linux-firmware_%.bbappend

Content:

Đoạn mã
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add the file to the source list so Yocto knows to pick it up from 'files'
SRC_URI += "file://rtlwifi/rtl8192eu_nic.bin"

do_install:append() {
    # Create the directory in the target image if it doesn't exist
    install -d ${D}${nonarch_base_libdir}/firmware/rtlwifi

    # Copy the file from the build directory to the image directory
    install -m 0644 ${WORKDIR}/rtlwifi/rtl8192eu_nic.bin ${D}${nonarch_base_libdir}/firmware/rtlwifi/
}

# Assign the new file to the existing rtl8192cu package so it gets installed
FILES:${PN}-rtl8192cu += "${nonarch_base_libdir}/firmware/rtlwifi/rtl8192eu_nic.bin"
5. Software Configuration & Handshake
Once the driver and firmware were matched, the interface appeared as wlu1u3.

Supplicant: Used wpa_supplicant with a custom configuration file in /etc/wpa_supplicant.conf.

Command: wpa_supplicant -B -i wlu1u3 -c /etc/wpa_supplicant.conf

IP Acquisition: udhcpc -i wlu1u3

6. Final Verification
Interface Name: wlu1u3 (Aliased as wlan0)

IP Assigned: 192.168.100.12

Driver in Use: rtl8xxxu

Connectivity: Successful ping to gateway and external DNS (8.8.8.8).

📶 Networking Guide
Once the board is flashed and booted, use the following sequence to connect to Wi-Fi:

Configure Credentials: Edit /etc/wpa_supplicant.conf:

Plaintext
network={
    ssid="Your_SSID"
    psk="Your_Password"
}
Initialize Connection:

Bash
wpa_supplicant -B -i wlu1u3 -c /etc/wpa_supplicant.conf
udhcpc -i wlu1u3
Verify IP:

Bash
ip addr show wlu1u3


.
├── conf/
│   ├── local.conf              # Project-specific settings
│   └── bblayers.conf           # Layer paths
├── recipes-kernel/
│   └── linux-firmware/         # Contains the bbappend and .bin firmware
├── WIFI_CHIPSET_ENABLEMENT.md  # Detailed hardware driver report
└── README.md                   # This file
