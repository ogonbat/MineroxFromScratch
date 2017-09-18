function basesystem(){
    ./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2
    make
    make html
    make install
    make install-html

}