#!/bin/bash

#STREAMING SERVER 1: VIDEO ONLY

FIFO=/tmp/streaming_server_1_pipe

trap cleanup EXIT INT TERM

#Reset the usb camera device
sudo usbreset 292A-AR0230

# Remove the FIFO if it already exists
[[ -p "$FIFO" ]] && rm "$FIFO"
mkfifo "$FIFO"

# Start netcat listener reading from the FIFO
nc -l -p 19062 < "$FIFO" &
NETCAT_PID=$!

ffmpeg \
    -loglevel debug \
    -err_detect explode \
    `#AUDIO INPUT` \
    -an  `# dont use audio` \
    `#LOW LATENCY FLAGS` \
    -flags low_delay `# this creates pixelation for high resolutions` \
    -fflags nobuffer `#apparently this reduces latency a bit` \
    `#VIDEO INPUT` \
    -r 25  `#input framerate` \
    -f v4l2  `#use video4linux2` \
    -s 1920x1080  `#input resolution` \
    -i /dev/video4  `#input device` \
    -input_format h264  `#input format` \
    -r 25  `# output framerate` \
    `#TRANSCODING VIDEO` \
    -vf "crop=1000:1000:200:200" `# crop` \
    -c:v mpeg2video  `#use mpeg2video encoder` \
    -qscale:v 2  `#quality scale between around 2 and 30` \
    `#TRANSMITTING` \
    -f mpegts - `# output format: mpeg transport stream` \
    > "$FIFO" &
FFMPEG_PID=$!

# Wait for ffmpeg to finish
wait $FFMPEG_PID

function cleanup {
    echo "Cleaning up..."
    rm "$FIFO"
    kill $NETCAT_PID 2>/dev/null
    kill $FFMPEG_PID 2>/dev/null
}