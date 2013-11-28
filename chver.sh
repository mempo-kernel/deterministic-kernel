#!/bin/bash 
# Run in kernel-build/linux* 
# Usage: "./chver <kernel_version> <grsecurity_patch_name>" eg: "./chhver 3.2.52 grsecurity-3.0-3.2.52-201311242031.patch" 
# Works with only 3.2.x kernel version!!!

version=$1 
grsec=$2

# kernel-build ; kernel-sources 

set -x

mkdir -p kernel-sources/grsecurity 
mkdir -p kernel-sources/kernel

cd kernel-build/linux-3.2.51-securian-0.1.9-shell

mv ../linux-3.2.51-securian-0.1.9-shell ../linux-$version-securian-0.1.10-shell 
#cp sources.list sources.list.old 



# Kernel download
cd ../../kernel-sources/kernel #in kernel-sources/kernel:
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-$version.tar.xz 
unxz linux-$version.tar.xz 
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-$version.tar.sign 

# Grsecurity download
cd ../grsecurity #in kernel-sources/grsecurity
wget http://grsecurity.net/stable/$grsec 
wget http://grsecurity.net/stable/$grsec.sig 

# kernel-build/linux...shell
cd ../../kernel-build/linux-$version-securian-0.1.10-shell

# Kernel checkdeep
echo -e  "V,x,x,kernel,linux-$version.tar,sha256," > sources.list 
sha256deep -q ../../kernel-sources/kernel/linux-$version.tar >> sources.list 
echo -e "\n" >> sources.list 

# Grsecurity and deterministic patch checkdeeps 
echo -e  "P,x,x,grsecurity,$grsec,sha256," > sources.list
sha256deep -q ../../kernel-sources/grsecurity/$grsec >> sources.list
echo -e "\nP,x,x,securian,linux-3.2.51-deterministic-build2.diff,sha256,f784190d7099ad0c95d88a613c572a092a4039f368a0a0527c10276698192714" >> sources.list 

set +x
