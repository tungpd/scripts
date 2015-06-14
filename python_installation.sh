echo '*****************************************Install Python2.7***************************************'
cd /tmp
#1 Dependencies
sudo yum -y update
sudo yum groupinstall -y development
sudo yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel

#1. Download Python source code:
#go to https://www.python.org/downloads/
#select the version you need

wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tar.xz

#extracting the compressed source archive
sudo yum install xz-libs
xz -d Python-2.7.10.tar.xz
tar -xvf Python-2.7.10.tar
export PYTHON_PREFIX=/usr/local/python-2.7.10
#configure and installation
cd Python-2.7.10    
./configure --enable-shared --prefix=$PYTHON_PREFIX
make -j8
sudo make altinstall
cd ..

sudo cp $PYTHON_PREFIX/lib/libpython2.7.so.1.0 /usr/local/lib
sudo ln -s /usr/local/lib/libpython2.7.so.1.0 /usr/local/lib/libpython2.7.so

sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/python2.7.conf'
#echo '/usr/local/lib' > ./python2.7.conf
#sudo mv ./python2.7.conf /etc/ld.so.conf.d
sudo /sbin/ldconfig
sudo /sbin/ldconfig -v

#setup common python tools pip and virtualenv
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
sudo $PYTHON_PREFIX/bin/python2.7 get-pip.py

#install numpy
sudo $PYTHON_PREFIX/bin/pip2.7 install numpy

sudo sed -i '$ a\ \nPYTHON_PREFIX=/usr/local/python-2.7.10' /etc/profile
sudo sed -i '$ a\ \nPATH=$PATH:$PYTHON_PREFIX/bin/' /etc/profile
sudo sed -i '$ a\ \nexport PATH' /etc/profile
source /etc/profile

#install virtual environment
sudo pip install virtualenv
#install virtual enviroment wrapper
sudo pip install virtualenvwrapper

echo 'export WORKON_HOME=$HOME/.virtualenvs\n export PROJECT_HOME=$HOME/Devel\n \
	source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc

