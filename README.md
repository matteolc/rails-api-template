# Rails-API-Template
This template creates a Ruby on Rails API application.

## Backend

+ Standard JSON-API server using [JSON API Resources](http://jsonapi-resources.com)
+ Use `UUID` instead of integer IDs by default in migrations
+ Standard `has_secure_password` extension used for storing user passwords
+ Multiple roles available per user, backed by [Rolify](https://github.com/RolifyCommunity/rolify)
+ Authorization of REST actions backed by [Pundit](https://github.com/elabs/pundit)
+ Custom `has_secure_tokens` extension used in conjuction with [JSON Web Tokens](https://jwt.io/) for managing and verifying user tokens
+ An `authorization` controller concern and a `sessions_controller` to handle JWT authentication and authorization
+ A `registrations_controller` to handle user registrations
+ Easy `has_fulltext_search` extension backed by [PGSearch](https://github.com/Casecommons/pg_search) used to leverage PostgreSQL’s full text search
+ Integration of client full-text search with JSONAPI-Resources
+ Provide a production ready Puma configuration
+ Provide a template for [Rollbar](https://rollbar.com) reporting (should be used in production only)
+ Provides connection to New Relic
+ Uses Memcached as underlying cache store

# Requirements

+ **Ruby** 2.4.2
+ **Rails** 5.2.1
+ **Postgresql** 9.6
+ **Memcached**

# Usage

```
gem install \
    bundler \
    rails \
    foreman \
    thor \
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
foreman start
```               