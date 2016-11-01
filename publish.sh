#! /bin/bash

webpack
echo 'webpack done!'

rm -rf publish
mkdir -p publish/demo/javascript
cp -r demo/images publish/demo
cp -r demo/stylesheet publish/demo
cp -r demo/javascript/dist publish/demo/javascript/
mkdir publish/sdk
cp -r sdk/dist publish/sdk
mkdir publish/webrtc
cp -r webrtc/dist publish/webrtc
cp favicon.ico publish/
cp index.html publish/
cp CHANGELOG.md publish/

rm publish/demo/javascript/dist/webim.config.js.demo

file_conf="./demo/javascript/dist/webim.config.js"


# windowSDK: delete webRTC associated files
isWindowSDK=`grep 'isWindowSDK' ./demo/javascript/dist/webim.config.js |awk -F ':' '{printf("%s",$2)}' |awk -F ',' '{printf("%s",$1)}'`
echo isWindowSDK=${isWindowSDK##* }
if [ ${isWindowSDK##* } == 'true' ]
then
    rm -rf publish/webrtc
    sed -i '32,38d' publish/index.html
fi

# not debug mode: 1.delete debug.js, 2.strophe.js->strophe-1.2.8.min.js
isDebug=`grep 'isDebug' ./demo/javascript/dist/webim.config.js |awk -F ':' '{printf("%s",$2)}' |awk -F ',' '{printf("%s",$1)}'`
echo isDebug=${isDebug##* }
if [ ${isDebug##* } == 'false' ]
then
    rm publish/demo/javascript/dist/debug.js
    rm publish/sdk/dist/strophe.js
    sed -i '28d' publish/index.html
    sed -i '22,25d' publish/index.html
fi

if [ ${isWindowSDK##* } == 'false' ]
then
    sed -i '19,21d' publish/index.html
fi

echo 'publish done!'
