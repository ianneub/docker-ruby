FROM ubuntu:14.04
MAINTAINER Ian Neubert <ian@ianneubert.com>

# Setup ubuntu
RUN apt-get update && \
    apt-get upgrade -y
RUN apt-get install -y libmysqlclient-dev libsqlite3-dev libpq-dev libxslt-dev libxml2-dev \
    imagemagick build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev git libffi-dev

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Install ruby
ADD http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p576.tar.gz /tmp/
RUN tar -xzf /tmp/ruby-2.0.0-p576.tar.gz && \
    (cd ruby-2.0.0-p576/ && ./configure --disable-install-doc && make && make install) && \
    rm -rf ruby-2.0.0-p576/ && \
    rm -f /tmp/ruby-2.0.0-p576.tar.gz

# Install rubygems
ADD http://production.cf.rubygems.org/rubygems/rubygems-2.4.1.tgz /tmp/
RUN cd /tmp && tar -zxf /tmp/rubygems-2.4.1.tgz && \
    cd /tmp/rubygems-2.4.1 && ruby setup.rb

# Config rubygems and install bundler
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc && \
    gem install bundler --no-rdoc --no-ri

# Clean up
RUN rm -rf /tmp/* && \
    mkdir /app

WORKDIR /app
