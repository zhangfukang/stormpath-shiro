#! /bin/bash
#
# Copyright 2012 Stormpath, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


GIT_AUTHOR_EMAIL="evangelists@stormpath.com"
GIT_AUTHOR_NAME="stormpath-shiro Auto Doc Build"

echo "publishing docs for: $PROJECT_VERSION"
git clone git@github.com:stormpath/stormpath.github.io.git
cd stormpath.github.io
git config user.email "$GIT_AUTHOR_EMAIL"
git config user.name "$GIT_AUTHOR_NAME"
git fetch origin source:source
git checkout source

echo "Copying over servlet plugin docs"
rm -rf source/java/shiro-servlet-plugin/
cp -r ../extensions/servlet/docs/build/html source/java/shiro-servlet-plugin
cp -r ../extensions/servlet/docs/build/html source/java/shiro-servlet-plugin/latest
cp -r ../extensions/servlet/docs/build/html source/java/shiro-servlet-plugin/$PROJECT_VERSION

echo "Copying over javadocs"
rm -rf source/java/shiro/apidocs
cp -r ../target/site/apidocs source/java/shiro-apidocs
cp -r ../target/site/apidocs source/java/shiro-apidocs/latest
cp -r ../target/site/apidocs source/java/shiro-apidocs/$PROJECT_VERSION

git add --all
git commit -m "stormpath-sdk-java release $PROJECT_VERSION"
ls -la source/java/servlet-plugin
#git push origin source
gem install bundler
bundle install
rake setup_github_pages[git@github.com:stormpath/stormpath.github.io.git]
cd _deploy
git config user.email "$GIT_AUTHOR_EMAIL"
git config user.name "$GIT_AUTHOR_NAME"
git pull --no-edit -s recursive -X theirs https://github.com/stormpath/stormpath.github.io.git
cd ..
rake generate > /tmp/docs_generate.log
cd _deploy
git pull --no-edit -s recursive -X theirs https://github.com/stormpath/stormpath.github.io.git
cd ..
#rake deploy
cd ..
