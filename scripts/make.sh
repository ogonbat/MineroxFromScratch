function toolchain(){
    ./configure --prefix=/tools --without-guile
    make
    make install
}