# Install required tools (run as administrator)
# Install Chocolatey if not already installed
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install ffmpeg
choco install ffmpeg -y

# Variables
$remoteHost = "192.168.0.253"
$remoteUser = "devasheesh"
$micStreamPort = 12345
$speakerStreamPort = 12346

# Function to set up SSH port forwarding
function Setup-SSHForwarding {
    Start-Process -FilePath "plink" -ArgumentList "-N -L $speakerStreamPort`:localhost:$speakerStreamPort -R $micStreamPort`:localhost:$micStreamPort $remoteUser@$remoteHost"
}

# Function to start microphone streaming
function Start-MicStreaming {
    ffmpeg -f dshow -i audio="Realtek Microphone" -acodec libmp3lame -b:a 128k -f mp3 tcp://localhost:$micStreamPort
}

# Function to receive and play speaker audio
function Receive-SpeakerAudio {
    ffplay -nodisp -i tcp://localhost:$speakerStreamPort
}

# Main execution
Setup-SSHForwarding
Start-Sleep -Seconds 5  # Wait for SSH forwarding to establish

# Start both streaming and receiving in parallel
Start-Job -ScriptBlock { Start-MicStreaming }
Start-Job -ScriptBlock { Receive-SpeakerAudio }

# Keep the script running
while ($true) { Start-Sleep -Seconds 1 }
