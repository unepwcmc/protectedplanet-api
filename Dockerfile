FROM ruby:2.7.8-bullseye

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

RUN mkdir /ProtectedPlanetApi
WORKDIR /ProtectedPlanetApi
ADD Gemfile /ProtectedPlanetApi/Gemfile
ADD Gemfile.lock /ProtectedPlanetApi/Gemfile.lock
ADD config.ru /ProtectedPlanetApi/config.ru
RUN gem install bundler -v 2.4.22 && bundle _2.4.22_ install
COPY . /ProtectedPlanetApi
EXPOSE 9292
CMD ["rackup"]