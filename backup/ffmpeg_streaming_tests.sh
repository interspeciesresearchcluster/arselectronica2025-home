#!/bin/bash

ffmpeg \
    -loglevel debug \
    `#AUDIO INPUT` \
    -an  `# dont use audio` \
    `#LOW LATENCY FLAGS` \
    `#-flags low_delay --- this creates pixelation for high resolutions` \
    -fflags nobuffer `#apparently this reduces latency a bit` \
    `#VIDEO INPUT` \
    -r 30  `#input framerate` \
    -f v4l2  `#use video4linux2` \
    -s 1920x1080  `#input resolution` \
    -i /dev/video0  `#input device` \
    -input_format yuyv422  `#input format` \
    -r 30  `# output framerate` \
    `#TRANSCODING VIDEO` \
    -c:v mpeg2video  `#use mpeg2video encoder` \
    -qscale:v 20  `#quality scale between around 2 and 30` \
    `#TRANSMITTING` \
    -f mpegts - `# output format: mpeg transport stream` \
    | nc -l -p 19062 `#send output over tcp`;

# ffmpeg \
#     `#AUDIO INPUT` \
#     `#-an`  `# dont use audio` \
#     -thread_queue_size 1024 `#buffer size for packets waiting to be encoded (seems must be defined twice?)` \
#     -f alsa `#use alsa` \
#     -ac 2 `#num of audio channels` \
#     -ar 44100 `#audio sample rate` \
#     -acodec pcm_s32le `#set audio codec/format` \
#     -i hw:1,0 `#audio input device` \
#     `#TRANSCODING AUDIO` \
#     `#VIDEO INPUT` \
#     -thread_queue_size 1024 `#buffer size for packets waiting to be encoded (seems must be defined twice?)` \
#     -r 30  `#input framerate` \
#     -f v4l2  `#use video4linux2` \
#     -s 320x180  `#input resolution` \
#     -i /dev/video2  `#input device` \
#     -input_format yuyv422  `#input format` \
#     -r 30  `# output framerate` \
#     `#TRANSCODING VIDEO` \
#     -c:v mpeg2video  `#use mpeg2video encoder` \
#     -qscale:v 8  `#quality scale between around 2 and 30` \
#     `#TRANSMITTING` \
#     -f mpegts - `# output format: mpeg transport stream` \
#     | nc -l -p 9000 `#send output over tcp`;

# ffmpeg \
#     `#AUDIO INPUT` \
#     `#-an`  `# dont use audio` \
#     -thread_queue_size 1024 `#buffer size for packets waiting to be encoded (seems must be defined twice)` \
#     -f jack `#use jack` \
#     -i ffmpeg `#name of audio device in jack` \
#     `#TRANSCODING AUDIO` \
#     `#VIDEO INPUT` \
#     -thread_queue_size 1024 `#buffer size for packets waiting to be encoded (seems must be defined twice)` \
#     -r 30  `#input framerate` \
#     -f v4l2  `#use video4linux2` \
#     -s 320x180  `#input resolution` \
#     -i /dev/video2  `#input device` \
#     -input_format yuyv422  `#input format` \
#     -r 30  `# output framerate` \
#     `#TRANSCODING VIDEO` \
#     -c:v mpeg2video  `#use mpeg2video encoder` \
#     -qscale:v 8  `#quality scale between around 2 and 30` \
#     `#TRANSMITTING` \
#     -f mpegts - `# output format: mpeg transport stream` \
#     | nc -l -p 9000 `#send output over tcp`;