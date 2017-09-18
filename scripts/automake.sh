function basesystem(){
    ./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15.1
    make
    make install
}