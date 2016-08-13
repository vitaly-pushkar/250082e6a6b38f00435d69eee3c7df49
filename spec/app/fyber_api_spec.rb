require 'spec_helper'

RSpec.describe FyberApi do
  def app
    FyberApi
  end

  context "GET #index" do
    it 'renders index page' do
      get "/"
      expect(last_response.status).to eq 200
    end
  end
end
