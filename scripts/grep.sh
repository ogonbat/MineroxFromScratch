function toolchain(){
    ./configure --prefix=/tools
    make
    make install
}
function basesystem(){
    ./configure --prefix=/usr --bindir=/bin
    make
    make install
}