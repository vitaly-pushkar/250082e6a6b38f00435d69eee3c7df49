require "./config/environment"

run Rack::URLMap.new("/" => App::Fyber)
