FROM ubuntu:12.04
MAINTAINER Ian Neubert <ian@ianneubert.com>

# Setup ubuntu
RUN apt-get update
RUN apt-get upgrade -y

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Install ruby.
# Solution from: http://stackoverflow.com/a/16224372
ADD http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p451.tar.gz /tmp/
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
RUN tar -xzf /tmp/ruby-2.0.0-p451.tar.gz && \
    (cd ruby-2.0.0-p451/ && ./configure --disable-install-doc && make && make install) && \
    rm -rf ruby-2.0.0-p451/ && \
    rm -f /tmp/ruby-2.0.0-p451.tar.gz

# Install rubygems
ADD http://production.cf.rubygems.org/rubygems/rubygems-2.2.2.tgz /tmp/

RUN cd /tmp && tar -zxf /tmp/rubygems-2.2.2.tgz
RUN cd /tmp/rubygems-2.2.2 && ruby setup.rb

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler --no-rdoc --no-ri

RUN rm -rf /tmp/*
