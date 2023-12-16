#!/bin/sh

set -e

USER="tung"
GROUP="tung"
VHOME=/home/$USER

apt-get update
apt-get install -y build-essential
apt-get install -y git wget curl
apt-get install -y git-buildpackage
apt-get update && apt-get install -y debootstrap qemu-user-static git python3-dev python2-dev python2 python-dev-is-python3 cmake npm
# install clang toolchains on ubuntu 18.04
cd /tmp
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
apt-add-repository 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main'
apt-get update
cd $VHOME
echo "export CLICOLOR=1" >> $VHOME/.bashrc
echo "export LSCOLORS=GxFxCxDxBxegedabagaced" >> $VHOME/.bashrc
echo "export PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;36m\]\W\[\e[0m\]\$ '" >> $VHOME/.bashrc
echo "alias ll='ls -lG'" >> $VHOME/.bashrc


cd /tmp

# install and config vim
# apt-get intall vim
echo ">>>>>> install and config vim"
sudo apt install -y libncurses5-dev libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git
sudo apt remove -y vim vim-runtime gvim
sudo apt remove -y vim-tiny vim-common vim-gui-common vim-nox
cd $VHOME
echo `pwd`
# [ -d "./vim" ] && rm -rf vim
# git clone https://github.com/vim/vim.git
cd vim
echo ">>>>>>>run config vim"
./configure --enable-pythoninterp=yes --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu --enable-python3interp=yes --with-python3-config-dir=/usr/lib/python3.10/config-3.10-x86_64-linux-gnu  --prefix=/usr/local
echo ">>>>>>> make vim"
make -j 8

# sudo apt install -y checkinstall
# sudo checkinstall
echo ">>>>>> make install vim"
sudo make install

sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim
cd $VHOME
chown $USER:$GROUP -R vim

# install vimrc pluggin
echo ">>>>> install vimrc pluggin"
[ -d "./.vim_runtime" ] && rm -rf $VHOME/.vim_runtime
git clone --depth=1 git@github.com:tungpd/vimrc.git $VHOME/.vim_runtime
$VHOME/.vim_runtime/install_awesome_parameterized.sh $VHOME/.vim_runtime --all
echo "set number" >> $VHOME/.vimrc
chown $USER:$GROUP -R $VHOME/.vim_runtime
chown $USER:$GROUP $VHOME/.vimrc

# install YouCompleteMe pluggin
echo ">>>>> install YouCompleteMe pluggin"
cd $VHOME/.vim_runtime/my_plugins
pwd
[ -d "./YouCompleteMe" ] && rm -rf YouCompleteMe
git clone https://github.com/ycm-core/YouCompleteMe.git
cd YouCompleteMe
git checkout dbcc3b0e
git submodule update --init --recursive
# install deps
echo ">>>>> install YouCompleteMe deps"
echo "install golang"
cd /tmp
wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
tar -xvf go1.12.7.linux-amd64.tar.gz
chown -R root:root ./go
[ -d "/usr/local/go" ] && rm -rf /usr/local/go
mv go /usr/local
echo 'export GOROOT=/usr/local/go' >> $VHOME/.bashrc
echo 'export PATH=$GOROOT/bin:$PATH' >> $VHOME/.bashrc
# source $VHOME/.bashrc
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH
cd $VHOME/.vim_runtime/my_plugins/YouCompleteMe
# python3 install.py --all
./install.sh
mkdir -p $VHOME/.vim && cd $VHOME/.vim
# wget https://raw.githubusercontent.com/JDevlieghere/dotfiles/master/.vim/.ycm_extra_conf.py
cd ..
chown $USER:$GROUP -R .vim
ehco 'let g:ycm_use_clangd = 0' >> $VHOME/.vimrc
# echo 'let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"' >> $VHOME/.vimrc

# install TagBar pluggin
cd $VHOME/.vim_runtime/my_plugins
git clone https://github.com/majutsushi/tagbar.git
##

cd $VHOME



# install anaconda
cd /tmp
apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
curl -O https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
bash Anaconda3-2023.09-0-Linux-x86_64.sh
# conda config --set auto_activate_base False

