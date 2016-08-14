require 'rubygems'
require 'bundler'
require 'rack-flash'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require_relative './application'
require_relative '../app/offers_repository'
require_relative '../app/fyber_client'
require_relative '../app/form_validator'
require_relative '../app/fyber'
