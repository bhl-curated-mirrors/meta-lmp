include kmeta-linux-lmp-6.1.y.inc

LINUX_VERSION ?= "6.1.67"
KBRANCH = "linux-v6.1.y-rt"
SRCREV_machine = "122ba20ca2498c89f9dfc4bc0c2bbdea09eac393"
SRCREV_meta = "${KERNEL_META_COMMIT}"
LINUX_KERNEL_TYPE = "preempt-rt"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI = "git://github.com/foundriesio/linux.git;protocol=https;branch=${KBRANCH};name=machine; \
    ${KERNEL_META_REPO};protocol=${KERNEL_META_REPO_PROTOCOL};type=kmeta;name=meta;branch=${KERNEL_META_BRANCH};destsuffix=${KMETA} \
"

KMETA = "kernel-meta"

require linux-lmp.inc
include recipes-kernel/linux/linux-lmp-machine-custom.inc
