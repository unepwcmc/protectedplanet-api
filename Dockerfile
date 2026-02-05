FROM ruby:2.3.6

# Buster is EOL, so point APT to Debian archive mirrors before updating
RUN printf 'deb http://archive.debian.org/debian buster main\n\
deb http://archive.debian.org/debian buster-updates main\n\
deb http://archive.debian.org/debian-security buster/updates main\n' > /etc/apt/sources.list \
    && printf 'Acquire::Check-Valid-Until \"0\";\nAcquire::Retries \"3\";\nAPT::Get::AllowUnauthenticated \"true\";\n' > /etc/apt/apt.conf.d/99no-check-valid \
    && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Check-Valid-Until=false update
RUN apt-get install -y --allow-unauthenticated \
  autoconf \
  bison \
  build-essential \
  curl \
  git \
  libreadline-dev \
  libssl-dev \
  libpq-dev \
  nodejs \
  zlib1g-dev

# install npm
RUN apt-get install -y --allow-unauthenticated -qq npm
RUN mkdir /ProtectedPlanetApi
WORKDIR /ProtectedPlanetApi
ADD Gemfile /ProtectedPlanetApi/Gemfile
ADD Gemfile.lock /ProtectedPlanetApi/Gemfile.lock
ADD config.ru /ProtectedPlanetApi/config.ru
RUN gem install bundler -v 1.12.5 && bundle _1.12.5_ install
COPY . /ProtectedPlanetApi
EXPOSE 9292
CMD ["rackup"]