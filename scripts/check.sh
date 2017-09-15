function toolchain(){
    PKG_CONFIG= ./configure --prefix=/tools
    make
    make install
}