# Install dependencies
sudo apt install autoconf automake build-essential libpulse-dev libx264-dev libmp3lame-dev

# Clone the latest repo
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg

# Configure ffmpeg to use pulseaudio
# ./configure --enable-libpulse
./configure --enable-gpl --enable-libmp3lame --enable-libpulse --enable-libx264

# Build and install ffmpeg
make -j$(nproc)  # Use all available cores for faster compilation
sudo make install

