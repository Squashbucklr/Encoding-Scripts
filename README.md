# Encoding Scripts

These are a set of 3 scripts that I use on a regular basis in order to speed up
my efficiency encoding mkv files, usually anime, into mp4 with hard subs for use
on the web. There are 3 scripts

## encode.sh

The main encoding script. Takes 2 arguments: the input file, and the output file
name, sans the extension. For example, if you wanted to encode a file called
`test.mkv` into `test.mp4`, the comman would be `./encode.sh test.mkv test`.

## encodeset.sh

Sets parameters to be used by encode. Parameters are stored in
`~/Documents/scripts/data/`. At the moment this cannot be changed without
editing `encode.sh` and `encodebatch.sh`. There are a few options:

### Subtitle mode
Sets the method for which subtitles are processed
* si (grabs from the mkv itself. Specify by inputting a number, the index of the
  subtitles in the mkv). This is the most common option. 0 is the default for
  subtitle mode itself.
* yes (frankly I don't remember what this does).
* picture (encodes picture based subtitles).
* no (does not process any subtitles).
* folder (checks a folder called subs for files named like the output. Can be
  mkv files). Useful for when you have one release with subs and fonts and want
  to use the subs and fonts with a raw video from another release.
* file (no promise for this working).

### Surround mode
I'm not satisfied with ffmpeg's 5.1 downmixer, so I use a custom one that I
found on [this superuser post](https://superuser.com/questions/852400)
(Dave\_750's answer).
* 5.1 (enables the 5.1 downmixer). I use this any time there is 5.1 audio.
* 6.1 (enables the 6.1 downmixer). Don't trust this, I'm not sure it works.
* no (default, use ffmpeg's downmixer). I only use this for stereo.

### CRF value
Self explanatory. Default is 20.

### Audio map options
Select the option to come after a `-map` param, specifically for audio. Some
examples are `0:a:0` (first audio track) or `0:a:1` (second audio track)  or the
default `0:a:m:language:jpn` (first japanese audio track)

### Other parameter
This sets the encoding format used. I would not recomment using anything other
than H.264 as I don't have the equipment to test the others at the moment
* H.264 (default, single pass H.264 encoding, 8M maxrate, aac 160k audio)
* VP9 (single pass vp9 with the best quality)
* 2pass-VP9 (2-pass VP9 as above)

### H.264 profile
Set the profile. Default is medium

### Subtitle map options
Used if subtitle mode is yes, so not useful anymore. Same as audio map options
but for subtitles.

## encodebatch.sh

Encodes a batch of files. Takes multiple parameters:
* Prefix: prefix before the episode number (can be stuff between)
* Characters per number in the episode number (usually 2)
* Suffix: after the episode number (can be stuff between)
* Output prefix (before number)
* Start number
* End number
Example: Filename: `Example Show 03 (BD 1080p).mkv` Command:
`./encodeset.sh "Show" 2 "(BD " ep 1 12`

## Installation
Just put them in your bin folder. I drop the `.sh` ending. Also make sure the
folder for encodeset data is created or that you modified the scripts.
