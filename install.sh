#!/bin/bash
set -e

echo "start"

# 时区修改为上海
if [[ ! -x '/etc/localtime' ]]; then
    unlink /etc/localtime;
fi
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "download server"
CODE_SERVER_PATH="/programschool/server"
mkdir -p $CODE_SERVER_PATH && cd $CODE_SERVER_PATH
curl -sSLk https://build.boxlayer.com/code-server.tar.gz -o code-server.tar.gz
mkdir -p ./code-server && tar -zxf code-server.tar.gz -C ./code-server --strip-components 1
rm code-server.tar.gz
chmod 755 code-server
#echo $WORKSPACE > workspace

# 设置默认用户
echo "add user"
USERHOME="/home/ubuntu"
if [[ ! -x "$USERHOME" ]]; then
    useradd ubuntu -b /home -m -p '$6$W9vAPAalRhxbEnnM$NmWqhDDRsXOmwjcd6zpiBQslI.xocZha0NmA0psV5U.zHDa9tNFsGDBx6WihoYvtuzXSn9CMQizP1hIEiaFJz1' -s /bin/bash -g root
else
    useradd ubuntu -b /home -M -p '$6$W9vAPAalRhxbEnnM$NmWqhDDRsXOmwjcd6zpiBQslI.xocZha0NmA0psV5U.zHDa9tNFsGDBx6WihoYvtuzXSn9CMQizP1hIEiaFJz1' -s /bin/bash -g root
fi

echo "add user to root group"
echo -e "\n ubuntu ALL=(ALL)     ALL" >> /etc/sudoers

locale-gen en_US.UTF-8

# 安装中文扩展
echo "install zh-cn extension"
su -l ubuntu -c "/programschool/server/code-server/bin/code-server --install-extension ms-ceintl.vscode-language-pack-zh-hans"

echo "write locale.json"
mkdir -p /home/ubuntu/.local/share/code-server/User
echo -e "{\n\t\"locale\": \"zh-cn\"\n}" > /home/ubuntu/.local/share/code-server/User/locale.json
chown -R ubuntu:root /home/ubuntu

exit 0
