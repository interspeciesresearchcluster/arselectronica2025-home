#!/bin/bash

ffmpeg \
    `#AUDIO INPUT` \
    `#-an`  `# dont use audio` \
    -f alsa `#use alsa` \
    -acodec pcm_s32le `#set audio codec/format` \
    -ac 2 `#num of audio channels` \
    -ar 44100 `#audio sample rate` \
    -i hw:1,0 `#audio input device` \
    -thread_queue_size 1024 `#buffer for audio input... most people use 1024` \
    `#TRANSCODING AUDIO` \
    `#VIDEO INPUT` \
    -r 30  `#input framerate` \
    -f v4l2  `#use video4linux2` \
    -s 1920x1080  `#input resolution` \
    -i /dev/video2  `#input device` \
    -input_format yuyv422  `#input format` \
    -r 30  `# output framerate` \
    `#TRANSCODING VIDEO` \
    -c:v mpeg2video  `#use mpeg2video encoder` \
    -qscale:v 8  `#quality scale between around 2 and 30` \
    `#TRANSMITTING` \
    -f mpegts - `# output format: mpeg transport stream` \
    | nc -l -p 9000 `#send output over tcp` \