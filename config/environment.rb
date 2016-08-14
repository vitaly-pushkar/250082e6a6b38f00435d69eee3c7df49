require 'rubygems'
require 'bundler'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require_relative './application'
require_relative '../app/offers_repository'
require_relative '../app/fyber_client'
require_relative '../app/fyber'
