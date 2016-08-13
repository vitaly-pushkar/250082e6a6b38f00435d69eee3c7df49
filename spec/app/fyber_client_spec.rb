require 'spec_helper'
require 'json'

RSpec.describe FyberClient do
  let(:api_key) { '123' }
  let(:client) { FyberClient.new }
  
  context 'valid response' do
    before do
      allow(client).to receive(:api_key) { api_key }
      
      hashkey = Digest::SHA1.hexdigest(response + api_key)

      stub_request(:any, /api.fyber.com/)
        .to_return(
          body: response,
          status: status,
          headers: { 'X-Sponsorpay-Response-Signature' => hashkey })
    end

    context 'successful response with no offers' do
      let(:status) { 200 }
      let(:response) { json_response(:successful_no_offers) }

      it 'returns no offers' do
        result = client.call

        expect(result.code).to eq(200)
        expect(result.body).to eq(response)
        expect(JSON.parse(result.body)['code']).to eq('OK')
        expect(JSON.parse(result.body)['offers']).to be_empty
      end
    end

    context 'successful response with offers' do
      let(:status) { 200 }
      let(:response) { json_response(:successful_with_offers) }

      it 'returns offers' do
        result = client.call

        expect(result.code).to eq(200)
        expect(result.body).to eq(response)
        expect(JSON.parse(result.body)['code']).to eq('OK')
        expect(JSON.parse(result.body)['offers']).not_to be_empty
      end
    end
    
    context 'generic unsuccessful response with message' do
      let(:status) { 400 }
      let(:response) { json_response(:unsuccessful) }
      
      it 'contains error code and message' do
        result = client.call
        
        expect(result.code).to eq(400)
        expect(result.body).to eq(response)
        expect(JSON.parse(result.body)['code']).to eq('NOT_OK_CODE')
        expect(JSON.parse(result.body)['message']).to eq('Some Message')
      end
    end
  end
  
  
  context 'invalid response' do
    let (:status) { 200 }
    let(:response) { 'DOES NOT MATTER' }
    
    before do
      allow(client).to receive(:api_key) { api_key }
      
      hashkey = Digest::SHA1.hexdigest(response + api_key)

      stub_request(:any, /api.fyber.com/)
        .to_return( body: response, status: status)
    end
    
    it 'raises exception' do
      expect { client.call }
        .to raise_error(FyberClient::InvalidResponseSignature)
    end
  end
  
  private
  
  def json_response(name)
    File.open(
      File.dirname(__FILE__) + '/../json_responses/' + name.to_s + '.json', 'r'
    ).read
  end
end
