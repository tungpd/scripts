#vim build and installation
#hg clone https://code.google.com/p/vim/
#cd vim
#./configure --with-features=huge \
#            --enable-multibyte \
#            --enable-pythoninterp \
#            --with-python-config-dir=/usr/local/python-2.7.10/lib/python2.7/config/ \
#            --enable-gui=gtk2 --enable-cscope --prefix=/usr/local \
#	    --enable-conceal

#install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo 'execute pathogen#infect()\n' >> ~/.vimrc
echo 'syntax on\n' >> ~/.vimrc
echo 'filetype plugin indent on\n' >> ~/.vimrc

#install scriptease
#install sensible
cd ~/.vim/bundle && \
git clone git://github.com/tpope/vim-sensible.git
#install jedit
