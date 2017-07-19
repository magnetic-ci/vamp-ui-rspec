FROM phusion/baseimage:latest

RUN apt-get update && \
    apt-get install -y \
      wget \
      ruby \
      ruby-dev \
      libffi-dev \
      build-essential \
      libfontconfig \
      libjpeg8 \
      libicu55 \
      libxml2 \
      libxslt1.1 \
      libhyphen0

ENV PHANTOMJS_VERSION="2.5.0-beta"

RUN cd /tmp && \
    mkdir phantomjs && \
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-ubuntu-xenial-x86_64.tar.gz && \
    tar zpxvf phantomjs-${PHANTOMJS_VERSION}-linux-ubuntu-xenial-x86_64.tar.gz && \
    mv phantomjs-${PHANTOMJS_VERSION}-ubuntu-xenial/bin/phantomjs /usr/local/bin && \
    chmod +x /usr/local/bin/phantomjs && \
    rm -rf /tmp/phantomjs*

RUN gem install bundler

RUN mkdir -p /src/spec

ADD spec/spec_helper.rb /src/spec/spec_helper.rb

ADD spec/vamp_spec.rb /src/spec/vamp_spec.rb

ADD .rspec /src/.rspec

ADD Gemfile /src/Gemfile

ADD README.md /src/README.md

ADD Makefile /src/Makefile

RUN cd /src && \
    bundle install

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /src

CMD rspec --format doc
