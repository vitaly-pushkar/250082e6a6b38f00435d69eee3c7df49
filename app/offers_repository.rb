class OffersRepository
  attr_reader :client

  def initialize(client=FyberClient)
    @client = client
  end

  def get_offers(params)
    response = client.call(params)
    extract_offers(response)
  end

  private

  def extract_offers(response)
    offers = response.parsed_response['offers']
    offers.map {|offer_hash| OpenStruct.new(offer_hash) }
  end
end
