FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# RPI: 7-Inch display support
SRC_URI_append_rpi = " \
    file://0001-FIO-extras-drm-panel-rpi-add-lcd-rotate-property.patch \
"

# OP-TEE generic, but for now only applied on mx8mm
SRC_URI_append_mx8mm = " \
    file://0001-FIO-fromlist-drivers-optee-allow-op-tee-to-access-de.patch \
    file://0002-FIO-fromtree-hwrng-optee-handle-unlimited-data-rates.patch \
    file://0003-FIO-fromtree-hwrng-optee-fix-wait-use-case.patch \
    file://0004-FIO-toup-hwrng-optee-support-generic-crypto.patch \
"

# Apalis iMX8
LINUX_VERSION_apalis-imx8 ?= "4.14.y"
KERNEL_REPO_apalis-imx8 ?= "git://git.toradex.com/linux-toradex.git"
KERNEL_BRANCH_apalis-imx8 ?= "toradex_4.14-2.3.x-imx"
KERNEL_COMMIT_apalis-imx8 ?= "b63b688c85addc632dd249a01834cdcc799e8f17"
LIC_FILES_CHKSUM_apalis-imx8 = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"
SRC_URI_append_apalis-imx8 = " \
    file://defconfig \
"