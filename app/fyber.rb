module App
  class Fyber < Sinatra::Base
    EXCEPTIONS = [
      FyberClient::InvalidResponseSignature,
      OffersRepository::RemoteServerError,
      OffersRepository::URLNotFound,
      OffersRepository::InvalidHashKey,
      OffersRepository::InvalidParams
    ].freeze

    set :views, proc { File.join(root, 'views') }

    get '/' do
      render_page
    end

    get '/offers' do
      offers_params = filter_params(params)
      offers = []

      begin
        offers = OffersRepository.new.get_offers(offers_params)
      rescue *EXCEPTIONS => e
        message = e.message
      end

      render_page(offers, message)
    end

    private

    def render_page(offers = [], message = nil)
      slim :index, locals: { offers: offers, message: message }
    end

    def filter_params(params)
      params.select { |k| %w(uid pub0 page).include?(k) }
    end
  end
end
