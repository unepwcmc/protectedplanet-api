FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
  autoconf \
  bison \
  build-essential \
  curl \
  git \
  libreadline-dev \
  libssl1.0-dev \
  libpq-dev \
  nodejs \
  zlib1g-dev

ENV RBENV_ROOT /usr/local/src/rbenv

ENV PATH ${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH

RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} \
  && git clone https://github.com/rbenv/ruby-build.git \
    ${RBENV_ROOT}/plugins/ruby-build \
  && ${RBENV_ROOT}/plugins/ruby-build/install.sh \
  && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN rbenv install 2.3.0 \
    && rbenv global 2.3.0

# install npm
RUN apt-get install -y --force-yes -qq npm
RUN mkdir /ProtectedPlanetApi
WORKDIR /ProtectedPlanetApi
ADD Gemfile /ProtectedPlanetApi/Gemfile
ADD Gemfile.lock /ProtectedPlanetApi/Gemfile.lock
ADD config.ru /ProtectedPlanetApi/config.ru
RUN gem install bundler -v 1.12.5 && bundle _1.12.5_ install
COPY . /ProtectedPlanetApi
EXPOSE 9292
CMD ["rackup"]