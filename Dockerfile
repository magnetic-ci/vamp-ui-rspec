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
      libgconf2-4 \
      unzip \
      xvfb \
      chromium-browser

ENV CHROME_DRIVER_VERSION="2.32"

RUN cd /tmp && \
    wget https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver

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

CMD (Xvfb :1 -screen 0 1920x1080x24 -ac &) && rspec --format doc
