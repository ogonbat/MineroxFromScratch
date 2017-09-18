function toolchain(){
    ./configure --prefix=/tools
    make
    make install
}
function basesystem(){
    sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in

    ./configure --prefix=/usr --localstatedir=/var/lib/locate
    make
    make install
    mv -v /usr/bin/find /bin
    sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
}