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
codeVersion=$(curl -sl https://build.boxlayer.com/update | grep code)
curl -sSLk https://build.boxlayer.com/$codeVersion -o code-server.tar.gz
mkdir -p ./code-server && tar -zxf code-server.tar.gz -C ./code-server --strip-components 1
rm code-server.tar.gz
chmod 755 code-server
#echo $WORKSPACE > workspace

# 设置默认用户
echo "add user"
rm -rf /home/ubuntu
useradd ubuntu -b /home -m -p "" -s /bin/bash -g root

chown -R ubuntu:root /home/ubuntu # 如果开发者穿件 ubuntu 目录则需要设置权限

echo "add user to root group"
echo -e "\n ubuntu ALL=(ALL)     ALL" >> /etc/sudoers

locale-gen en_US.UTF-8

echo "write locale.json"
mkdir -p /home/ubuntu/.local/share/code-server/User
echo -e "{\n\t\"locale\": \"zh-cn\"\n}" > /home/ubuntu/.local/share/code-server/User/locale.json
curl -sl https://build.boxlayer.com/languagepacks.json -o /home/ubuntu/.local/share/code-server/languagepacks.json

chown -R ubuntu:root /home/ubuntu
# 安装中文扩展
echo "install zh-cn extension"

su ubuntu
/programschool/server/code-server/bin/code-server --force --install-extension ms-ceintl.vscode-language-pack-zh-hans
exit

echo "install run command"

mkdir /programschool/execute
cd /programschool/execute
mkdir bin output source
curl -sl https://build.boxlayer.com/run.sh -o run.sh
curl -sl https://build.boxlayer.com/pjson.py -o pjson.py
chmod 555 run.sh pjson.py

exit 0
