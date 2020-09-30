#!/bin/bash
SH_PATH=$(cd "$(dirname "$0")";pwd)
cd ${SH_PATH}

create_mainfest_file(){
    echo "进行配置。。。"
    read -p "请输入你的应用名称：" IBM_APP_NAME
    echo "应用名称：${IBM_APP_NAME}"
    read -p "请输入你的应用内存大小(默认256)：" IBM_MEM_SIZE
    if [ -z "${IBM_MEM_SIZE}" ];then
	IBM_MEM_SIZE=256
    fi
    echo "内存大小：${IBM_MEM_SIZE}"
    
    UUID=$(cat /proc/sys/kernel/random/uuid)
    echo "生成随机UUID：${UUID}"
    SETINGSNAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5)
    FOLDERNAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5)
    RUNTIMENAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5)
    mkdir ${SH_PATH}/o5u7kmmf/install/${FOLDERNAME}
    
    
    cat >  ${SH_PATH}/o5u7kmmf/install/manifest.yml  << EOF
    applications:
    - path: .
      name: ${IBM_APP_NAME}
      random-route: true
      memory: ${IBM_MEM_SIZE}M
EOF

    cat >  ${SH_PATH}/o5u7kmmf/install/${FOLDERNAME}/${SETINGSNAME}.json  << EOF
    {
        "inbounds": [
            {
                "port": 8080,
                "protocol": "vmess",
                "settings": {
                    "clients": [
                        {
                            "id": "${UUID}",
                            "alterId": 4
                        }
                    ]
                },
                "streamSettings": {
                    "network":"ws",
                    "wsSettings": {
                        "path": ""
                    }
                }
            }
        ],
        "outbounds": [
            {
                "protocol": "freedom",
                "settings": {}
            }
        ]
    }
EOF

    cat >  ${SH_PATH}/o5u7kmmf/install/${FOLDERNAME}/${RUNTIMENAME}.sh  << EOF
        #!/bin/bash

        cd bin
        mkdir .cache
        cd .cache
        wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
        unzip v2ray-linux-64.zip
        cp ./v2ray ../run
        cp ./v2ctl ../
        cd ..
        rm -rf .cache

        chmod +x *
        ./run -c ${SETINGSNAME}.json
EOF

    cat >  ${SH_PATH}/o5u7kmmf/install/Procfile  << EOF
    web: ./${FOLDERNAME}/${RUNTIMENAME}.sh 
EOF

     echo "配置完成。"
}

clone_repo(){
    echo "进行初始化。。。"
    git clone https://github.com/xwtfDufZ25NT/o5u7kmmf
    cd o5u7kmmf
    git submodule update --init --recursive
    cd install/${FOLDERNAME}
    chmod +x *
    cd ${SH_PATH}/o5u7kmmf/install
    echo "初始化完成。"
}

installv(){
    echo "进行安装。。。"
    cd ${SH_PATH}/o5u7kmmf/install
    ibmcloud target --cf
    ibmcloud cf install
    ibmcloud cf push
    echo "安装完成。"
}

clone_repo
create_mainfest_file
installv

exit 0
