#!/bin/bash
SH_PATH=$(cd "$(dirname "$0")";pwd)
cd ${SH_PATH}

install(){
    echo "进行安装。。。"
    cd ${SH_PATH}/o5u7kmmf/install
    ibmcloud target --cf
    ibmcloud cf install
    ibmcloud cf push
    echo "安装完成。"
}

install
exit 0

