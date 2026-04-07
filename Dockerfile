FROM ruby:4.0.2

RUN apt-get update && apt-get install -y \
  autoconf \
  bison \
  build-essential \
  curl \
  git \
  libreadline-dev \
  libssl-dev \
  libpq-dev \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY config.ru /app/config.ru
RUN gem install bundler -v 4.0.9 && bundle install
COPY . /app
RUN chmod +x /app/bin/docker-dev-server
EXPOSE 9292

CMD ["/app/bin/docker-dev-server"]