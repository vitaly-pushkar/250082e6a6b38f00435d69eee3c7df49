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

      let(:response) do
        <<-RESPONSE
          {
            "code": "OK",
            "message": "Ok",
            "count": 30,
            "pages": 2,
            "information": {
              "app_name": "Demo iframe for publisher - do not touch",
              "appid": 157,
              "virtual_currency": "Coins",
              "virtual_currency_sale_enabled": false,
              "country": "DE",
              "language": "DE",
              "support_url": "http://offer.fyber.com/mobile/support?appid=157&client=api&uid=player1"
            },
            "offers": []
          }
          RESPONSE
      end

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

      let(:response) do
        <<-RESPONSE
        {
          "code": "OK",
          "message": "Ok",
          "count": 30,
          "pages": 2,
          "information": {
            "app_name": "Demo iframe for publisher - do not touch",
            "appid": 157,
            "virtual_currency": "Coins",
            "virtual_currency_sale_enabled": false,
            "country": "DE",
            "language": "DE",
            "support_url": "http://offer.fyber.com/mobile/support?appid=157&client=api&uid=player1"
          },
          "offers": [
            {
              "title": "Sky",
              "offer_id": 1030402,
              "teaser": "Registriere dich mit korrekten Daten.",
              "required_actions": "Registriere dich mit korrekten Daten.",
              "link": "http://offer.fyber.com/mobile?impression=true&appid=157&uid=player1&client=api&platform=web&appname=Demo+iframe+for+publisher+-+do+not+touch&traffic_source=offer_api&country_code=DE&pubid=249&ip=109.235.143.113&pub0=campaign1&device_id=2b6f0cc904d137be2e1730235f5664094b83&flash_cookie=e5c83a44cfd62ae87bc18089eddbf366&ad_id=1030402&ad_format=offer&group=Fyber&sig=cd50cb14e67024b882f94593aa9d69b954659aa9",
              "offer_types": [
                {
                  "offer_type_id": 105,
                  "readable": "Registrierung"
                },
                {
                  "offer_type_id": 112,
                  "readable": "Gratis"
                }
              ],
              "payout": 89454,
              "time_to_payout": {
                "amount": 600,
                "readable": "10 Minuten"
              },
              "thumbnail": {
                "lowres": "http://cdn1.sponsorpay.com/assets/64704/Screen_Shot_2016-08-10_at_3.24.00_PM_square_60.png",
                "hires": "http://cdn1.sponsorpay.com/assets/64704/Screen_Shot_2016-08-10_at_3.24.00_PM_square_175.png"
              },
              "store_id": ""
            }
          ]
        }
        RESPONSE
      end

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
      
      let(:response) do
        <<-RESPONSE
        {
          "code": "NOT_OK_CODE",
          "message": "Some Message"
        }
        RESPONSE
      end
      
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
end
