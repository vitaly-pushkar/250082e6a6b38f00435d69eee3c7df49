#Fyber Offers API Web Client

[![Code Climate](https://codeclimate.com/github/vitaly-pushkar/250082e6a6b38f00435d69eee3c7df49/badges/gpa.svg)](https://codeclimate.com/github/vitaly-pushkar/250082e6a6b38f00435d69eee3c7df49)
[![Test Coverage](https://codeclimate.com/github/vitaly-pushkar/250082e6a6b38f00435d69eee3c7df49/badges/coverage.svg)](https://codeclimate.com/github/vitaly-pushkar/250082e6a6b38f00435d69eee3c7df49/coverage)
[![Build Status](https://travis-ci.org/vitaly-pushkar/250082e6a6b38f00435d69eee3c7df49.svg?branch=master)](https://travis-ci.org/vitaly-pushkar/250082e6a6b38f00435d69eee3c7df49)

Simple web client to consume Fyber API and render result offers in a HTML page.

Based on [Sinatra](https://github.com/sinatra/sinatra), uses [HTTParty](https://github.com/jnunemaker/httparty) as HTTP client.


###Story

Following the commit history, you can see this app was developed in a test-drived way, "outside-in" approach.

`FyberClient` is the "low-level" implementation of the Fyber API HTTP client with only one public method `#call`, returning a raw response.
It is a default client in the `OffersRepository` which takes care of validating the response and extracting offers from it into an array of offer objects (`OpenStruct` is used for simplicity) which are then rendered into HTML.

Current version tries to keep balance between compactness and amount of abstractions.
If the app would be to develop further, it would make sense to extract such responsibilities as raw response validation and offers extraction from `OffersRepository` and into specific classes which would be composed in `OffersRepository` leaving it only to communicate with injected clients and return offers objects for HTML render.

##Online Demo
Demo app is running on Heroku at https://floating-dawn-15079.herokuapp.com/

##Local demo
- Clone this repo
- `cd` to the app folder
- make sure you have ruby 2.2.4 along with `bundler` gem installed on your system
- run `bundle install` to install required gems
- after gems are installed, run `FYBER_API_KEY=xxxxx bundle exec rackup config.ru` where `FYBER_API_KEY` is an api key received from Fyber

##Specs
To run specs, simply execute `rake` command.
