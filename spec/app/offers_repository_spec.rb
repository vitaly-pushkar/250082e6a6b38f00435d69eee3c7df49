require 'spec_helper'

RSpec.describe OffersRepository do
  let(:client) { double('client', call: response) }
  let(:params) { { uid: 'uid123', pub0: 'campaign1', page: 1 } }
  
  context 'client reponse is successful' do
    context 'response offers not empty' do
      let(:offer_1) { {title: 'offer_1', thumbnail: 'offer_1.jpg', payout: 123} }
      let(:offer_2) { {title: 'offer_2', thumbnail: 'offer_2.jpg', payout: 456} }

      let(:offers) do
        [OpenStruct.new(offer_1), OpenStruct.new(offer_2)]
      end

      let(:response) do
        double('response',
          code: 200,
          parsed_response:
            {'offers' => [stringify_keys(offer_1), stringify_keys(offer_2)]}
        )
      end

      it 'returns a list of offers' do
        result = OffersRepository.new(client).get_offers(params)

        expect(result).to eq(offers)
      end
    end

    context 'response offers empty' do
      let(:response) do
        double("response", code: 200, parsed_response: {'offers' => []})
      end

      it 'returns empty list of offers' do
        result = OffersRepository.new(client).get_offers(params)

        expect(result).to eq([])
      end
    end
  end
  
  context 'client response is unsuccessful' do
    let(:response) do 
      double('response', code: code, parsed_response: {'message' => 'Message'})
    end
    
    context 'status code 400' do
      let(:code) { 400 }

      it 'raises exception' do
        expect { OffersRepository.new(client).get_offers(params) }
          .to raise_error(OffersRepository::InvalidParams)
      end
    end
    
    context 'status code 401' do
      let(:code) { 401 }

      it 'raises exception' do
        expect { OffersRepository.new(client).get_offers(params) }
          .to raise_error(OffersRepository::InvalidHashKey)
      end
    end

    context 'status code 404' do
      let(:code) { 404 }

      it 'raises exception' do
        expect { OffersRepository.new(client).get_offers(params) }
          .to raise_error(OffersRepository::URLNotFound)
      end
    end
    
    context 'status code 500' do
      let(:code) { 500 }

      it 'raises exception' do
        expect { OffersRepository.new(client).get_offers(params) }
          .to raise_error(OffersRepository::RemoteServerError)
      end
    end
    
    context 'status code 502' do
      let(:code) { 502 }

      it 'raises exception' do
        expect { OffersRepository.new(client).get_offers(params) }
          .to raise_error(OffersRepository::RemoteServerError)
      end
    end
  end

  private

  def stringify_keys(hash)
    Hash[hash.collect{|k,v| [k.to_s, v]}]
  end
end
