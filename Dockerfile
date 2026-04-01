FROM ruby:3.2.4

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
RUN gem install bundler -v 2.4.22 && bundle _2.4.22_ install
COPY . /app
EXPOSE 9292
CMD ["rackup"]