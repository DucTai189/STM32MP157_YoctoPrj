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