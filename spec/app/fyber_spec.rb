require 'spec_helper'

RSpec.describe App::Fyber do
  def app
    App::Fyber
  end

  context 'GET #index' do
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

  context 'POST #index' do
    let(:params) { { uid: 123, pub0: 'pub0', page: 1 } }
    context 'no offers result' do
      before do
        allow_any_instance_of(OffersRepository)
          .to receive(:get_offers).and_return([])
      end

      it 'renders page without offers' do
        post '/', params

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
        post '/', params

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

          post '/', params

          expect(last_response.status).to eq 200
          expect(last_response.body).to include('Message')
        end
      end
    end
  end
end
