FROM ruby:2.3.0
# Install node for asset building
RUN apt-get update -qq && apt-get install -y --force-yes build-essential libpq-dev nodejs
# install npm
RUN apt-get install -y --force-yes -qq npm
RUN ln -s /usr/bin/nodejs /usr/bin/node
# install bower
RUN npm install --global bower
RUN mkdir /ProtectedPlanetApi
WORKDIR /ProtectedPlanetApi
ADD Gemfile /ProtectedPlanetApi/Gemfile
ADD Gemfile.lock /ProtectedPlanetApi/Gemfile.lock
ADD config.ru /ProtectedPlanetApi/config.ru
ADD bower.json /ProtectedPlanetApi/bower.json
RUN gem install bundler -v 1.12.5 && bundle _1.12.5_ install
RUN bower install --allow-root
COPY . /ProtectedPlanetApi
EXPOSE 9292
CMD ["rackup"]