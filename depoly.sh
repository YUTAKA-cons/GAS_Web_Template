#!/bin/bash
set -eu

# ① 実行前のクリーンアップと、appscript.jsonの配置
rm -rf ./dist/.*.ts ./dist/*
cp -rf ./src/* ./dist/
cp appsscript.json ./dist

# ② コンバートスクリプトを実行し、 ./dist 内の所定のパスへ .html の拡張子でまとめて配置。
npx ts-node front-ts-converter.ts > ./dist/frontend/front.js.html

# ③ findでかかったCSSファイルを./dist/frontend 内に移動し、ファイル名末尾に .html を付与する
# 参考: https://neos21.net/blog/2021/06/02-01.html
find ./src/frontend/*.css -type f -maxdepth 1 \
  | sed "p;s/\(.*\)src\(\/.*\)$/\1dist\2.html/" \
  | xargs -n2 cp
rm ./dist/frontend/*.ts || :

npx clasp push

# get last deployment id
LAST_DEPLOYMENT_ID=$( clasp deployments | pcregrep -o1 '\- ([A-Za-z0-9\-\_]+) @\d+ - web app meta-version' )

if [ -z "$LAST_DEPLOYMENT_ID" ];then
    LAST_DEPLOYMENT_ID=$( clasp deployments | tail -1 | pcregrep -o1 '\- ([A-Za-z0-9\-\_]+)' ) 
fi


# deploy
clasp deploy --deploymentId $LAST_DEPLOYMENT_ID