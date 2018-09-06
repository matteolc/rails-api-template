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

## Authentication

Authentication is performed using JSON Web Tokens. JSON Web Tokens are an open, industry standard [https://tools.ietf.org/html/rfc7519](RFC 7519) method for representing claims securely between two parties. When the user successfully logs in using their credentials, a JSON Web Token will be returned, which should be kept by clients in
local storage:

```
"token":"eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1MzYyMjU5NDUsImV4cCI6MTUzNjMxMjM0NSwic3ViIjoiMzdjMDY2ZjgtNDhjMS00NDZjLTk4OGQtYzQ0ZDQ4MDJiNzZmIiwicm9sZXMiOlsiYWRtaW4iXX0.UwqjX27pGJHJoGjCMkLhBnwoszb9d590upnkRFM0LaA"}
```

Whenever the user wants to access a protected route or resource, the user agent should send the JWT in the Authorization header using the Bearer schema: 

`Authorization: Bearer <token>`

The following routes are available for authorization:

+ `POST /api/v1/login?username=user&password=12345678`
+ `DELETE /api/v1/logout`
+ `POST /api/v1/signup?email=user@example.com&username=user&password=12345678&password_confirmation=12345678`

The JWT spec supports NONE, HMAC, RSASSA, ECDSA and RSASSA-PSS algorithms for cryptographic signing. Currently the JWT uses HMAC using SHA-256 algorithm.
To generate an HMAC you need a signiging secret in an environment variable called `JWT_SECRET`.

JSON Web Token defines some reserved claim names and defines how they should be used. JWT supports these reserved claim names:

 - 'exp' (Expiration Time) Claim
 - 'iat' (Issued At) Claim
 - 'sub' (Subject) Claim
 - 'roles' (Roles) Claim

### Expiration Time Claim

From [Oauth JSON Web Token 4.1.4. "exp" (Expiration Time) Claim](https://tools.ietf.org/html/rfc7519#section-4.1.4):

> The `exp` (expiration time) claim identifies the expiration time on or after which the JWT MUST NOT be accepted for processing. The processing of the `exp` claim requires that the current date/time MUST be before the expiration date/time listed in the `exp` claim. Implementers MAY provide for some small `leeway`, usually no more than a few minutes, to account for clock skew. Its value MUST be a number containing a ***NumericDate*** value. Use of this claim is OPTIONAL.

The default expiry value is set to 1 day.

### Issued At Claim

From [Oauth JSON Web Token 4.1.6. "iat" (Issued At) Claim](https://tools.ietf.org/html/rfc7519#section-4.1.6):

> The `iat` (issued at) claim identifies the time at which the JWT was issued. This claim can be used to determine the age of the JWT. The `leeway` option is not taken into account when verifying this claim. The `iat_leeway` option was removed in version 2.2.0. Its value MUST be a number containing a ***NumericDate*** value. Use of this claim is OPTIONAL.

### Subject Claim

From [Oauth JSON Web Token 4.1.2. "sub" (Subject) Claim](https://tools.ietf.org/html/rfc7519#section-4.1.2):

> The `sub` (subject) claim identifies the principal that is the subject of the JWT. The Claims in a JWT are normally statements about the subject. The subject value MUST either be scoped to be locally unique in the context of the issuer or be globally unique. The processing of this claim is generally application specific. The sub value is a case-sensitive string containing a ***StringOrURI*** value. Use of this claim is OPTIONAL.

This claim contains the `UUID` of the user.

### Roles Claim

This custom claim contains the (names of the) roles assigned to the user.

## Authorization

## JSON API

## Caching

## Fulltext Search

## Excel

## PDF

## Background Job Processor & Scheduler

## Email
