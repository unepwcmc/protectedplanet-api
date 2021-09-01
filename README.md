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

- Install correct ruby version using rbenv (see `.ruby-version`)
- Install bower `npm install -g bower`

```
- `git clone git@github.com:unepwcmc/protectedplanet-api.git`
- `cd protectedplanet-api`
- `bundle install`
- `bower install`
- Create .env file and copy contents from LastPass
- `rake db:create db:migrate # does nothing if db is already present`
- `rackup`
```

Now fire up your browser at `localhost:9292`!

## Further hints

This example demonstrates accessing an api_user from the terminal using irb.
```
$ RAILS_ENV=development bundle exec irb

> $LOAD_PATH.unshift("#{File.dirname(__FILE__)}"); require 'config/environment.rb'; require 'lib/mailer.rb'

=> true

2.3.0 :002 > ApiUser.first
```

## Troubleshooting

**An error occurred while installing pg (0.18.4), and Bundler cannot continue.**

Try running: `gem install pg -v '0.18.1' -- --with-cflags="-Wno-error=implicit-function-declaration"`