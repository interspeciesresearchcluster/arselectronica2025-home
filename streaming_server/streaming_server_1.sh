#!/bin/bash

ffmpeg \
    -loglevel debug \
    `#AUDIO INPUT` \
    -an  `# dont use audio` \
    `#VIDEO INPUT` \
    -r 30  `#input framerate` \
    -f v4l2  `#use video4linux2` \
    -s 1280x720  `#input resolution` \
    -i /dev/video0  `#input device` \
    -input_format yuyv422  `#input format` \
    -r 30  `# output framerate` \
    `#TRANSCODING VIDEO` \
    -c:v mpeg2video  `#use mpeg2video encoder` \
    -qscale:v 8  `#quality scale between around 2 and 30` \
    `#TRANSMITTING` \
    -f mpegts - `# output format: mpeg transport stream` \
    | nc -l -p 19062 `#send output over tcp`;