class OffersRepository
  RemoteServerError = Class.new(StandardError)
  FeedNotFound = Class.new(StandardError)
  InvalidHashKey = Class.new(StandardError)
  InvalidParams = Class.new(StandardError)

  attr_reader :client

  def initialize(client = nil)
    @client ||= client || default_client
  end

  def get_offers(params)
    response = client.call(params)

    validate_response(response)
    extract_offers(response)
  end

  private

  def validate_response(response)
    return if response.code == 200

    message = parse_response(response)['message']

    raise InvalidParams, message if response.code == 400
    raise InvalidHashKey, message if response.code == 401
    raise FeedNotFound, 'Not found' if response.code == 404
    raise RemoteServerError, message if [500, 502].include?(response.code)
  end

  def extract_offers(response)
    parsed_response = parse_response(response)

    offers = parsed_response['offers']
    offers.map { |offer_hash| OpenStruct.new(offer_hash) }
  end

  def parse_response(response)
    response.parsed_response
  end

  def default_client
    FyberClient.new
  end
end
