#!/bin/bash

subs_def="0"
surround_def="no"
crf_def="20"
sopts_def="0:s:m:language:eng" # when subs=yes
aopts_def="0:a:m:language:jpn"
other_def="H.264"
preset_def="medium"


if [[ $1 = "default" ]]; then
	subs=$subs_def
	surround=$surround_def
	crf=$crf_def
	sopts=$sopts_def
	aopts=$aopts_def
	other=$other_def
	preset=$preset_def
elif [[ $1 == "read" ]]; then
	cat ~/Documents/scripts/data/encode_subs.txt
	cat ~/Documents/scripts/data/encode_surround.txt
	cat ~/Documents/scripts/data/encode_crf.txt
	cat ~/Documents/scripts/data/encode_sopts.txt
	cat ~/Documents/scripts/data/encode_aopts.txt
	cat ~/Documents/scripts/data/encode_other.txt
	cat ~/Documents/scripts/data/encode_preset.txt
	exit 0
else
	echo "Set subtitle mode [si, yes, picture, no, folder, file] (0 (si))"
	read subs
	subs_file=subs_file_def
	if [[ $subs = "" ]]; then
		subs=$subs_def
	fi
	echo "Set surround mode [5.1, 6.1, no] (no)"
	read surround
	if [[ $surround = "" ]]; then
		surround=$surround_def
	fi
	echo "Set crf value [0 - 51] (20)"
	read crf
	if [[ $crf = "" ]]; then
		crf=$crf_def
	fi
	if [[ $subs = "yes" ]] || [[ $subs = "picture" ]]; then
		echo "Set subtitle map options (0:s:m:language:eng)"
		read sopts
		if [[ $sopts = "" ]]; then
			sopts=$sopts_def
		fi
	else
            sopts=""
	fi
	echo "Set audio map options (0:a:m:language:jpn)"
	read aopts
	if [[ $aopts = "" ]]; then
		aopts=$aopts_def
	fi
	echo "Set audio map options [H.264, VP9, 2pass-VP9] (H.264)"
	read other
	if [[ $other = "" ]]; then
		other=$other_def
	fi
	if [[ $other = "H.264" ]]; then
		echo "Set H.264 profile (medium)"
		read preset
		if [[ $preset = "" ]]; then
			preset=$preset_def
		fi
    else
        preset=$preset_def
	fi
fi

echo $subs > ~/Documents/scripts/data/encode_subs.txt
echo $surround > ~/Documents/scripts/data/encode_surround.txt
echo $crf > ~/Documents/scripts/data/encode_crf.txt
echo $sopts > ~/Documents/scripts/data/encode_sopts.txt
echo $aopts > ~/Documents/scripts/data/encode_aopts.txt
echo $other > ~/Documents/scripts/data/encode_other.txt
echo $preset > ~/Documents/scripts/data/encode_preset.txt

# cat ~/Documents/ScriptData/encode_subs.txt
# cat ~/Documents/ScriptData/encode_crf.txt
# cat ~/Documents/ScriptData/encode_sopts.txt
# cat ~/Documents/ScriptData/encode_aopts.txt

echo "set!"
