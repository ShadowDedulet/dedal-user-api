ARG RUBY_VERSION=3.2.2-alpine3.18

FROM ruby:$RUBY_VERSION as development

RUN apk add --no-cache tzdata git postgresql-dev nano build-base

WORKDIR /opt/app

ENV EDITOR=nano
ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV PIDFILE=/dev/null

COPY Gemfile* ./

RUN bundle install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]


FROM ruby:$RUBY_VERSION as production

RUN apk add --no-cache tzdata git postgresql-libs nano

WORKDIR /opt/app

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV PIDFILE=/dev/null

COPY --from=development /usr/local/bundle /usr/local/bundle
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]


# Github Actions build
FROM alpine:3.18 as gh-actions

RUN apk add tzdata git postgresql-dev ruby ruby-dev make musl-dev yaml-dev

WORKDIR /opt/app

ENV RAILS_ENV=test

COPY Gemfile* ./

RUN gem install bundler && bundle install

COPY . .

CMD ["bundle", "exec", "rubocop"]
