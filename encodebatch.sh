#!/bin/bash

prefix=$1
charperep=$2
postfix=$3
outprefix=$4
min=$5
max=$6
between=$7

for (( i=$min; i<=$max; i++ )) 
do
	ep=$i
	while [[ ${#ep} -lt $charperep ]]
	do
		ep="0${ep}"
	done
    if [[ "$between" = "BETWEEN" ]]; then
	    encode "`ls *"${prefix}${ep}${postfix}"*`" "${outprefix}${i}"
    else
	    encode "`ls *"${prefix}"*"${ep}"*"${postfix}"*`" "${outprefix}${i}"
    fi
done
