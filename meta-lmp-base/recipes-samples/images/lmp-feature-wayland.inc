# Wayland packages
CORE_IMAGE_BASE_INSTALL += " \
    psplash \
    weston \
    weston-init \
    wayland \
    ${@bb.utils.contains("DISTRO_FEATURES", "x11 wayland", "weston-xwayland", "", d)} \
"
IMAGE_FEATURES += '${@bb.utils.contains('DISTRO_FEATURES', 'wayland', ' weston', '', d)}'
