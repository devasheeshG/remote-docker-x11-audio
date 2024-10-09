import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

# Parameters
frequency = 1    # Frequency of the sine wave in Hz
sampling_rate = 1000  # Samples per second
duration = 2    # Duration in seconds

# Time array
t = np.linspace(0, duration, int(sampling_rate * duration), endpoint=False)

# Sine wave formula
y = np.sin(2 * np.pi * frequency * t)

# Plotting the sine wave
plt.figure(figsize=(10, 5))
plt.plot(t, y)
plt.title('Sine Wave')
plt.xlabel('Time (seconds)')
plt.ylabel('Amplitude')
plt.grid()
plt.xlim(0, duration)
plt.ylim(-1.5, 1.5)
plt.axhline(0, color='black', lw=0.5, ls='--')
plt.show()
