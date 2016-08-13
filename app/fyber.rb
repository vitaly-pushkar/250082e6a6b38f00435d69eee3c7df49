module App
  class Fyber < Sinatra::Base
    EXCEPTIONS = [
      FyberClient::InvalidResponseSignature,
      OffersRepository::RemoteServerError,
      OffersRepository::URLNotFound,
      OffersRepository::InvalidHashKey,
      OffersRepository::InvalidParams,
    ]
    
    set :views, Proc.new { File.join(root, "views") }

    get '/' do
      render_page
    end

    post '/' do
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
      params.select{|k| ['uid', 'pub0', 'page'].include?(k) }
    end
  end
end
