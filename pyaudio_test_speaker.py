import pyaudio
import numpy as np

p = pyaudio.PyAudio()

# Generate a sine wave
duration = 5.0
frequency = 440.0
samples = np.arange(int(duration * 44100)) / 44100.0
waveform = np.sin(2 * np.pi * frequency * samples)

# Open a stream
stream = p.open(format=pyaudio.paFloat32,
                channels=1,
                rate=44100,
                output=True)

# Play the sound
stream.write(waveform.astype(np.float32).tobytes())

# Close the stream
stream.stop_stream()
stream.close()
p.terminate()

print("Audio playback completed")