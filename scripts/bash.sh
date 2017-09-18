function toolchain(){
    ./configure --prefix=/tools --without-bash-malloc
    make
    make install
    ln -sv bash /tools/bin/sh
}
function basesystem(){
    patch -Np1 -i ../bash-4.4-upstream_fixes-1.patch
    ./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/bash-4.4 \
            --without-bash-malloc               \
            --with-installed-readline
    make
    chown -Rv nobody .
    make install
    mv -vf /usr/bin/bash /bin


}