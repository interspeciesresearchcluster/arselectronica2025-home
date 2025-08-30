#!/bin/bash

#STREAMING SERVER 2: AUDIO ONLY

FIFO=/tmp/streaming_server_2_pipe

trap cleanup EXIT INT TERM

# Remove the FIFO if it already exists
[[ -p "$FIFO" ]] && rm "$FIFO"
mkfifo "$FIFO"

# Start netcat listener reading from the FIFO
nc -l -p 19063 < "$FIFO" &
NETCAT_PID=$!

ffmpeg \
    -loglevel debug \
    -err_detect explode \
    `#AUDIO INPUT` \
    `#-an   dont use audio` \
    -thread_queue_size 1024 `#buffer size for packets waiting to be encoded (seems must be defined twice?)` \
    -f alsa `#use alsa` \
    -ac 2 `#num of audio channels` \
    -ar 44100 `#audio sample rate` \
    -acodec pcm_s32le `#set audio codec/format` \
    -i plughw:0,0 `#audio input device` \
    `#LOW LATENCY FLAGS` \
    `#-flags low_delay this creates pixelation for high resolutions` \
    -fflags nobuffer `#apparently this reduces latency a bit` \
    `#VIDEO INPUT` \
    -vn \
    `#TRANSCODING VIDEO` \
    `#TRANSMITTING` \
    -f mpegts - `# output format: mpeg transport stream` \
    > "$FIFO" &
FFMPEG_PID=$!

# Wait for ffmpeg to finish
wait $FFMPEG_PID
FFMPEG_EXIT_CODE=$?

function cleanup {
    echo "Cleaning up..."
    rm "$FIFO"
    kill $NETCAT_PID 2>/dev/null
    kill $FFMPEG_PID 2>/dev/null
}