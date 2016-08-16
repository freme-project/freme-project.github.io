#!/bin/sh
#
# This script re-compiles swagger-ui.js and builds the documentation site.
#
# Prerequisites:
#  * npm
#  * jekyll
#
# For further information have a look at this knowledge base article in the build (_site) folder:
#   /knowledge-base/freme-for-developers/maintaining-the-documentation-project.html


cd swagger/_swagger-ui
# do this just one time:
#npm install
npm run build
cp dist/swagger-ui.js ..
cp dist/swagger-ui.min.js ..
cd ../..
#jekyll serve

