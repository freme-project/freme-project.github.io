#!/bin/sh

# modify this:
TARGET="C:/xampp/tomcat/webapps/doc/"

cd swagger/_swagger-ui
# do this just one time:
#npm install 
npm run build
cp dist/swagger-ui.js ..
cp dist/swagger-ui.min.js ..
cd ../..
jekyll build

rm -r $TARGET
mkdir $TARGET
cp -r _site/. $TARGET
