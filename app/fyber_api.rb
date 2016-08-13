class FyberApi < Sinatra::Base
  set :views, Proc.new { File.join(root, "views") }

  get '/' do
    render_page
  end

  private

  def render_page(offers=[])
    slim :index, locals: { offers: offers }
  end
end
