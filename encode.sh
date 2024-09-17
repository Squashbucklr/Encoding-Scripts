#!/bin/bash

# $1 path
# $2 save name

start=`date +%s`

if [[ ! -f "./.encode_options" ]]; then
    echo "Error: encode settings not present"
    exit 1
fi

{ read subs; read surround; read audio; read crf; read sopts; read aopts; read other; read preset; read rsync;} < ./.encode_options

echo "======================================"
echo "Encoding $2 [`date`]"
echo ""
echo "using subs: \"$subs\", crf: \"$crf\", sopts: \"$sopts\", audio options: \"$aopts\""

if [[ $rsync = "no" ]]; then
    ln "$1" sym-$2.mkv
    inpv="sym-$2.mkv"
    outv="$2"
else
    echo
    rsync -L --progress "$1" "$rsync/sym-$2.mkv"
    inpv="$rsync/sym-$2.mkv"
    outv="$rsync/$2"
fi

if [[ $subs = "yes" ]]; then
	echo "Generating subs..."
	ffmpeg -v panic -nostats -i "$inpv" -map `echo "$sopts"` -c:s copy encode-subs-$2.ass

	if [[ $? -ne 0 ]]; then
		echo "##################################"
		echo "FAILED TO CREATE SUBTITLES FOR $2"
		echo "##################################"
		exit 1
	fi

	vpart=(-map 0:v -vf "subtitles=encode-subs-$2.ass")
elif [[ $subs = "picture" ]]; then
	vpart=(-filter_complex "[0:v][`echo "$sopts"`]overlay[vands]" -map "[vands]")
elif [[ $subs = "no" ]]; then
	vpart=(-map 0:v)
elif [[ $subs = "folder" ]]; then
    vpart=(-map 0:v:0 -vf "subtitles=subs/$2.mkv:si=${sopts}")
elif [[ $subs = "file" ]]; then
    vpart=(-map 0:v:0 -vf "subtitles=${sopts}")
else # = si
	vpart=(-map 0:v:0 -vf "subtitles=$inpv:si=${sopts}")
fi

if [[ $surround = "5.1" ]]; then
    echo "Using 5.1 Downmixer"
	afilter=(-af "volume=1.660156,pan=stereo|FL=0.5*FC+0.707*FL+0.707*BL+0.5*LFE|FR=0.5*FC+0.707*FR+0.707*BR+0.5*LFE" -strict 2)
elif [[ $surround = "6.1" ]]; then
    echo "Using 6.1 Downmixer"
	afilter=(-af "volume=1.660156,pan=stereo|FL=0.5*FC+0.5*BC+0.707*FL+0.707*BL+0.5*LFE|FR=0.5*FC+0.5*BC+0.707*FR+0.707*BR+0.5*LFE" -strict 2)
elif [[ $surround = "2.1" ]]; then
    echo "Using 2.1 Downmixer"
	afilter=(-af "pan=stereo|FL=1*FL+0.5*LFE|FR=1*FR+0.5*LFE" -strict 2)
else
	afilter=()
fi

if [[ $audio = "current" ]]; then
    apart=(-map `echo "$aopts"`)
else # = folder
    apart=(-i audio/$2.mkv -map `echo "$aopts"`)
fi

if [[ $other = "VP9" ]]; then
    vcodecs=(-c:v libvpx-vp9 -deadline best -row-mt 1)
    acodecs=(-c:a libopus -b:a 160k)
    output=".webm"
    twopass="false"
elif [[ $other = "2pass-VP9" ]]; then
    vcodecs=(-c:v libvpx-vp9 -deadline best -row-mt 1)
    acodecs=(-c:a libopus -b:a 160k)
    output=".webm"
    twopass="true"
elif [[ $other = "nvenc" ]]; then
    vcodecs=(-c:v h264_nvenc -tune hq -pix_fmt yuv420p -cq `echo "$crf"` -preset $preset -maxrate 8M -bufsize 16M)
    acodecs=(-c:a aac -b:a 160k)
    output=".mp4"
    twopass="false"
else
    vcodecs=(-c:v libx264 -tune animation -pix_fmt yuv420p -crf `echo "$crf"` -aq-mode 3 -vsync 2 -preset $preset -maxrate 8M -bufsize 16M)
    acodecs=(-c:a aac -b:a 160k)
    output=".mp4"
    twopass="false"
fi

# test ios encode (worked once, not anymore?)
# ffmpeg -stats -i "$1" "${vpart[@]}" -map `echo "$aopts"` -c:v libx264 -coder 1 -pix_fmt yuv420p -profile:v high -level 4.2 -preset:v veryslow -tune animation -bf 3 -b_strategy 2 -g 100 -refs 10 -c:a aac -crf `echo "$crf"` -aq-mode 3 -t 30 $2.mov
# -qcomp 0.7

# MASTER ENCODING COMMAND
fcom=(nice -n15 ffmpeg -n -v warning -stats -i "$inpv")
vcom=("${vpart[@]}" "${vcodecs[@]}")
acom=("${apart[@]}" "${afilter[@]}" "${acodecs[@]}")


t=()
# comment this
# t=(-ss 00:30:00 -to 00:30:00)
# t=(-ss 00:30:00)


echo "Encoding video..."
if [[ $twopass = "true" ]]; then
    "${fcom[@]}" "${vcom[@]}" "${t[@]}" -pass 1 -an -f null /dev/null && \
    "${fcom[@]}" "${vcom[@]}" "${acom[@]}" "${t[@]}" -pass 2 $outv$output
else
    "${fcom[@]}" "${vcom[@]}" "${acom[@]}" "${t[@]}" $outv$output
fi

if [[ $? -ne 0 ]]; then
	echo "##############################"
	echo "FAILED TO ENCODE VIDEO FOR $2"
	echo "##############################"
	exit 1
fi

rm $inpv
if [[ $rsync = "no" ]]; then
    echo skip > /dev/null
else
    echo
    rsync --progress --remove-source-files "$outv$output" "$2$output"
fi

if [[ $subs = "yes" ]]; then
	rm encode-subs-$2.ass
fi

end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))

echo "Finished in $hours hours, $minutes minutes, $seconds seconds"
echo "======================================"
