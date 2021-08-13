#!/bin/sh

set -e

WEBRTC=1
if [ $WEBRTC -eq 1 ]
then
  WEBRTC_VERSION="m77"
  echo ">>>>>>>>>WEBRTC_VERSION: $WEBRTC_VERSION"
fi
USER="vagrant"
GROUP="vagrant"
VHOME=/home/$USER

apt-get update
apt-get install -y build-essential
apt-get install -y git wget curl
apt-get install -y git-buildpackage
apt-get update && apt-get install -y debootstrap qemu-user-static git python3-dev python-dev cmake clang-6.0 npm ctags
# install clang toolchains on ubuntu 18.04
cd /tmp
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
apt-add-repository 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main'
apt-get update
cd $VHOME
apt-get install -y libllvm-8-ocaml-dev libllvm8 llvm-8 llvm-8-dev llvm-8-doc llvm-8-examples llvm-8-runtime
apt-get install -y clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 python-clang-8 clangd-8
apt-get install -y libfuzzer-8-dev
apt-get install -y lldb-8
apt-get install -y lld-8
apt-get install -y libc++-8-dev libc++abi-8-dev
apt-get install -y libomp-8-dev
update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-8 100
# update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 1000
# update-alternatives --install /usr/bin/clang++ clang /usr/bin/clang-3.8 100
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 100
update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-8 100
# update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 1000
update-alternatives --config clang
update-alternatives --config clang-format
update-alternatives --config clang++

echo "export CLICOLOR=1" >> $VHOME/.bashrc
echo "export LSCOLORS=GxFxCxDxBxegedabagaced" >> $VHOME/.bashrc
echo "export PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;36m\]\W\[\e[0m\]\$ '" >> $VHOME/.bashrc
echo "alias ll='ls -lG'" >> $VHOME/.bashrc


cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

# install and config vim
# apt-get intall vim
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
./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes --enable-pythoninterp=yes --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu --enable-python3interp=yes --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/ --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=gtk2 --enable-cscope --prefix=/usr/local
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
python3 install.py --all
mkdir -p $VHOME/.vim && cd $VHOME/.vim
wget https://raw.githubusercontent.com/JDevlieghere/dotfiles/master/.vim/.ycm_extra_conf.py
cd ..
chown $USER:$GROUP -R .vim
ehco 'let g:ycm_use_clangd = 0' >> $VHOME/.vimrc
echo 'let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"' >> $VHOME/.vimrc

# install TagBar pluggin
cd $VHOME/.vim_runtime/my_plugins
git clone https://github.com/majutsushi/tagbar.git
##

cd $VHOME


if [ $WEBRTC -eq 1 ]
then
  echo ">>>>>Build WebRTC"
  cd $VHOME
  [ -d "workspace/webrtc" ] && rm -rf workspace/webrtc
  mkdir -p $VHOME/workspace/webrtc && cd $VHOME/workspace/webrtc
  [ -d "depot_tools" ] && rm -rf depot_tools
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
  echo "export PATH=/home/vagrant/workspace/webrtc/depot_tools:\$PATH" >> $VHOME/.bashrc
  export PATH=/home/vagrant/workspace/webrtc/depot_tools:$PATH
  [ -d "src" ] && rm -rf src
  fetch webrtc
  cd src
  git checkout remotes/branch-heads/$WEBRTC_VERSION
  echo "checkout remotes/branch-heads/$WEBRTC_VERSION"
  gclient sync
  echo 'Y' | ./build/install-build-deps.sh
  gn gen out/debug --args='is_debug=true' --export-compile-commands
  gn desc out/debug :webrtc
  gn gen out/release --args='is_debug=false' --export-compile-commands
  gn desc out/release :webrtc

  ninja -C out/debug
  ninja -C out/release
  chown $USER:$GROUP -R $VHOME

fi

chown $USER:$GROUP -R $VHOME
cd $VHOME
