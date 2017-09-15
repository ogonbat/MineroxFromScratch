function toolchain(){
    ./configure --prefix=/tools
    make
    make install
}