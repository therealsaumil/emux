#!/bin/bash

set -e

echo [+] Starting tun0
sudo /etc/local.d/10-tun-network.start 2>&1 >/dev/null

echo [+] Starting NFS
sudo rpcbind -w
sudo rpcinfo
#sudo rpc.nfsd --no-nfs-version 2 --no-nfs-version 3 --nfs-version 4 --debug 4
sudo rpc.nfsd --debug 8
sudo rpc.nfsd --debug 8
sudo exportfs -rv
sudo exportfs
#sudo rpc.mountd --debug all --no-nfs-version 2 --no-nfs-version 3 --nfs-version 4
sudo rpc.mountd --debug all

echo '    _ ___ __  ___  __'
echo '   / \ _ \  \/ \ \/ /  by Saumil Shah | The ARM Exploit Laboratory'
echo '  / _ \  / |\/) )  (   @therealsaumil | armx.exploitlab.net'
echo ' /_/ \_\_\_| /_/_/\_\'
echo

export PS1="\u@armx-docker:\w\\$ "

exec "$@"
