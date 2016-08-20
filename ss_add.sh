#!/bin/bash

# jm33_m0

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

cat << EOF > ~/$user.json
{
    "server":"0.0.0.0",
    "method":"aes-256-cfb",
    "server_port":$port,
    "password":"$password"
}
EOF

log='/var/log/ss/'$user
echo 'nohup ssp-server -c ~/'$user'.json > '$log '&' >> ~/ss-run.sh

echo '[*] Now lets apply our changes and check if theres anything wrong...
'

killall ssp-server && nohup sh ~/ss-run.sh > /dev/null

netstat -anp | grep "0.0.0.0:$port" > /dev/null
if [ $? -eq 1 ]; then
    echo '
[-] Something went wrong...
'
else
    echo '
[+] Success!
'
fi
