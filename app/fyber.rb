class Fyber < Sinatra::Base
  set :views, Proc.new { File.join(root, "views") }

  get '/' do
    render_page
  end

  post '/' do
    offers = OffersRepository.new.get_offers
    render_page(offers)
  end

  private

  def render_page(offers=[])
    slim :index, locals: { offers: offers }
  end
end
