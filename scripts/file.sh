function toolchain(){
    ./configure --prefix=/tools
    make
    make install
}
function basesystem(){
    ./configure --prefix=/usr
    make
    make install
}