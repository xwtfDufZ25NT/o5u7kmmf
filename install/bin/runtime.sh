#!/bin/bash

cd bin
rm -rf .cache
mkdir .cache
cd .cache
wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
cp ./v2ray ../run
cp ./v2ctl ../
cd ..

chmod +x *
./run -c config.json
