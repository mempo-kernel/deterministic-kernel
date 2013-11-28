#!/bin/bash 
# On deterministic-kernel

set -x 
mkdir -p kernel-sources/kernel
cd kernel-sources/kernel
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.52.tar.xz 
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.52.tar.sign 
unxz linux-3.2.52.tar.xz
chmod 755 linux-3.2.52.tar* 

cd .. 
mkdir -p grsecurity 
cd grsecurity 
wget http://grsecurity.net/stable/grsecurity-3.0-3.2.52-201311261520.patch 
wget http://grsecurity.net/stable/grsecurity-3.0-3.2.52-201311261520.patch.sig
chmod 755 grsecurity-3.0-3.2.52-201311261520.patch*

cd ../.. 

#deterministic-kernel

cd kernel-build/linux-3.2.52-securian-0.1.10-shell 
faketime "2013-11-26 15:21:00" ./all.sh
set +x
