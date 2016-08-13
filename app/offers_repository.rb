class OffersRepository
  attr_reader :client

  def initialize(client = nil)
    @client ||= client || default_client
  end

  def get_offers(params)
    response = client.call(params)
    extract_offers(response)
  end

  private

  def extract_offers(response)
    parsed_response = parse_response(response)

    offers = parsed_response['offers']
    offers.map {|offer_hash| OpenStruct.new(offer_hash) }
  end

  def parse_response(response)
    response.parsed_response
  end

  def default_client
    FyberClient.new
  end
end
