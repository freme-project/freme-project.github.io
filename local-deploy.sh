#!/bin/sh
#
# This script recompiles swagger-ui.js, builds the documentation site
# and copies it into the TARGET folder to ease testing with a local webserver.
#
# Prerequisites:
#  * npm
#  * jekyll
#
# For further information have a look at this knowledge base article in the build (_site) folder:
#   /knowledge-base/freme-for-developers/maintaining-the-documentation-project.html

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
