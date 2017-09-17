function toolchain(){
    FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools
    FORCE_UNSAFE_CONFIGURE=1 make
    make install
}