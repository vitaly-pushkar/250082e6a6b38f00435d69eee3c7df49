class Fyber < Sinatra::Base
  set :views, Proc.new { File.join(root, "views") }

  get '/' do
    render_page
  end

  post '/' do
    offers_params = filter_params(params)
    offers = OffersRepository.new.get_offers(offers_params)

    render_page(offers)
  end

  private

  def render_page(offers=[])
    slim :index, locals: { offers: offers }
  end

  def filter_params(params)
    params.select{|k| ['uid', 'pub0', 'page'].include?(k) }
  end
end
