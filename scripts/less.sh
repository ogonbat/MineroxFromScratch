function basesystem(){
    ./configure --prefix=/usr --sysconfdir=/etc
    make
    make install
}