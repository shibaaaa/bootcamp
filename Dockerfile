FROM ruby:3.1.4-alpine

ENV RAILS_ENV production
WORKDIR /app

# Update rubygems
RUN gem update --system
RUN printf "install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri" > ~/.gemrc
RUN gem install --no-document --force bundler -v 2.4.21

# Install packages
RUN apk add --no-cache \
      yarn \
      ruby-dev \
      build-base \
      git \
      nodejs \
      postgresql-dev postgresql \
      tzdata && \
      cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# libvips
RUN apk add --no-cache vips-dev orc-dev bash pngcrush optipng=0.7.8-r0 ghostscript-fonts

# Install npm packages
COPY package.json yarn.lock ./
RUN yarn install --production --ignore-engines

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install -j4

# Compile assets
COPY . ./
RUN SECRET_KEY_BASE=dummy NODE_OPTIONS=--openssl-legacy-provider bin/rails assets:precompile

ENV PORT 3000
EXPOSE 3000

CMD bin/rails server -p $PORT -e $RAILS_ENV
