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
        wget --input-file=wget-list --continue --directory-prefix="$temporary_folder" 2> /dev/stderr
        cp "$temporary_folder"/* "$1"
        cp md5sums "$1"
        pushd "$1"
            md5sum -c md5sums 2> /dev/stderr
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
    local command_string=$1

    #check if the command string have a step or not
    if [[ $command_string == *_2 ]]
    then
        local step_two=0
        local command_string=${command_string%"_2"}
    else

        local step_two=1
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
        cp -v ./scripts/"$command_string".sh $directory
        # move to the directory correspondant
        if [ $directory ]; then
            pushd $directory
                #copy the installer into the directory
                source "$command_string".sh
                if [[ $step_two == 0 ]]
                then
                    echo "paso dos"
                    toolchain_step_two 2> /dev/stderr
                else
                    toolchain 2> /dev/stderr
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

if [ "$(ls -A ./sources)" ]; then
   cp ./sources/* "$LFS"/sources
else
   DOWNLOAD "$LFS"/sources
fi

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

#strip --strip-debug /tools/lib/*
#/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
rm -rf /tools/{,share}/{info,man,doc}

mkdir -pv $LFS/{dev,proc,sys,run}