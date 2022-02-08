# syntax=docker/dockerfile:1
FROM ruby:2.7.2
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

EXPOSE 3000

CMD ["thin", "-R", "config.ru", "start"]
