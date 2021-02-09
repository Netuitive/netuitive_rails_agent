CloudWisdom Rails Agent
======================

The CloudWisdom Rails Agent creates default rails metrics to be sent to NetuitiveD using the netuitive_ruby_api gem. The CloudWisdom Rails Agent is meant to work in conjunction with the [netuitive_ruby_api](https://rubygems.org/gems/netuitive_ruby_api) gem and NetuitiveD to help [CloudWisdom](https://www.virtana.com/products/cloudwisdom/) monitor your Ruby applications.

For more information on the Netuitive Rails Agent, see our Ruby agent [help docs](https://docs.virtana.com/en/ruby-agent.html), or contact CloudWisdom support at [cloudwisdom.support@virtana.com](mailto:cloudwisdom.support@virtana.com).

Requirements
-------------

[NetuitiveD](https://github.com/Netuitive/netuitived) must be installed and running.

Installing the Netuitive Rails Agent
-------------------------------------

1. Add `gem 'netuitive_rails_agent'` to your Gemfile.

2. Run `bundle install`.

3. Restart your rails app.

## Dockerized Example

Included in this project are Docker and Docker Compose files for easy testing of this application. To run an example Rails app with the Netuitive Rails Agent monitoring it perform the following steps:

1. [Sign Up](https://try.cloudwisdom.virtana.com/) for a Netuitive account if you don't already have one
1. Copy the `example.env` file to `.env` and replace the `RUBY_KEY` variable with your Ruby API key from the [CloudWisdom Integrations page](https://try.cloudwisdom.virtana.com/)
1. Run `docker-compose up -d`
1. Access the example Rails application by going to http://localhost:3000 (or the IP address of your Docker host)
1. View your CloudWisdom inventory for the new **example-rails-application** element (the name is configurable in the `docker-compose.yml` file)
