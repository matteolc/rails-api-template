# Usage
To apply a template, you need to provide the Rails generator with the location of the template you wish to apply using the -m option. This can either be a path to a file or a URL.

    rails new blog \
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
                   