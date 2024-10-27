FROM ruby:3.1

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client

RUN gem install bundler && bundle install

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
