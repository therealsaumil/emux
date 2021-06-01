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

#echo [+] Starting tinyproxy
#sudo tinyproxy
echo "[+] Setting up forwarded ports ${PORTFWD}"

IFS=',' read -ra PORTLIST <<< "${PORTFWD}"
for PORTPAIR in "${PORTLIST[@]}"
do
   SPORT=$(echo ${PORTPAIR} | cut -d':' -f1)
   DPORT=$(echo ${PORTPAIR} | cut -d':' -f2)
   echo "[+] mapping port ${SPORT} -> 192.168.100.2:${DPORT}"
   socat TCP-LISTEN:${SPORT},fork,reuseaddr TCP:192.168.100.2:${DPORT} &
done

echo '    _ ___ __  ___  __'
echo '   / \ _ \  \/ \ \/ /  by Saumil Shah | The ARM Exploit Laboratory'
echo '  / _ \  / |\/) )  (   @therealsaumil | armx.exploitlab.net'
echo ' /_/ \_\_\_| /_/_/\_\'
echo

export PS1="\u@armx-docker:\w\\$ "

exec "$@"
