#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rails new $1 \
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