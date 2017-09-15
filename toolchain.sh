#!/usr/bin/env bash
function ctrl_c() {
    # remove folder
    rm -Rf /mnt/lfs
    rm -Rf /tools
    echo "** Trapped CTRL-C"
}
trap ctrl_c INT

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  rm -Rf /mnt/lfs
  rm -Rf /tools

  exit "${code}"
}
trap 'error ${LINENO}' ERR

function DOWNLOAD() {
    # check if the base folder source exist
    local temporary_folder=/tmp/mx_sources
    if [ ! -d "$temporary_folder" ]; then
        mkdir -v $temporary_folder
    fi
    #check if is empty
    if [ "$(ls -A $temporary_folder)" ]; then
        cp "$temporary_folder"/* "$1"
    else
        # download all the files
        wget --input-file=wget-list --continue --directory-prefix="$temporary_folder"
        cp "$temporary_folder"/* "$1"
        pushd "$1"
            md5sum -c md5sums
        popd
    fi

}
function CHECKTAR() {
    for entry in "$LFS"/sources/"$1"*.tar.*; do
        echo $entry
    done
    return 0
}

function GETDIR() {

    for entry in $LFS/sources/*; do
        if [ -d "$entry" ]; then
            echo $entry
        fi
    done
    return 0
}

function UNTAR() {
    tar -xf $1 -C $2
}

function BUILD(){
    local step_two=0
    local command_string=$1

    #check if the command string have a step or not
    if [[ $command_string==*"_2"* ]]; then
        local step_two=1
        local command_string=${command_string%"_2"}
    else
        local step_two=0
    fi
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
        UNTAR $filename $LFS/sources
        #get the only existent directory in source
        local directory=$( GETDIR )
        cp ./scripts/"$command_string".sh $directory
        # move to the directory correspondant
        if [ $directory ]; then
            pushd $directory
                #copy the installer into the directory
                source "$command_string".sh
                if [$step_two]; then
                    toolchain_step_two
                else
                    toolchain
                fi
            popd
            rm -Rf $directory
        fi
    else
        exit 0
    fi
}

#generate the folders
mkdir /mnt/lfs
export LFS=/mnt/lfs
mkdir $LFS/sources
chmod a+wt $LFS/sources

# set folder tools
mkdir -v $LFS/tools
ln -sv $LFS/tools /

# set variables to export
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:$PATH
MAKEFLAGS='-j 4'
export LC_ALL LFS_TGT PATH MAKEFLAGS

DOWNLOAD "$LFS"/sources

BUILD binutils
BUILD gcc
BUILD linux
BUILD glibc
BUILD libstdc gcc
BUILD binutils_2
BUILD gcc_2
BUILD tcl
BUILD expect
BUILD dejagnu
BUILD check
BUILD ncurses
BUILD bash
BUILD bison
BUILD bzip
BUILD coreutils
BUILD diffutils
BUILD file
BUILD findutils
BUILD gawk
BUILD gettext
BUILD grep
BUILD gzip
BUILD m4
BUILD make
BUILD patch
BUILD perl
BUILD sed
BUILD tar
BUILD texinfo
BUILD util-linux
BUILD xz

rm -rf /tools/{,share}/{info,man,doc}

mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi