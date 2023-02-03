#!/bin/bash

subs_def="si"
surround_def="no"
audio_def="current"
crf_def="19"
sopts_si_def="0" # when subs=si
sopts_yes_def="0:s:m:language:eng" # when subs=yes
aopts_def="0:a:m:language:jpn"
other_def="H.264"
preset_def="slow"


if [[ $1 = "default" ]]; then
	subs=$subs_def
	surround=$surround_def
	audio=$audio_def
	crf=$crf_def
	sopts=$sopts_si_def
	aopts=$aopts_def
	other=$other_def
	preset=$preset_def
elif [[ $1 == "read" ]]; then
    if [[ -f "./.encode_options" ]]; then
	    cat .encode_options
    else
        echo No encode settings found!
    fi
	exit 0
else
	echo "Set subtitle mode [si, yes, picture, no, folder, file] (si)"
	read subs
	subs_file=subs_file_def
	if [[ $subs = "" ]]; then
		subs=$subs_def
	fi
	echo "Set audio mode [current, folder] (current)"
	read audio
	if [[ $audio = "" ]]; then
		audio=$audio_def
	fi
	echo "Set surround mode [5.1, 6.1, no] (no)"
	read surround
	if [[ $surround = "" ]]; then
		surround=$surround_def
	fi
	echo "Set crf value [0 - 51] (19)"
	read crf
	if [[ $crf = "" ]]; then
		crf=$crf_def
	fi
	if [[ $subs = "yes" ]] || [[ $subs = "picture" ]]; then
		echo "Set subtitle map options (0:s:m:language:eng)"
		read sopts
		if [[ $sopts = "" ]]; then
			sopts=$sopts_yes_def
		fi
	elif [[ $subs = "si" ]] || [[ $subs = "folder" ]]; then
		echo "Set subtitle si options (0)"
		read sopts
		if [[ $sopts = "" ]]; then
			sopts=$sopts_si_def
		fi
	else
            sopts="sopts unused"
	fi
	echo "Set audio map options (0:a:m:language:jpn)"
	read aopts
	if [[ $aopts = "" ]]; then
		aopts=$aopts_def
	fi
	echo "Set other options (video encoder) [H.264, VP9, 2pass-VP9] (H.264)"
	read other
	if [[ $other = "" ]]; then
		other=$other_def
	fi
	if [[ $other = "H.264" ]]; then
		echo "Set H.264 profile (slow)"
		read preset
		if [[ $preset = "" ]]; then
			preset=$preset_def
		fi
    else
        preset=$preset_def
	fi
fi

cat > ./.encode_options<< EOF
$subs
$surround
$audio
$crf
$sopts
$aopts
$other
$preset
EOF

echo "set!"
