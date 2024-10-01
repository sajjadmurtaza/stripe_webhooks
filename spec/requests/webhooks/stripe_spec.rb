require 'rails_helper'

RSpec.describe "Webhooks::Stripes", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/webhooks/stripe/create"
      expect(response).to have_http_status(:success)
    end
  end
end
