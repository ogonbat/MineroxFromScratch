function toolchain(){
    ./configure --prefix=/tools
    make
    make install
}
function basesystem(){
    ./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4
    make
    make install
}