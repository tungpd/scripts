#install readline
sudo yum install ncurses-devel.x86_64
sudo pip install readline
#
echo 'import rlcompleter, readline\n' >> ~/.pythonrc
echo 'readline.parse_and_bind("tab:complete")' >> ~/.pythonrc
echo "export PYTHONSTARTUP=~/.pythonrc" >> ~/.bashrc
source ~/.bashrc

