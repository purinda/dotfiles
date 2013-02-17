#!/bin/bash
# Purpose of this script is to support other scripts by providing 
# set of generic functions to perform certain tasks. 
#
# Each task has to be written as functions and a description must be 
# written on top.


# This function can write to a log file with the TIMESTAMP prepended 
# with each status message.
# $1 has to be the message need to be logged
# $2 the file to be appended.
# $3 has to be the severity of the message, it accept any string but
# puts in between [].
log() {
    
    if [ -z $3 ]
    then
        SEVERITY="INFO"
    else
        SEVERITY=$3
    fi
    
    echo `date "+[$SEVERITY] %d/%m/%Y %H:%M:%S: $1"` >> $2
}
