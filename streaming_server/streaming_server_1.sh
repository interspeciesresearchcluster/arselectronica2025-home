#!/bin/bash

#STREAMING SERVER 1: VIDEO ONLY

ffmpeg \
    -loglevel debug \
    `#AUDIO INPUT` \
    -an  `# dont use audio` \
    `#LOW LATENCY VIDEO FLAGS` \
    `#-flags low_delay --- this creates pixelation for high resolutions` \
    -fflags nobuffer `#apparentlythis reduces latency a bit` \
    `#VIDEO INPUT` \
    -r 10  `#input framerate` \
    -f v4l2  `#use video4linux2` \
    -s 1280x720  `#input resolution` \
    -i /dev/video0  `#input device` \
    -input_format yuyv422  `#input format` \
    -r 10  `# output framerate` \
    `#TRANSCODING VIDEO` \
    -c:v mpeg2video  `#use mpeg2video encoder` \
    -qscale:v 3  `#quality scale between around 2 and 30` \
    `#TRANSMITTING` \
    -f mpegts - `# output format: mpeg transport stream` \
    | nc -l -p 19062 `#send output over tcp`;