Netuitive Rails Agent
======================

The Netuitive Rails Agent creates default rails metrics to be sent to NetuitiveD using the netuitive_ruby_api gem. The Netuitive Rails Agent is meant to work in conjunction with the [netuitive_ruby_api](https://rubygems.org/gems/netuitive_ruby_api) gem and NetuitiveD to help [Netuitive](https://www.netuitive.com) monitor your Ruby applications.

For more information on the Netuitive Rails Agent, see our Ruby agent [help docs](https://help.netuitive.com/Content/Misc/Datasources/new_ruby_datasource.htm), or contact Netuitive support at [support@netuitive.com](mailto:support@netuitive.com).

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

1. [Sign Up](https://app.netuitive.com/signup/) for a Netuitive account if you don't already have one
1. Copy the `example.env` file to `.env` and replace the `RUBY_KEY` variable with your Ruby API key from the [Netuitive Integrations page](https://app.netuitive.com/#/profile/integrations)
1. Run `docker-compose up -d`
1. Access the example Rails application by going to http://localhost:3000 (or the IP address of your Docker host)
1. View your Netuitive inventory for the new **example-rails-application** element (the name is configurable in the `docker-compose.yml` file)
