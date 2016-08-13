class Fyber < Sinatra::Base
  set :views, Proc.new { File.join(root, "views") }

  get '/' do
    render_page
  end

  post '/' do
    uid, pub0, page = params['uid'], params['pub0'], params['page']

    offers = OffersRepository.new.get_offers(uid, pub0, page)

    render_page(offers)
  end

  private

  def render_page(offers=[])
    slim :index, locals: { offers: offers }
  end
end
