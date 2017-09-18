function toolchain(){
    ./configure --prefix=/tools
    make
    make install
}
function basesystem(){
    ./configure --prefix=/usr
    make
    make install
    mkdir -v /usr/share/doc/gawk-4.1.4
    cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.4
}