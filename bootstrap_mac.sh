#!/bin/sh

set -e

USER="tungpd"
GROUP="staff"
VHOME=/Users/$USER
BASH_PROFILE=$VHOME/.bash_profile

PYTHON2_CONF_DIR=/usr/lib/python2.7/config/
PYTHON3_CONF_DIR="`python3.7-config --configdir`"

echo ">>>>>>>>PYTHON2_CONF_DIR=$PYTHON2_CONF_DIR"
echo ">>>>>>>>PYTHON3_CONF_DIR=$PYTHON3_CONF_DIR"

echo "export CLICOLOR=1" >> $VHOME/.bash_profile
echo "export LSCOLORS=GxFxCxDxBxegedabagaced" >> $VHOME/.bash_profile
echo "export PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;36m\]\W\[\e[0m\]\$ '" >> $VHOME/.bash_profile
echo "alias ll='ls -lG'" >> $VHOME/.bash_profile

# xcode-select --install

# brew install python
# brew upgrade python

# install and config vim
echo ">>>>>> install and config vim"
cd $VHOME
echo `pwd`
[ -d "./vim" ] && rm -rf vim

git clone https://github.com/vim/vim.git
cd vim
echo ">>>>>>>run config vim"
./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes --enable-python3interp=yes --with-python3-config-dir=$PYTHON3_CONF_DIR --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=gtk2 --enable-cscope --prefix=/usr/local
echo ">>>>>>> make vim"
make

echo ">>>>>> make install vim"
sudo make install
sudo ln -s /usr/local/bin/vim /usr/local/bin/vi
echo ">>>>>>>>$VHOME"
cd $VHOME
chown -R $USER:$GROUP vim

# install vimrc pluggin
echo ">>>>> install vimrc pluggin"
[ -d "./.vim_runtime" ] && sudo rm -rf $VHOME/.vim_runtime
git clone --depth=1 https://github.com/amix/vimrc.git $VHOME/.vim_runtime
$VHOME/.vim_runtime/install_awesome_parameterized.sh
echo "set number" >> $VHOME/.vimrc
chown -R $USER:$GROUP $VHOME/.vim_runtime
chown $USER:$GROUP $VHOME/.vimrc

# install YouCompleteMe pluggin
echo ">>>>> install YouCompleteMe pluggin"
cd $VHOME/.vim_runtime/my_plugins
pwd
[ -d "./YouCompleteMe" ] && rm -rf YouCompleteMe
git clone https://github.com/ycm-core/YouCompleteMe.git
cd YouCompleteMe
git submodule update --init --recursive
# install deps
echo ">>>>> install YouCompleteMe deps"
echo "install golang"
# brew update
# brew install go
echo 'export GOPATH=$VHOME/go-workspace' >> $BASH_PROFILE
echo 'export GOROOT=/usr/local/opt/go/libexec' >> $BASH_PROFILE
echo 'export PATH=$PATH:$GOPATH/bin' >> $BASH_PROFILE
echo 'export PATH=$PATH:$GOROOT/bin' >> $BASH_PROFILE
echo 'finish installing GO'

cd $VHOME/.vim_runtime/my_plugins/YouCompleteMe
python3 install.py --clangd-completer --go-completer --java-completer --ts-completer
mkdir -p $VHOME/.vim && cd $VHOME/.vim
wget https://raw.githubusercontent.com/JDevlieghere/dotfiles/master/.vim/.ycm_extra_conf.py
cd ..
chown -R $USER:$GROUP .vim
echo 'let g:ycm_use_clangd = 0' >> $VHOME/.vimrc
echo 'let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"' >> $VHOME/.vimrc

# install TagBar pluggin
cd $VHOME/.vim_runtime/my_plugins
git clone https://github.com/majutsushi/tagbar.git
##

chown -R $USER:$GROUP $VHOME
cd $VHOME
