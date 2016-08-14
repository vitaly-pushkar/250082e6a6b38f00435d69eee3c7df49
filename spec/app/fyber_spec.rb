require 'spec_helper'

RSpec.describe App::Fyber do
  def app
    App::Fyber
  end

  context 'GET /' do
    it 'renders index page' do
      get '/'

      expect(last_response.status).to eq 200
    end

    it 'renders no offers' do
      get '/'

      expect(last_response.body).to include('No offers available')
    end

    it 'renders a form to request offers' do
      get '/'

      expect(last_response.body).to include('name="uid"')
      expect(last_response.body).to include('name="pub0"')
      expect(last_response.body).to include('name="page"')
    end
  end

  context 'GET /offers' do
    let(:params) { { uid: 123, pub0: 'pub0', page: 1 } }

    context 'no offers result' do
      before do
        allow_any_instance_of(OffersRepository)
          .to receive(:get_offers).and_return([])
      end

      it 'renders page without offers' do
        get '/offers', params

        expect(last_response.status).to eq 200
        expect(last_response.body).to include('No offers available')
      end
    end

    context 'result with offers' do
      let(:offers) do
        [OpenStruct.new(
          title: 'offer1',
          thumbnail: { 'lowres' => 'offer1.jpg' },
          payout: 123
        ),
         OpenStruct.new(
           title: 'offer2',
           thumbnail: { 'lowres' => 'offer2.jpg' },
           payout: 321
         )]
      end

      before do
        allow_any_instance_of(OffersRepository)
          .to receive(:get_offers).and_return(offers)
      end

      it 'renders page with offers' do
        get '/offers', params

        expect(last_response.status).to eq 200

        expect(last_response.body).to include('offer1')
        expect(last_response.body).to include('offer1.jpg')
        expect(last_response.body).to include('123')

        expect(last_response.body).to include('offer2')
        expect(last_response.body).to include('offer2.jpg')
        expect(last_response.body).to include('321')
      end
    end

    context 'handles response exceptions' do
      App::Fyber::EXCEPTIONS.each do |exception|
        it "handles response #{exception} exception" do
          allow_any_instance_of(OffersRepository)
            .to receive(:get_offers).and_raise(exception, 'Message')

          get '/offers', params

          expect(last_response.status).to eq 200
          expect(last_response.body).to include('Message')
        end
      end
    end

    context 'form params validation' do
      it 'renders error when uid is missing' do
        get '/offers', pub0: 'pub0', page: 1

        expect(last_response).to be_redirect
        follow_redirect!

        expect(last_response.body).to include('uid: is missing')
      end

      it 'renders error when pub0 is missing' do
        get '/offers', uid: 123, page: 1

        expect(last_response).to be_redirect
        follow_redirect!

        expect(last_response.body).to include('pub0: is missing')
      end

      it 'renders errors when page is missing' do
        get '/offers', uid: 123, pub0: 'pub0'

        expect(last_response).to be_redirect
        follow_redirect!

        expect(last_response.body).to include('page: is missing')
      end
    end
  end
end
