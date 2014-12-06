#!/usr/bin/env bash
 
d=$(date +%s)
remote=$1
dir="composer-$d.tmp"


if [ -f composer.json ]; then

    ssh $remote mkdir "$dir"
    scp composer.json $remote:"$dir"/composer.json

    if [ -f composer.lock ]; then
        scp composer.lock $remote:"$dir"/composer.lock
    fi

    ssh $remote "cd $dir ; php ../composer.phar install"
    ssh $remote tar cvzf vendor.tar.gz "$dir"
    scp $remote:vendor.tar.gz .
    tar xvpf vendor.tar.gz --strip 1
    rm vendor.tar.gz
    ssh $remote rm vendor.tar.gz
    ssh $remote rm -fr "$dir"

fi
