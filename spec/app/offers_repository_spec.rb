require 'spec_helper'

RSpec.describe OffersRepository do
  let(:offer_1) { {title: 'offer_1', thumbnail: 'offer_1.jpg', payout: 123} }
  let(:offer_2) { {title: 'offer_2', thumbnail: 'offer_2.jpg', payout: 456} }

  let(:offers) do
    [OpenStruct.new(offer_1), OpenStruct.new(offer_2)]
  end

  let(:response) do
    double("response",
      code: 200,
      parsed_response:
        {'offers' => [stringify_keys(offer_1), stringify_keys(offer_2)]}
    )
  end

  it 'returns a list of offers' do
    client = double('client', call: response)
    params = { uid: 'uid123', pub0: 'campaign1', page: 1 }

    result = OffersRepository.new(client).get_offers(params)

    expect(result).to eq(offers)
  end

  private

  def stringify_keys(hash)
    Hash[hash.collect{|k,v| [k.to_s, v]}]
  end
end
