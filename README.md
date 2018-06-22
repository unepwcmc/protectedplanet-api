# Protected Planet API

This is the repository for the official Protected Planet API. If you are interested in consuming the API, head to [the API documentation](http://api.protectedplanet.net/documentation). If you are a developer and intend contributing to the API codebase, keep reading.

## The stack

The Protected Planet API is a Rack application, written in Ruby. It is composed of two sections, each handled by a different framework.

* `/api/**/*`: [Grape](https://github.com/ruby-grape/grape)
* `/web/**/*`: [Sinatra](http://www.sinatrarb.com/)

The two frameworks are then cascaded inside Rack, in the [config.ru](/config.ru) file:

```
require ‘api/root’
require ‘web/root’
[…]
run Rack::Cascade.new [Web::Root, API::Root]
```

Both frameworks share a bunch of`ActiveRecord` models, which form a subset of the [ProtectedPlanet models](https://github.com/unepwcmc/ProtectedPlanet/tree/master/app/models), with the addition of the `ApiUser` model.

The API uses [RABL](https://github.com/nesquena/rabl) and [grape-rabl](https://github.com/ruby-grape/grape-rabl/) for views, while Sinatra renders ERB and markdown for the documentation.

The design is implemented in the bower package [protectedplanet-frontend](https://github.com/unepwcmc/protectedplanet-frontend), which makes possible to share exactly the same style between this project and ProtectedPlanet itself.

Finally, the `db` folder is a git submodule, linked to [protectedplanet-db](https://github.com/unepwcmc/protectedplanet-db). More on this in the _Development_ section.

## Installation

The installation process is quite standard:

```
$ git clone git@github.com:unepwcmc/protectedplanet-api.git
$ cd protectedplanet-api
$ bundle install
[…]
$ rake db:create db:migrate # does nothing if db is already present
$ rackup
```

Now fire up your browser at `localhost:9292`!

## Development

The `rails c` of the rack world...

```
bundle exec rack-console
```

Then make an api user (assuming you also have the PP database set up)

```
user = ApiUser.create(email: "test@test.com", full_name: "Test")
user.activate!
```

Retrieve your token with `user.token`

