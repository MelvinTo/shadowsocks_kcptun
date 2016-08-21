# Tools

- `ss_install.sh`

    用于服务器端的一键安装 `wget https://raw.githubusercontent.com/jm33-m0/gfw_scripts/master/ss_install.sh && bash ss_install.sh`

- `ss_add_api.sh`

    用于用户添加（通过HTTP API），只需要启动一个SSPlus进程，无需重启服务即可添加用户

    端口不能为`54320`，必须大于`1000`

- `ss_add.sh`

    同上，使用多进程运行SSPlus，需要重启服务

- `run-ssp.exe`

    Windows下的SSPlus客户端简单启动脚本

- `loadUserDatabase`

    用于用户管理
