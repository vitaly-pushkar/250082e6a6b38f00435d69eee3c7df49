require 'spec_helper'

RSpec.describe FyberApi do
  def app
    FyberApi
  end

  context "GET #index" do
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
end
