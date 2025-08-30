#!/bin/bash

#STREAMING SERVER 1: VIDEO ONLY

# Start ffmpeg as a coprocess (it's stdout is available as FFMPEGVIDEOPROC[0])
coproc FFMPEGVIDEOPROC { \
    ffmpeg \
        -loglevel debug \
        -err_detect explode \
        `#AUDIO INPUT` \
        -an  `# dont use audio` \
        `#LOW LATENCY FLAGS` \
        -flags low_delay `# this creates pixelation for high resolutions` \
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
        -qscale:v 12  `#quality scale between around 2 and 30` \
        `#TRANSMITTING` \
        -f mpegts - `# output format: mpeg transport stream` \
        `#| nc -l -p 19062` \
; }

# Pipe ffmpeg output to netcat listener, running in the background
cat <&"${FFMPEGVIDEOPROC[0]}" | nc -l -p 19062
# NETCAT_PID=$!

#wait for ffmpeg coprocess to finish
wait "${FFMPEGVIDEOPROC_PID}"
FFMPEGVIDEO_EXIT_CODE=$?

if [[ $FFMPEGVIDEO_EXIT_CODE -ne 0 ]]; then
    kill $NETCAT_PID
fi