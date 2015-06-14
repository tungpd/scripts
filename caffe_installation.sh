echo '************************************Install caffe**************************************\n'
ARGS=-j16
cd /tmp
echo '************************************Install dependencies*******************************\n'

sudo yum -y update
sudo yum -y groupinstall "Development Tools"
sudo yum install -y wget
echo '**********************************update autoconf**************************************\n'
wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
tar xvf autoconf-2.69.tar.gz
cd autoconf-2.69
./configure --prefix=/usr
make $ARGS
sudo make install
cd /tmp
echo '*************************************update automake****************************\n'
wget http://ftp.gnu.org/gnu/automake/automake-1.14.tar.gz
tar xvf automake-1.14.tar.gz
cd automake-1.14
./configure --prefix=/usr
make $ARGS
sudo make install
sudo ldconfig
automake --add-missing
echo '************************************update libtool******************************'
cd /tmp
git clone git://git.savannah.gnu.org/libtool.git
cd libtool
sudo yum install help2man
./boostrap
./configure
if [ $? -ne 0 ]; then
	echo 'some errors occured when trying to install libtool'
        echo 'ERROR'
	exit 127
fi
make all $ARGS
make check $ARGS
sudo make install
if [ $? -ne 0 ]; then
	echo 'some errors occured when trying to install libtool'
        echo 'ERROR'
	exit 127
fi
cd /tmp

echo '**************************************Install OpenBlas*******************************\n'
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
make $ARGS
sudo make install PREFIX=/usr/local
if [ $? -ne 0 ]; then
	echo 'some errors occured when trying to install OpenBLAS'
	echo 127
fi
sudo ldconfig
cd /tmp

echo '*******************************Install boost***************************************\n'
wget http://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.zip/download
mv download boost_1_58_0.zip
unzip boost_1_58_0.zip
cd boost_1_58_0
sed -e '1 i#ifndef Q_MOC_RUN' \
    -e '$ a#endif'            \
    -i boost/type_traits/detail/has_binary_operator.hpp
./bootstrap.sh --prefix=/usr/local --with-python=/usr/local/python-2.7.10/bin/python2.7
./b2 stage threading=multi link=shared
sudo ./b2 install threading=multi link=shared
sudo ldconfig
cd /tmp

echo '*******************************Install Protobuf***************************************\n'
git clone https://github.com/google/protobuf.git
cd protobuf
./autogen.sh
./configure

make $ARGS
make check $ARGS
sudo make install
sudo ldconfig
cd /tmp

echo '*******************************Install glog***************************************\n'
git clone https://github.com/google/glog.git
cd glog
./configure --prefix=/usr/local
make
sudo make install
sudo ldconfig
cd /tmp

echo '********************************Install gflags************************************\n'
git clone https://github.com/gflags/gflags.git
cd gflags
mkdir build && cd build
cmake ../ -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON -DBUILD_TESTING=ON
make $ARGS
make test $ARGS
sudo make install
cd /tmp

echo '********************************Install others dependencies************************************\n'
sudo yum install hdf5-devel.x86_64 hdf5-mpich-devel.x86_64 hdf5-openmpi-devel.x86_64
sudo yum install leveldb-devel.x86_64
sudo yum install snappy-devel.x86_64
sudo yum install lmdb-devel.x86_64 lmdb-libs.x86_64

echo '********************************Install caffe************************************\n'

git clone https://github.com/BVLC/caffe.git
cd caffe
cp Makefile.config.example Makefile.config
mkdir build && cd build
cmake ../ -DCPU_ONLY=1 -DBLAS=open -DWITH_PYTHON_LAYER=1 -DPYTHON_INCLUDE_DIR=/usr/local/python-2.7.10/include/python2.7
	#-DBLAS_INCLUDE=/usr/local/include -DBLAS_LIB=/usr/local/lib
make all $ARGS
make runtest $ARGS
make install
sudo rm -rf /usr/local/caffe
sudo mkdir /usr/local/caffe
sudo cp ./install/* /usr/local/caffe
sudo sed -i '$ a\ CAFFE_DIR=/usr/local/caffe \nPATH=$PATH:$CAFFE_DIR/bin \nexport PATH' /etc/profile
sudo sed -i '$ a\ CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:CAFFE_DIR/include \nexport CPLUS_INCLUDE_PATH \nexport PYTHONPATH=$PYTHONPATH:/usr/local/caffe/python' /etc/profile
sudo sh -c 'echo "/usr/local/caffe/lib" > /etc/ld.so.conf.d/caffe.conf'
sudo ldconfig
source /etc/profile






