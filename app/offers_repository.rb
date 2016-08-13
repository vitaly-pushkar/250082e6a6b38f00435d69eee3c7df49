class OffersRepository
  attr_reader :client

  def initialize(client=FyberClient)
    @client = client
  end

  def get_offers(uid, pub0, page)
    client.get_offers({uid: uid, pub0: pub0, page: page})
  end
end
