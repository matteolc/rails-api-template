#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APPNAME=$1

rvm gemset create $APPNAME
rvm gemset use $APPNAME
gem install bundler --no-rdoc --no-ri
gem install rails --no-rdoc --no-ri

rails new $APPNAME \
    -m https://raw.github.com/matteolc/rails_api_template/master/rails_api_generator.rb \
    -d postgresql \
    --skip-yarn \
    --skip-action-cable \
    --skip-sprockets \
    --skip-spring \
    --skip-coffee \
    --skip-javascript \
    --skip-turbolinks \
    --skip-bundle