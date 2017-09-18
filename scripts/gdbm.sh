function basesystem(){
    ./configure --prefix=/usr \
            --disable-static \
            --enable-libgdbm-compat
    make
    make install
}