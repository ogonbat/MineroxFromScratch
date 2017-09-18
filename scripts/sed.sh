function toolchain(){
    ./configure --prefix=/tools
    make
    make install
}
function basesystem(){
    sed -i 's/usr/tools/'                 build-aux/help2man
    sed -i 's/testsuite.panic-tests.sh//' Makefile.in
    ./configure --prefix=/usr --bindir=/bin
    make
    make html
    make install
    install -d -m755           /usr/share/doc/sed-4.4
    install -m644 doc/sed.html /usr/share/doc/sed-4.4
}