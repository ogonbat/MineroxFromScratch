#!/usr/bin/env bash
function ctrl_c() {
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
  exit "${code}"
}
trap 'error ${LINENO}' ERR

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
    step_two = 0
    command_string = $1
    #check if the command string have a step or not
    if [[ $command_string==*"_2"* ]]; then
        $step_two = 1
        command_string=${command_string%"_2"}
    fi
    # check if exist in source folder the tar file
    filename=check_is_tar $command_string

    # untar into sources
    if $filename
    then
        # the file exist so untar it
        untar $LFS/sources/$filename $LFS/sources
    fi

    #get the only existent directory in source
    directory=get_directory

    # move to the directory correspondant
    pushd $LFS/sources/$directory
        #copy the installer intpo the directory
        cp ./scripts/"$command_string" $LFS/sources/$directory

    popd
}