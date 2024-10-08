#!/bin/bash

LOG_FILE="/tmp/audio_handler.log"

log_message() {
    # echo "$(date): $1" >> "$LOG_FILE"
    echo "$(date): $1"
}

# Start PulseAudio daemon
pulseaudio --start

## Create virtual devices
# INPUT: virtual_microphone
pactl load-module module-null-sink sink_name=virtual_speaker
pactl load-module module-null-sink sink_name=virtual_microphone


pactl load-module module-loopback source=virtual_microphone.monitor sink=virtual_speaker

MIC_STREAM_PORT=12345
SPEAKER_STREAM_PORT=12346

# Function to start a netcat listener for microphone input
start_mic_listener() {
    while true; do
        log_message "Starting netcat listener for microphone on port $MIC_STREAM_PORT"
        nc -l -p $MIC_STREAM_PORT | ffmpeg -i pipe:0 -acodec pcm_s16le -f pulse "virtual_microphone" 2>> "$LOG_FILE"
        log_message "Netcat listener (mic) exited, restarting..."
        sleep 1
    done
}

# Function to stream speaker audio
stream_speaker_audio() {
    while true; do
        log_message "Starting speaker audio stream on port $SPEAKER_STREAM_PORT"
        ffmpeg -f pulse -i virtual_speaker.monitor -acodec libmp3lame -b:a 128k -f mp3 -listen 1 -timeout 5000000 tcp://0.0.0.0:$SPEAKER_STREAM_PORT 2>> "$LOG_FILE"
        log_message "Speaker audio stream exited, restarting..."
        sleep 1
    done
}

log_message "Starting audio handler script"

# start_mic_listener
# start_mic_listener &

stream_speaker_audio
# stream_speaker_audio &

# wait
