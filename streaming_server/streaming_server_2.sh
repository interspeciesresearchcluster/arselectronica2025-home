#!/bin/bash

#STREAMING SERVER 1: AUDIO ONLY

ffmpeg \
    -loglevel debug \
    `#AUDIO INPUT` \
    `#-an`  `# dont use audio` \
    -thread_queue_size 1024 `#buffer size for packets waiting to be encoded (seems must be defined twice?)` \
    -f alsa `#use alsa` \
    -ac 2 `#num of audio channels` \
    -ar 44100 `#audio sample rate` \
    -acodec pcm_s32le `#set audio codec/format` \
    -i hw:2,0 `#audio input device` \
    `#VIDEO INPUT` \
    -vn \
    `#TRANSCODING VIDEO` \
    `#TRANSMITTING` \
    -f mpegts - `# output format: mpeg transport stream` \
    | nc -l -p 9000 `#send output over tcp`;