function toolchain(){
    mkdir -v build
    cd       build
    ../configure --prefix=/tools            \
             --with-sysroot=$LFS        \
             --with-lib-path=/tools/lib \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror
    make

    case $(uname -m) in
        x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
    esac

    make install

}

function toolchain_step_two(){
    mkdir -v build
    cd       build
    CC=$LFS_TGT-gcc                \
    AR=$LFS_TGT-ar                 \
    RANLIB=$LFS_TGT-ranlib         \
    ../configure                   \
        --prefix=/tools            \
        --disable-nls              \
        --disable-werror           \
        --with-lib-path=/tools/lib \
        --with-sysroot
    make

    make install

    make -C ld clean
    make -C ld LIB_PATH=/usr/lib:/lib
    cp -v ld/ld-new /tools/bin

}