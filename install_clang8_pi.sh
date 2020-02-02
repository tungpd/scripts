#!/bin/bash
set -e
# install clang toolchains on raspberrian

cd /tmp
# wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
# apt-add-repository 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main'
apt-get update
cd $VHOME
apt-get install -y libllvm-8-ocaml-dev libllvm8 llvm-8 llvm-8-dev llvm-8-doc llvm-8-examples llvm-8-runtime
apt-get install -y clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 python-clang-8 
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


