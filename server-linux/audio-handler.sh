#!/bin/bash

# Log file
LOG_FILE="/tmp/audio_handler.log"

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Load PulseAudio module if not already loaded
pactl load-module module-null-sink sink_name=virtual_speaker

# Set the default sink to our virtual speaker
pacmd set-default-sink virtual_speaker

# Variables
MIC_STREAM_PORT=12345
SPEAKER_STREAM_PORT=12346

# Function to receive microphone audio and play through virtual speaker
receive_mic_audio() {
    while true; do
        log_message "Attempting to receive mic audio on port $MIC_STREAM_PORT"
        ffplay -nodisp -i tcp://0.0.0.0:$MIC_STREAM_PORT 2>> "$LOG_FILE"
        log_message "ffplay exited with status $?"
        sleep 5
    done
}

# Function to capture audio from virtual speaker and stream back
stream_speaker_audio() {
    while true; do
        log_message "Attempting to stream speaker audio on port $SPEAKER_STREAM_PORT"
        ./ffmpeg -f pulse -i virtual_speaker.monitor -acodec libmp3lame -b:a 128k -f mp3 tcp://0.0.0.0:$SPEAKER_STREAM_PORT 2>> "$LOG_FILE"
        log_message "ffmpeg exited with status $?"
        sleep 5
    done
}

# Main execution
log_message "Starting audio handler script"

receive_mic_audio &
stream_speaker_audio &

# Keep the script running
wait
