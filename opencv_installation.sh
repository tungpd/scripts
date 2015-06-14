#Install Opencv on Centos 6
#cd /tmp

#1. Compulsory libs
#yum install python-devel numpy
sh ./python_installation.sh
sudo yum install cmake
sudo yum install gcc gcc-c++
sudo yum install gtk2-devel
sudo yum install libdc1394-devel
sudo yum install libv4l-devel
#yum install ffmpeg-devel
sh ./ffmpeg_installation.sh

yum install gstreamer-plugins-base-devel

#2. Optional libs
sudo yum install libdc1394-devel.x86_64 tbb-devel.x86_64
sudo yum install openjpeg-devel.x86_64 turbojpeg-devel.x86_64 
sudo yum install libpng-devel.x86_64
sudo yum install libtiff-devel.x86_64
sudo yum install jasper-devel.x86_64
sudo yum install libdc1394-devel.x86_64
sudo yum install eigen3-devel
#yum install python-sphinx
#yum install texlive
sudo ldconfig
cd ./tmp
wget http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.11/opencv-2.4.11.zip
unzip opencv-2.4.11.zip
cd opencv-2.4.11
mkdir release
cd release
PYTHON_PREFIX=/usr/local/python-2.7.10
#sudo sh -c 'echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /etc/profile'
#sudo sh -c 'echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" >> /etc/profile'
sudo sh -c 'echo "export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR:/usr/local/lib/" >> /etc/profile'

cmake ../ -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_EXAMPLES=ON -DWITH_EIGEN=ON -DBUILD_NEW_PYTHON_SUPPORT=ON -DINSTALL_PYTHON_EXAMPLES=ON -DPYTHON_EXECUTABLE=$PYTHON_PREFIX/bin/python2.7 -DPYTHON_INCLUDE_DIR=$PYTHON_PREFIX/include/python2.7/ -DPYTHON_LIBRARY=$PYTHON_PREFIX/lib/libpython2.7.so.1.0 -DPYTHON_NUMPY_INCLUDE_DIR=$PYTHON_PREFIX/lib/python2.7/site-packages/numpy/core/include/ -DPYTHON_PACKAGES_PATH=$PYTHON_PREFIX/lib/python2.7/site-packages/ -DBUILD_PYTHON_SUPPORT=ON -DWITH_TBB=ON -DWITH_OPENMP=ON -DBUILD_TESTS=ON
#sleep 60

make all -j16
#sudo make install
sudo ldconfig

