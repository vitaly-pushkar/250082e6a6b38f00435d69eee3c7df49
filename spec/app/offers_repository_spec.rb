require 'spec_helper'

RSpec.describe OffersRepository do
  let(:offers) do
    [OpenStruct.new(title: 'offer1', thumbnail: 'offer1.jpg', payout: 123 ),
     OpenStruct.new(title: 'offer2', thumbnail: 'offer2.jpg', payout: 321 )]
  end

  it 'returns a list of offers' do
    client = double('client', get_offers: offers)
    
    response = OffersRepository.new(client).get_offers('uid123', 'campaign1', 1)

    expect(response).to eq(offers)
  end
end
