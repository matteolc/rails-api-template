#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APPNAME=$1

rvm gemset create $APPNAME
rvm gemset use $APPNAME
gem install bundler --no-rdoc --no-ri
gem install rails --no-rdoc --no-ri
gem install foreman --no-rdoc --no-ri

rails new $APPNAME \
    -m https://raw.github.com/matteolc/rails-api-template/master/generator.rb \
    -d postgresql \
    --api

touch $APPNAME/.env   