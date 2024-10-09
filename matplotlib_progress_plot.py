import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

def animate_sine_progress(total_frames=200):
    # Set up the figure and axis
    fig, ax = plt.subplots(figsize=(10, 4))
    ax.set_xlim(0, 2*np.pi)
    ax.set_ylim(-1.1, 1.1)
    ax.axis('off')

    # Create the sine wave data
    x = np.linspace(0, 2*np.pi, 1000)
    y = np.sin(x)

    # Create the line object
    line, = ax.plot([], [], color='blue', linewidth=2)
    
    # Create the progress point
    point, = ax.plot([], [], 'ro', markersize=10)
    
    # Create the progress text
    progress_text = ax.text(0.5, 1.1, '', ha='center', va='center', transform=ax.transAxes, fontsize=16)

    def init():
        line.set_data([], [])
        point.set_data([], [])
        progress_text.set_text('')
        return line, point, progress_text

    def update(frame):
        progress = frame / (total_frames - 1)
        index = int(len(x) * progress)
        
        line.set_data(x[:index], y[:index])
        point.set_data(x[index-1], y[index-1])
        progress_text.set_text(f"Progress: {progress*100:.1f}%")
        
        return line, point, progress_text

    anim = FuncAnimation(fig, update, frames=total_frames, init_func=init, blit=True, interval=50)
    
    plt.tight_layout()
    plt.show()

# Run the animation
animate_sine_progress()