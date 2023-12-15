do_install[postfuncs] += "do_install_fix"
do_install_fix() {
    mv ${D}/usr ${D}/.usr
    rm -rf ${D}/*
    mv ${D}/.usr ${D}/usr
}
