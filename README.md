# Rails-API-Template
This template creates a Ruby on Rails API application with the following features:

+ Standard JSON API server using [JSON API Resources](http://jsonapi-resources.com)
+ Use `UUID` instead of integer IDs by default in migrations
+ Standard `has_secure_password` extension used for storing user passwords
+ Multiple roles available per user backed by [Rolify](https://github.com/RolifyCommunity/rolify)
+ Authorization of REST actions backed by [Pundit](https://github.com/elabs/pundit)
+ Use `memcached` as underlying cache store
+ Custom `has_secure_tokens` extension used in conjuction with [JSON Web Tokens](https://jwt.io/) for managing and verifying user tokens
+ An `authorization` controller concern and a `sessions_controller` to handle JWT authentication and authorization
+ A `registrations_controller` to handle user registrations
+ A `has_fulltext_search` extension backed by [PGSearch](https://github.com/Casecommons/pg_search) used to leverage PostgreSQL’s full text search
+ A production ready Puma configuration
+ Rspec and FactoryBot for testing
+ A template for [Rollbar](https://rollbar.com) exception monitoring (should be used in production only)
+ A template for [New Relic](https://www.newrelic.com) application monitoring

Included support for (TBD):

+ Excel
+ PDF
+ Background jobs & scheduling
+ Email
+ Networking tools
+ Reporting tools
+ ISO-compliant countries and exchange-rates information

# Requirements

+ **Ruby**
+ **PostgreSQL**
+ **Memcached**

# Usage

```
gem install \
    bundler \
    rails \
    foreman \
    --no-rdoc \
    --no-ri
```

```
rails new myapi \
    -m https://raw.github.com/matteolc/rails-api-template/master/template.rb \
    -d postgresql \
    --api
```    

```
cd myapi
rspec
foreman start
```               