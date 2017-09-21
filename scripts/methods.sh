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