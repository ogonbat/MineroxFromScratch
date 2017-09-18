function GETDIR() {

    for entry in /sources/*; do
        if [ -d "$entry" ]; then
            echo $entry
        fi
    done
    return 0
}
function CHECKTAR() {
    for entry in /sources/"$1"*.tar.*; do
        echo $entry
    done
    return 0
}
function UNTAR() {
    tar -xf $1 -C $2
}

function BUILD(){
    local command_string=$1

    if [ $2 ]; then
        # the command correspond a package different to the command executer
        local filename=$( CHECKTAR $2 )
    else
        # check if exist in source folder the tar file
        local filename=$( CHECKTAR $command_string )
    fi


    # untar into sources
    if [ -f $filename ]; then
        # the file exist so untar it
        UNTAR $filename /sources
        #get the only existent directory in source
        local directory=$( GETDIR )
        # move to the directory correspondant
        if [ $directory ]; then
            cp -v /scripts/"$command_string".sh $directory
            pushd $directory
                #copy the installer into the directory
                source "$command_string".sh
                basesystem
            popd
            rm -Rf $directory

        fi
    else
        exit 0
    fi
}

mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v  /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}

case $(uname -m) in
 x86_64) mkdir -v /lib64 ;;
esac

mkdir -v /var/{log,mail,spool}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}

ln -sv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin
ln -sv /tools/bin/{install,perl} /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib
sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
ln -sv bash /bin/sh

ln -sv /proc/self/mounts /etc/mtab

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
nogroup:x:99:
users:x:999:
EOF

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

BUILD linux
BUILD man-pages
BUILD glibc

# adjust the toolchain
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

grep -B1 '^ /usr/include' dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib.*/libc.so.6 " dummy.log

grep found dummy.log

rm -v dummy.c a.out dummy.log

BUILD zlib
BUILD file
BUILD readline
BUILD m4
BUILD bc
BUILD binutils
BUILD gmp
BUILD mpfr
BUILD mpc
BUILD gcc
BUILD bzip
BUILD pkg-config
BUILD ncurses
BUILD attr
BUILD acl
BUILD libcap
BUILD sed
BUILD shadow
BUILD psmisc
BUILD iana-etc
BUILD bison
BUILD flex
BUILD grep
BUILD bash
BUILD libtool
BUILD gdbm
BUILD gperf
BUILD expat
BUILD inetutils
BUILD perl
BUILD XML-Parser
BUILD intltool
BUILD autoconf
BUILD automake
BUILD xz
BUILD kmod
BUILD gettext
BUILD procps
BUILD e2fsprogs
BUILD coreutils
BUILD diffutils
BUILD gawk
BUILD findutils
BUILD groff
BUILD grub
BUILD less
BUILD gzip
BUILD iproute
BUILD kbd
BUILD libpipeline
BUILD make
BUILD patch
BUILD sysklogd
BUILD sysvinit
BUILD eudev
BUILD util-linux
BUILD man-db
BUILD tar
BUILD texinfo
BUILD vim

save_lib="ld-2.26.so libc-2.26.so libpthread-2.26.so libthread_db-1.0.so"

cd /lib

for LIB in $save_lib; do
    objcopy --only-keep-debug $LIB $LIB.dbg
    strip --strip-unneeded $LIB
    objcopy --add-gnu-debuglink=$LIB.dbg $LIB
done

save_usrlib="libquadmath.so.0.0.0 libstdc++.so.6.0.24
             libmpx.so.2.0.1 libmpxwrappers.so.2.0.1 libitm.so.1.0.0
             libcilkrts.so.5.0.0 libatomic.so.1.2.0"

cd /usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug $LIB $LIB.dbg
    strip --strip-unneeded $LIB
    objcopy --add-gnu-debuglink=$LIB.dbg $LIB
done

unset LIB save_lib save_usrlib