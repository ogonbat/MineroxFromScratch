function toolchain(){
    cd gettext-tools
    EMACS="no" ./configure --prefix=/tools --disable-shared

    make -C gnulib-lib
    make -C intl pluralx.c
    make -C src msgfmt
    make -C src msgmerge
    make -C src xgettext
    cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
}
function basesystem(){
    sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
    sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in
    ./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.19.8.1
    make
    make install
    chmod -v 0755 /usr/lib/preloadable_libintl.so
}