#!/bin/bash

# jm33_m0

if ! test -e ~/ss; then
    echo "
[*] Creating Shadowsocks folder at $path ...
"
    mkdir -p ~/ss
fi
path=~/ss

# Check if our SSP instance is running fine, if not, launch it
ps -ef | grep "ssp-server" > /dev/null
if [ ! $? -eq 0 ]; then
    echo "[-] SSP is not running, running $path/ss-run.sh for you..."
    bash $path/ss-run.sh
fi

if [ "$1" != "-i" ]; then
    if [ "$1" == '' ]; then
        echo '
[*] Usage: '$0' <-i> <user> <port> <password> <http api key>
'
        exit 0
    fi
    user=$1
    port=$2
    password=$3
	apiKey=$4
else
    echo '
[*] Now lets create a Shadowsocks user account
'
    echo -n 'Username: '
    read user
    echo -n 'Port: (> 1000)'
    read port
    if [ "$port" == "54320" ]; then
        echo -n "
[-] Can't use this port, you have to change it: "
        read port
    fi
    echo -n 'Password: '
    read password
    echo -n "
SSPlus HTTP API Key
(the one that you set up before with ss_intall.sh): "
	read apiKey
fi

#if ! test -e /var/log/ss; then
#    mkdir -p /var/log/ss
#fi

cat << EOF >> $path/users.cfg
$user:$port:$password
EOF

echo '
[*] Now lets apply our changes and check if theres anything wrong...
'

/usr/bin/loadUserDatabase $path/users.cfg 127.0.0.1:5333 $apiKey

netstat -anp | grep ":::$port" > /dev/null
if [ ! $? -eq 0 ]; then
    echo '
[-] Something went wrong...
'
else
    echo '
[+] Success!
'
fi
