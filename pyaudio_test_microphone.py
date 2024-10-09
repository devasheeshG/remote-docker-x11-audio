import pyaudio
import wave

# Parameters
FORMAT = pyaudio.paInt16  # Audio format (16-bit PCM)
CHANNELS = 1              # Number of channels (1 for mono, 2 for stereo)
RATE = 44100              # Sampling rate (44.1 kHz)
CHUNK = 1024              # Buffer size
WAVE_OUTPUT_FILENAME = "output.wav"  # Output file name

# Initialize PyAudio
p = pyaudio.PyAudio()

# Start recording
stream = p.open(format=FORMAT,
                 channels=CHANNELS,
                 rate=RATE,
                 input=True,
                 frames_per_buffer=CHUNK)

print("Recording...")

frames = []

try:
    while True:
        data = stream.read(CHUNK)
        frames.append(data)
except KeyboardInterrupt:
    print("Recording stopped.")

# Stop and close the stream
stream.stop_stream()
stream.close()
p.terminate()

# Save the recorded data as a WAV file
with wave.open(WAVE_OUTPUT_FILENAME, 'wb') as wf:
    wf.setnchannels(CHANNELS)
    wf.setsampwidth(p.get_sample_size(FORMAT))
    wf.setframerate(RATE)
    wf.writeframes(b''.join(frames))

print(f"Audio recorded and saved as {WAVE_OUTPUT_FILENAME}")
