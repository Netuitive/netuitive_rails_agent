FROM ruby:2.2.5

RUN apt-get update
RUN apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /opt/app
WORKDIR /opt/app

RUN gem install rails netuitived
RUN rails new netuitive-example

WORKDIR /opt/app/netuitive-example

RUN bundle install

RUN mkdir /opt/agent
WORKDIR /opt/agent

COPY Gemfile /opt/agent
RUN bundle install
COPY . /opt/agent

RUN rake test
RUN rubocop

RUN gem build netuitive_rails_agent.gemspec
RUN mv *.gem /opt/app/netuitive-example/

WORKDIR /opt/app/netuitive-example

RUN echo "gem 'netuitive_rails_agent'" >> Gemfile
RUN bundle install

ENV RUBY_KEY CHANGEME
ENV API_URL api.app.netuitive.com

EXPOSE 3000

CMD NETUITIVED_API_ID=${RUBY_KEY} NETUITIVED_ELEMENT_NAME=${ELEMENT_NAME} NETUITIVED_BASE_ADDR=${API_URL} netuitived start && bundle exec rails server -b0.0.0.0
