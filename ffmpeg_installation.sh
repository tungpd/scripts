echo '********************************Install FFMPEG**********************************************************'
ARGS=-j8

sudo yum remove libvpx libogg libvorbis libtheora libx264 x264 ffmpeg
sudo yum update

cd /tmp

sudo yum install http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
sudo yum install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

sudo yum install autoconf automake gcc gcc-c++ git libtool make nasm pkgconfig wget zlib-devel dbus-devel lua-devel zvbi libdvdread-devel  libdc1394-devel libxcb-devel xcb-util-devel libxml2-devel mesa-libGLU-devel pulseaudio-libs-devel alsa-lib-devel libgcrypt-devel gsm-devel
#sudo yum install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel
#if [ $? -ne 0 ]; then
#	echo 'ERROR'
#	exit 127
#fi
#sleep 10
sudo yum --enablerepo=epel install yasm libva-devel libass-devel libkate-devel libbluray-devel libdvdnav-devel libcddb-devel libmodplug-devel
sudo yum --enablerepo=rpmforge install a52dec-devel libmpeg2-devel
#
#echo '***********************Install yasm*******************************\n'
#git clone --depth 1 git://github.com/yasm/yasm.git
#cd yasm
#autoreconf -fiv
#./configure
#make 
#sudo make install
#make distclean
#if [ $? -ne 0 ]; then
#        echo 'ERROR'
#	exit 127
#fi
cd /tmp

#sleep 10
echo '***********************install x264******************************\n'
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --enable-shared
make $ARGS
sudo make install 
make distclean
if [ $? -ne 0 ]; then
	echo 'some errors occured when trying to install x264'
        echo 'ERROR'
	exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/x264.conf'
sudo ldconfig

cd /tmp
#sleep 10
#
#echo '************************install x265*****************************\n'
#hg clone https://bitbucket.org/multicoreware/x265
#cd x265/build/linux
#cmake -G "Unix Makefiles" -DENABLE_SHARED:bool=on ../../source | make | sudo make install
#if [ $? -ne 0 ]; then
#        echo 'ERROR'
#	exit 127
#fi
#cd /tmp
#sleep 10

echo '*************************install Xvid******************************\n'
cd /tmp
rm -rf /tmp/xvidcore*
wget http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz 
tar xvfz xvidcore-1.3.2.tar.gz 
cd xvidcore/build/generic 
./configure --prefix=/usr/local
make $ARGS
sudo make install
if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to installl Xvid'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/Xvid.conf'
sudo ldconfig

cd /tmp


echo '*************************install fdk-aac****************************\n'
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --enable-shared --enable-static
make $ARGS
sudo make install
make distclean
if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to installl fdk-aac'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/fdk-aac.conf'
sudo ldconfig
cd /tmp
#sleep 10

echo '*************************install lame********************************\n'
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --enable-shared --enable-nasm
make $ARGS
sudo make install
sudo make distclean
if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to install lame'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/lame-3.99.5.conf'
sudo ldconfig
cd /tmp
#sleep 10

#echo '*****************************install opus******************************\n'
#git clone git://git.opus-codec.org/opus.git
#cd opus
#autoreconf -fiv
#./configure --enable-shared
#make
#sudo make install
#sudo make distclean
#if [ $? -ne 0 ]; then
#        echo 'some errors occured when trying to install opus'
#        exit 127
#fi
#cd /tmp
#sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opus.conf'
#sudo ldconfig
#sleep 10

echo '********************************install opencore-arm************************\n'
cd /tmp
wget http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/0.1.2/opencore-amr-0.1.2.tar.gz
tar xvfz opencore-amr-0.1.2.tar.gz
cd opencore-amr-0.1.2
./configure
make $ARGS
sudo make install
if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to install opencore-arm'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencore-arm.conf'
sudo ldconfig

cd /tmp

echo '*****************************install libogg******************************\n'
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --enable-shared
make $ARGS
sudo make install
make distclean
if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to install ogg'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/libogg-1.3.2.conf'
sudo ldconfig
cd /tmp
#sleep 10

echo '*****************************install libtheora***************************\n'
wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
tar xzvf libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --enable-shared
make $ARGS
sudo make install
if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to install ogg'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/libtheora.conf'
sudo ldconfig

cd /tmp

echo '****************************install libvorbis*****************************\n'
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
#LDFLAGS="-L$HOME/ffmeg_build/lib" CPPFLAGS="-I$HOME/ffmpeg_build/include" 
./configure --with-ogg=/usr/local --enable-shared
make $ARGS
sudo make install
make distclean
if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to install vorbis'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/libvorbis.conf'
sudo ldconfig
cd /tmp
#sleep 10

echo '************************************install libvpx***********************\n'
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --disable-examples --enable-shared
make $ARGS
sudo make install
make clean
if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to install vpx'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/libvpx.conf'
sudo ldconfig

cd /tmp
#sleep 10


echo '***********************************install ffmpeg*******************************\n'
cd /tmp
git clone git://source.ffmpeg.org/ffmpeg
cd ffmpeg
./configure --enable-gpl --enable-version3 --enable-libfdk_aac --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree  --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libgsm --enable-libxvid --disable-static --enable-shared
make $ARGS
sudo make install

if [ $? -ne 0 ]; then
        echo 'some errors occured when trying to install ffmpeg'
        exit 127
fi
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/ffmpeg.conf'
sudo ldconfig

cd /tmp

