#!/bin/bash

# jm33_m0

echo '
[+] Welcome!
    I will guide you through the installation of Shadowsocks-Plus on your Linux server
    Also, if you wanna add some users later, I will download another script called ss_add.sh, you might wanna use it in the future
'

echo '[*] Installing Shadowsocks-Plus...
'
if test -e /usr/bin/ssp-server; then
    echo '[*] Shadowsocks-Plus has already been installed
    '
    exit 0
fi

curl -k -o ssp-server  https://raw.githubusercontent.com/shadowsocks-plus/shadowsocks-plus/master/server && chmod 755 ssp-server && cp ssp-server /usr/bin/

if test -e /usr/bin/ssp-server; then
    echo '[+] Installation was succeed
    '
else
    echo '[-] Failed to install
    '
    exit 1
fi

echo '[*] Lets create our first Shadowsocks user account
'
url="https://raw.githubusercontent.com/jm33-m0/gfw_scripts/master/ss_add.sh"
if ! test -e ./ss_add.sh; then
    curl -k -o ss_add.sh $url && chmod 755 ss_add.sh
fi
bash ss_add.sh -i
