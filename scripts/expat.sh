function basesystem(){
    sed -i 's|usr/bin/env |bin/|' run.sh.in
    ./configure --prefix=/usr --disable-static
    make
    make install
    install -v -dm755 /usr/share/doc/expat-2.2.3
    install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.3
}