#!/bin/sh

set -e
USER="tungpd"
GROUP="tungpd"
VHOME=/home/$USER
SCRIPT_DIR=`pwd`

PYTHON2_CONF_DIR=/usr/lib/python2.7/config-arm-linux-gnueabihf/
# PYTHON3_CONF_DIR=/usr/lib/python3.7/config-3.7m-arm-linux-gnueabihf/
PYTHON3_CONF_DIR="`python3.7-config --configdir`"
PYTHON2_BIN = "`which python2`"
PYTHON3_BIN = "`which python3.7`"

apt-get update
apt-get install -y build-essential
apt-get install -y git wget curl
apt-get install -y git-buildpackage
apt-get update && apt-get install -y debootstrap qemu-user-static git python3-dev python-dev cmake ctags

echo "export CLICOLOR=1" >> $VHOME/.bashrc
echo "export LSCOLORS=GxFxCxDxBxegedabagaced" >> $VHOME/.bashrc
echo "export PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;36m\]\W\[\e[0m\]\$ '" >> $VHOME/.bashrc
echo "alias ll='ls -lG'" >> $VHOME/.bashrc

echo ">>>>>>install nodejs"
cd /tmp
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y nodejs
# apt-get install -y npm
# npm install -g npm@latest
# install clang toolchains on Raspberrian
cd $SCRIPT_DIR
sh install_clang8_pi.sh

cd /tmp
# install and config vim
echo ">>>>>> install and config vim"
sudo apt install -y libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git
sudo apt remove -y vim vim-runtime gvim
sudo apt remove -y vim-tiny vim-common vim-gui-common vim-nox
cd $VHOME
echo `pwd`
[ -d "./vim" ] && rm -rf vim

git clone https://github.com/vim/vim.git
cd vim
echo ">>>>>>>run config vim"
./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes --enable-pythoninterp=yes --with-python-config-dir=$PYTHON2_CONF_DIR --enable-python3interp=yes --with-python3-config-dir=$PYTHON3_CONF_DIR --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=gtk2 --enable-cscope --prefix=/usr/local
echo ">>>>>>> make vim"
make

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
git clone --depth=1 https://github.com/amix/vimrc.git $VHOME/.vim_runtime
$VHOME/.vim_runtime/install_awesome_parameterized.sh $VHOME/.vim_runtime --all
echo "set number" >> $VHOME/.vimrc
chown $USER:$GROUP -R $VHOME/.vim_runtime
chown $USER:$GROUP $VHOME/.vimrc

# install YouCompleteMe pluggin
echo ">>>>> install YouCompleteMe pluggin"
cd $VHOME/.vim_runtime/my_plugins
pwd
[ -d "./YouCompleteMe" ] && rm -rf YouCompleteMe
# git clone https://github.com/ycm-core/YouCompleteMe.git
git clone https://github.com/tungpd/YouCompleteMe.git
cd YouCompleteMe
git submodule update --init --recursive
# install deps
echo ">>>>> install YouCompleteMe deps"
echo "install golang"
cd /tmp
#wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
wget https://dl.google.com/go/go1.13.7.linux-armv6l.tar.gz
# tar -xvf go1.12.7.linux-amd64.tar.gz
tar -xvf go1.13.7.linux-armv6l.tar.gz
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
python3 install.py --clangd-completer --go-completer --java-completer --ts-completer
mkdir -p $VHOME/.vim && cd $VHOME/.vim
wget https://raw.githubusercontent.com/JDevlieghere/dotfiles/master/.vim/.ycm_extra_conf.py
cd ..
chown $USER:$GROUP -R .vim
echo 'let g:ycm_use_clangd = 0' >> $VHOME/.vimrc
echo 'let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"' >> $VHOME/.vimrc

# install TagBar pluggin
cd $VHOME/.vim_runtime/my_plugins
git clone https://github.com/majutsushi/tagbar.git
##

cd $VHOME
chown $USER:$GROUP -R $VHOME
cd $VHOME
pip install --user pipenv
mkdir -p envs
virtualenv -p $PYTHON3_BIN envs/py3
