# remote-docker-x11-audio

This project enables X11 forwarding and audio playback from remote Docker containers to local Windows/Mac clients. Run GUI apps and play audio in containers on remote servers, with output on your local machine. Supports tools like matplotlib and pyaudio. Create a seamless, native-like experience for remote development environments.

## Audio Forwarding (Mic & Speaker)

### Windows Client Setup

1. [Download](http://bosmans.ch/pulseaudio/pulseaudio-1.1.zip) PulseAudio for Windows from the official website.
2. Extract the downloaded ZIP file to a folder (e.g., `C:\pulseaudio-1.1`).
3. Edit the configuration file (located at `C:\pulseaudio-1.1\etc\pulse\default.pa`):

```conf
load-module module-native-protocol-tcp auth-ip-acl=0.0.0.0/0 auth-anonymous=1
load-module module-esound-protocol-tcp auth-ip-acl=0.0.0.0/0 auth-anonymous=1
load-module module-waveout sink_name=output source_name=input
set-default-sink output
set-default-source input
```

4. Edit `C:\pulseaudio-1.1\etc\pulse\daemon.conf`
   Set `exit-idle-time = -1` to prevent PulseAudio from exiting when idle.

5. Run PulseAudio:
   Open Command Prompt as Administrator and run:

```powershell
"C:\pulseaudio-1.1\bin\pulseaudio.exe" --exit-idle-time=-1
```

### Mac Client Setup

### Docker Container Setup

1. Run the following commands in your Docker container to install PulseAudio:

```bash
sudo apt-get update
sudo apt-get install -y pulseaudio alsa-utils
```

2. Create necessary directories

```bash
mkdir -p /var/run/dbus
mkdir -p /var/run/pulse
mkdir -p /root/.config/pulse
```

3. Generate machine-id

```bash
dbus-uuidgen > /var/lib/dbus/machine-id
```

4. If your dbus-daemon is not running, start it:

```bash
dbus-daemon --system --fork
```

5. Configure PulseAudio:

```bash
cat << EOF > /etc/pulse/client.conf
# default-server = tcp:<WINDOWS_IP>:4713    # Will be set via environment variable
autospawn = no
daemon-binary = /bin/true
enable-shm = false
EOF
```

5. Export the PulseAudio server address:

```bash
export PULSE_SERVER=tcp:<CLIENT_IP>:4713
```

Replace `<CLIENT_IP>` with the IP address of your Windows/Mac client.


### Additional Commands

1. Check if PulseAudio is running:

```bash
pactl info
```

2. Test audio playback:

```bash
# Default audio test
speaker-test -c 2 -t wav

# Play a test audio file
aplay -D pulse test_audio.wav
```

3. Test audio recording:

```bash
# Default audio recording
arecord -f cd -t wav -d 5 output.wav
aplay -D pulse output.wav


# Record audio from the default microphone using pyaudio
python3 pyaudio_test_microphone.py
aplay -D pulse output.wav
```

### Troubleshooting

- [Stackoverflow - Use pulseaudio inside docker container](https://stackoverflow.com/questions/64037579/running-pulseaudio-inside-docker-container-to-record-system-audio)
- Use Google.

## X11 Forwarding (GUI)

### Docker Container Setup

1. Ensure SSH is installed and running in your Docker container:

```bash
sudo apt-get update
sudo apt-get install -y openssh-server
sudo service ssh start

# Set `PermitRootLogin yes` in /etc/ssh/sshd_config if you want to SSH as root
```

2. Edit `/etc/ssh/sshd_config` to include:

```bash
X11Forwarding yes
X11UseLocalhost no
```

3. Restart the SSH service:

```bash
# For systemctl based systems
sudo systemctl restart ssh

# For systems using service
sudo service ssh restart
```

4. Install X11 and GUI applications in your Docker container:

```bash
sudo apt-get update
sudo apt-get install -y xauth x11-apps
```

### Windows Client Setup

1. Install an SSH client like [PuTTY](https://www.putty.org/).
2. Install an X11 server like [Xming](https://sourceforge.net/projects/xming/).
3. Open PuTTY and navigate to `Connection > SSH > X11`.
4. Check `Enable X11 forwarding`.
5. Navigate back to `Session`, enter the hostname and port of your server, and click `Open`.
6. Install Xming and run it.
7. Open PuTTY and SSH into your server.
8. Run a GUI application like `xeyes` or `gedit`.

### Mac Client Setup
