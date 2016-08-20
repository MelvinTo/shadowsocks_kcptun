#!/bin/bash

# jm33_m0

path=~/ss/
if ! test -e ~/ss; then
    echo "
[*] Creating Shadowsocks folder at $path
"
    mkdir -p ~/ss
fi
if [ "$1" != "-i" ]; then
    if [ "$1" == '' ]; then
        echo '
[*] Usage: '$0' <-i> <user> <port> <password>
'
        exit 0
    fi
    user=$1
    port=$2
    password=$3
else
    echo '
[*] Now lets create a Shadowsocks user account
'
    echo -n 'Username: '
    read user
    echo -n 'Port: '
    read port
    echo -n 'Password: '
    read password
fi

if ! test -e /var/log/ss; then
    mkdir -p /var/log/ss
fi

cat << EOF > $path/$user.json
{
    "server":"0.0.0.0",
    "method":"aes-256-cfb",
    "server_port":$port,
    "password":"$password"
}
EOF

log='/var/log/ss/'$user
echo "nohup ssp-server -c $path/"$user'.json > '$log '&' >> $path/ss-run.sh && chmod 755 $path/ss-run.sh

echo '
[*] Now lets apply our changes and check if theres anything wrong...
'

killall ssp-server
nohup sh $path/ss-run.sh > /dev/null

netstat -anp | grep ":::$port" > /dev/null
if [ $? -eq 0 ]; then
    echo '
[-] Something went wrong...
'
else
    echo '
[+] Success!
'
fi
