FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESPATH:prepend := "/home/tainguyen/STM32MPU_workspace/build-openstlinuxweston-stm32mp1/workspace/sources/linux-stm32mp/oe-local-files:"
# srctreebase: /home/tainguyen/STM32MPU_workspace/build-openstlinuxweston-stm32mp1/workspace/sources/linux-stm32mp

inherit externalsrc
# NOTE: We use pn- overrides here to avoid affecting multiple variants in the case where the recipe uses BBCLASSEXTEND
EXTERNALSRC:pn-linux-stm32mp = "/home/tainguyen/STM32MPU_workspace/build-openstlinuxweston-stm32mp1/workspace/sources/linux-stm32mp"
SRCTREECOVEREDTASKS = "do_validate_branches do_kernel_checkout do_fetch do_unpack do_kernel_configcheck"

do_patch[noexec] = "1"

do_configure:append() {
    cp ${B}/.config ${S}/.config.baseline
    ln -sfT ${B}/.config ${S}/.config.new
}

do_kernel_configme:prepend() {
    if [ -e ${S}/.config ]; then
        mv ${S}/.config ${S}/.config.old
    fi
}

do_configure:append() {
    if [ ${@oe.types.boolean(d.getVar("KCONFIG_CONFIG_ENABLE_MENUCONFIG"))} = True ]; then
        cp ${KCONFIG_CONFIG_ROOTDIR}/.config ${S}/.config.baseline
        ln -sfT ${KCONFIG_CONFIG_ROOTDIR}/.config ${S}/.config.new
    fi
}

# initial_rev .: 1ee2443a1260916bebde1ee84f4f36a813b217fc
# commit .: 32cd005d3f33f994c268f76d50e1c922745868bd
# patches_devtool-override-aarch32: 
# patches_devtool-override-aarch64: 
# patches_devtool-override-arm: 
