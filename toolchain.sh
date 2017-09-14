#!/usr/bin/env bash


#generate the folders
mkdir /mnt
mkdir /mnt/lfs
export LFS=/mnt/lfs
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

#download the list of files
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources

cp md5sums $LFS/sources

#move to sources folder and do the check
pushd $LFS/sources
md5sum -c md5sums
popd

# set folder tools
mkdir -v $LFS/tools
ln -sv $LFS/tools /

# set variables to export
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export LC_ALL LFS_TGT PATH

#number of processors to use
export MAKEFLAGS='-j 2'

function check_is_tar() {
    for entry in "$LFS"/sources/"$1"*
    do
        return $entry
    done
    return 0
}

function get_directory() {

    for entry in "$LFS"/sources
    do
        if [ -d "$entry" ]
        then
            return $entry
        fi
    done
}

function untar() {
    tar -zf $1 -C $2
}

function BUILD(){
    # check if exist in a folder
    filename=check_is_tar $1

    # untar into sources
    if $filename
    then
        # the file exist so untar it
        untar $LFS/sources/$filename $LFS/sources
    fi

    directory=get_directory

    # move to the directory correspondant
    pushd $LFS/sources/directory
    popd

}