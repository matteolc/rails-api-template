# Rails-React-Template
This template creates a Ruby on Rails backend API application and a React frontend client application, 
built with simplicity and light-weight in mind.

## Backend

+ Standard JSON-API server backed by [JSON API Resources](http://jsonapi-resources.com)
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
+ Ready to be plugged in production to [Sidekiq](https://github.com/mperham/sidekiq)

## Frontend

+ Bootstrapped with `create-react-app` for [React](https://reactjs.org/) 16
+ Uses [Admin-On-Rest](https://github.com/marmelab/admin-on-rest)
+ Uses [Material UI](http://www.material-ui.com)
+ Provides a JWT authorization client to use with AOR
+ Provides a JSON-API REST client to use with AOR

# Requirements

+ **Ruby** 2.4.2. Rails 5.1.4 will be installed by `bundler`.
+ **Postgresql** 9.6
+ **Node** 8.3.0. React 16 will be installed by `yarn`

# Usage

```
gem install \
    bundler \
    rails \
    foreman \
    thor \
    --no-rdoc --no-ri
```

```
rails new myapi \
    -m https://raw.github.com/matteolc/rails-api-template/master/generator.rb \
    -d postgresql \
    --api
```    

```
cd myapi
foreman start
```               

```
cd myapi/public/app
yarn start
```