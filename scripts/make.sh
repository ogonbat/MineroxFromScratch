function toolchain(){
    ./configure --prefix=/tools --without-guile
    make
    make install
}
function basesystem(){
    ./configure --prefix=/usr
    make
    make install
}