#!/bin/bash

#STREAMING SERVER 2: AUDIO ONLY

# Start ffmpeg as a coprocess (it's stdout is available as FFMPEGAUDIOPROC[0])
coproc FFMPEGAUDIOPROC { \
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
; }

# Pipe ffmpeg output to netcat listener, running in the background
cat <&"${FFMPEGAUDIOPROC[0]}" | nc -l -p 19062 &
NETCAT_PID=$!

#wait for ffmpeg coprocess to finish
wait "${FFMPEGAUDIOPROC_PID}"
FFMPEGAUDIO_EXIT_CODE=$?

if [[ $FFMPEGAUDIO_EXIT_CODE -ne 0 ]]; then
    kill $NETCAT_PID
fi