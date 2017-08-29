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
      libhyphen0 \
      xvfb \
      firefox

ENV GECKO_DRIVER_VERSION="0.18.0"

RUN cd /tmp && \
    wget https://github.com/mozilla/geckodriver/releases/download/v${GECKO_DRIVER_VERSION}/geckodriver-v${GECKO_DRIVER_VERSION}-linux64.tar.gz && \
    tar zpxvf geckodriver-v${GECKO_DRIVER_VERSION}-linux64.tar.gz && \
    mv geckodriver /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver

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

ENV DISPLAY=:1

CMD (Xvfb :1 -ac &) && rspec --format doc
