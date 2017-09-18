function basesystem(){
    ./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-3.1.5
    make
    make html
    make install
    make install-html
    
}