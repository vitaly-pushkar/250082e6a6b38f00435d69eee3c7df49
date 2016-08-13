class FyberApi < Sinatra::Base
  set :views, Proc.new { File.join(root, "views") }

  get '/' do
    slim :index
  end
end
