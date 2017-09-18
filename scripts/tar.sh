function toolchain(){
    FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools
    FORCE_UNSAFE_CONFIGURE=1 make
    make install
}
function basesystem(){
    FORCE_UNSAFE_CONFIGURE=1  \
    ./configure --prefix=/usr \
            --bindir=/bin
    make
    make install
    make -C doc install-html docdir=/usr/share/doc/tar-1.29
}