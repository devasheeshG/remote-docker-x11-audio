import pyaudio

# Create a PyAudio object
p = pyaudio.PyAudio()

# List all available audio devices
for i in range(p.get_device_count()):
    info = p.get_device_info_by_index(i)
    print(f"Device {i}: {info['name']} - Input Channels: {info['maxInputChannels']}, Output Channels: {info['maxOutputChannels']}")

# Terminate the PyAudio object
p.terminate()
