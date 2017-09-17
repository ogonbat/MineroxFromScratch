function toolchain(){
    FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools --enable-install-program=hostname
    FORCE_UNSAFE_CONFIGURE=1 make
    make install
}