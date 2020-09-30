#!/bin/bash
SH_PATH=$(cd "$(dirname "$0")";pwd)
USERNAME="xwtfDufZ25NT"
PJNAME="o5u7kmmf"
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
    BINNAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5)
    mkdir ${SH_PATH}/${PJNAME}/install/${FOLDERNAME}
    
    echo “下載工具組中...”
        mkdir .cache
        cd .cache
        wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
        unzip v2ray-linux-64.zip
        cp ./v2ray ../
        cp ./v2ctl ../
        cd ..
        chmod +x *
        rm -rf .cache
    echo “下載完畢.”
    
    
    cat >  ${SH_PATH}/${PJNAME}/install/manifest.yml  << EOF
    applications:
    - path: .
      name: ${IBM_APP_NAME}
      random-route: true
      memory: ${IBM_MEM_SIZE}M
EOF

    ./v2ctl config stdin: << EOF | base64 > ${SH_PATH}/${PJNAME}/install/${FOLDERNAME}/${SETINGSNAME}
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

    cat >  ${SH_PATH}/${PJNAME}/install/${FOLDERNAME}/${RUNTIMENAME}.sh  << EOF
        #!/bin/bash

        cd bin
        mkdir .cache
        cd .cache
        wget -O t.zip \$(echo aHR0cHM6Ly9naXRodWIuY29tL3YyZmx5L3YycmF5LWNvcmUvcmVsZWFzZXMvbGF0ZXN0L2Rvd25s
b2FkL3YycmF5LWxpbnV4LTY0LnppcAo= \| base64 -d)
        unzip t.zip
        chmod 777 *
        cp ./\$(echo djJyYXkK \| base64 -d) ../${BINNAME}
        cd ..
        rm -rf .cache

        chmod +x *
        
        ./${BINNAME} -format pb -config stdin: << base64 -d ${SETINGSNAME}
EOF

    cat >  ${SH_PATH}/${PJNAME}/install/Procfile  << EOF
    web: ./${FOLDERNAME}/${RUNTIMENAME}.sh 
EOF

     echo "配置完成。"
}

clone_repo(){
    echo "进行初始化。。。"
    git clone https://github.com/${USERNAME}/${PJNAME}
    cd ${PJNAME}
    git submodule update --init --recursive
    cd install/${FOLDERNAME}
    chmod +x *
    cd ${SH_PATH}/${PJNAME}/install
    echo "初始化完成。"
}

installv(){
    echo "进行安装。。。"
    cd ${SH_PATH}/${PJNAME}/install
    ibmcloud target --cf
    ibmcloud cf install
    ibmcloud cf push
    echo "安装完成。"
}

clone_repo
create_mainfest_file
installv

exit 0
