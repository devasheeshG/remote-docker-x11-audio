# Install required tools (run as administrator)
# Install Chocolatey if not already installed
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install ffmpeg and plink
# choco install ffmpeg -y
# choco install putty.install -y

# Variables
$remoteHost = "192.168.0.253"
$remoteUser = "devasheesh"
$micStreamPort = 12345
$speakerStreamPort = 12346
# $sshKeyPath = ".\puttygen_private_key.ppk"

# Function to set up SSH port forwarding
function Setup-SSHForwarding {
    # Start-Process -FilePath "plink" -ArgumentList "-N -i `"$sshKeyPath`" -L $speakerStreamPort`:localhost:$speakerStreamPort -L $micStreamPort`:localhost:$micStreamPort $remoteUser@$remoteHost" -NoNewWindow
    Start-Process -FilePath "ssh" -ArgumentList "-N -L $speakerStreamPort:localhost:$speakerStreamPort -L $micStreamPort:localhost:$micStreamPort $remoteUser@$remoteHost" -NoNewWindow
}

# Function to start microphone streaming
# function Start-MicStreaming {
#     while ($true) {
#         ffmpeg -f dshow -i audio="Microphone Array (Realtek(R) Audio)" -acodec libmp3lame -b:a 128k -f mp3 tcp://localhost:$micStreamPort
#         Start-Sleep -Seconds 5
#     }
# }

# Function to receive and play speaker audio
function Receive-SpeakerAudio {
    while ($true) {
        ffplay -nodisp -i tcp://localhost:$speakerStreamPort
        Start-Sleep -Seconds 5
    }
}

# Main execution
Setup-SSHForwarding
Start-Sleep -Seconds 5  # Wait for SSH forwarding to establish

# Start both streaming and receiving in parallel
Start-Job -ScriptBlock { Start-MicStreaming }
# Start-Job -ScriptBlock { Receive-SpeakerAudio }

# Keep the script running and monitor jobs
while ($true) {
    Get-Job | Where-Object { $_.State -eq 'Failed' } | ForEach-Object {
        Write-Host "Job $($_.Name) failed. Restarting..."
        Remove-Job $_
    #     if ($_.Name -eq 'Start-MicStreaming') {
    #         Start-Job -ScriptBlock { Start-MicStreaming }
    #    } elseif ($_.Name -eq 'Receive-SpeakerAudio') {
       if ($_.Name -eq 'Receive-SpeakerAudio') {
           Start-Job -ScriptBlock { Receive-SpeakerAudio }
        }
    }
    Start-Sleep -Seconds 10
}
