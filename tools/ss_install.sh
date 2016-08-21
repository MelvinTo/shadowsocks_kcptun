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

# Download user manager
if ! test -e /usr/bin/loadUserDatabase; then
    curl -k -o /usr/bin/loadUserDatabase "https://raw.githubusercontent.com/jm33-m0/gfw_scripts/master/userManager/loadUserDatabase" && chmod 755 /usr/bin/loadUserDatabase
fi

# Download ssp-server and install it to /usr/bin
curl -k -o ssp-server  https://raw.githubusercontent.com/shadowsocks-plus/shadowsocks-plus/master/server && chmod 755 ssp-server && cp ssp-server /usr/bin/

if test -e /usr/bin/ssp-server; then
    echo '[+] Installation was succeed
    '
else
    echo '[-] Failed to install
    '
    exit 1
fi

# Download ss_add_api.sh to add first Shadowsocks-Plus user and launch a base ssp instance with HTTP API
echo '[*] Lets create our first Shadowsocks user account
'
url="https://raw.githubusercontent.com/jm33-m0/gfw_scripts/master/ss_add_api.sh"
if ! test -e ./ss_add.sh; then
    curl -k -o ss_add.sh $url && chmod 755 ss_add_api.sh
fi

$path=~/ss
echo -n "[*] Setup an API key for further user management with ss_add_api.sh: "
read $api_key

cat << EOF > $path/config.json
{
    "server":"0.0.0.0",
    "method":"aes-256-cfb",
    "server_port":54320,
    "password":"doNotTouch"
}

# start instance
grep "-hkey $api_Key" $path/ss-run.sh > /dev/null
if [ ! $? -eq 0 ]; then
	echo "nohup ssp-server -c $path/config.json -api 127.0.0.1:5333 -hkey $api_key > /dev/null &" > $path/ss-run.sh
	chmod 755 $path/ss-run.sh
	bash $path/ss-run.sh
fi

# Run ss_add to add a user
bash ss_add_api.sh -i
