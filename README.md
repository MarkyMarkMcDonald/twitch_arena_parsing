Installation on Ubuntu 14.04
============================

```bash
sudo apt-get install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev

# Download 2.x, not 3.x
wget http://softlayer-dal.dl.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.10/opencv-2.4.10.zip
unzip opencv-2.4.10.zip
cd opencv-2.4.10.zip

# See http://docs.opencv.org/trunk/doc/tutorials/introduction/linux_install/linux_install.html
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local ..
make -j7
sudo make install

# Install a ffmpeg fork and make believe
sudo apt-get install sudo ln -s avconv /usr/bin/ffmpeg
sudo ln -s avconv /usr/bin/ffmpeg
```
