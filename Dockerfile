FROM ruby:4.0.2-slim

# build-essential: compile native gems (e.g. puma, pg, rgeo). libpq-dev: pg gem.
# libssl-dev / zlib1g-dev: common deps for extensions linking OpenSSL/zlib.
# libyaml-dev: psych (via debug → irb → rdoc) needs yaml.h; slim image omits it.
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libssl-dev \
  libpq-dev \
  libyaml-dev \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler -v 4.0.9 && bundle install
COPY . /app
RUN chmod +x /app/bin/docker-dev-server
EXPOSE 9292

# Run the script via /bin/sh so it works when ${API_PATH}:/app bind-mounts replace the image:
# the host checkout may not have +x on bin/*. (Direct exec would need chmod on the host.)
CMD ["/bin/sh", "/app/bin/docker-dev-server"]