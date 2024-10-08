#!/bin/bash

# Create necessary directories
mkdir -p /var/run/dbus
mkdir -p /var/run/pulse
mkdir -p /root/.config/pulse

# Generate machine-id
dbus-uuidgen > /var/lib/dbus/machine-id

# Start dbus daemon
dbus-daemon --system --fork

# Configure PulseAudio
cat << EOF > /etc/pulse/client.conf
default-server = tcp:192.168.0.124:4713
autospawn = no
daemon-binary = /bin/true
enable-shm = false
EOF

# Start PulseAudio
pulseaudio --start -vvv --exit-idle-time=-1 --system --disallow-exit

# Set the PULSE_SERVER environment variable
export PULSE_SERVER=unix:/tmp/pulseaudio.socket

# Your application command here
# For example: python your_audio_app.py

# Keep the container running
tail -f /dev/null