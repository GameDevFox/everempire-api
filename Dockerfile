FROM ruby:2.4

EXPOSE 9292

ADD . /app
WORKDIR /app

RUN ./bin/setup

CMD bundle exec rackup --host 0.0.0.0
