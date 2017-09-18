function toolchain(){
    make mrproper

    make INSTALL_HDR_PATH=dest headers_install
    cp -rv dest/include/* /tools/include

}

function basesystem(){
    make mrproper
    make INSTALL_HDR_PATH=dest headers_install
    find dest/include \( -name .install -o -name ..install.cmd \) -delete
    cp -rv dest/include/* /usr/include
}