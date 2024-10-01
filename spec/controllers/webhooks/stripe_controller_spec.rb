require 'rails_helper'

RSpec.describe Webhooks::StripeController, type: :controller do
  describe 'POST #create' do
    let(:payload) { { id: 'evt_123', type: 'customer.subscription.created', data: { 'object' => { 'id' => 'sub_123' } } }.to_json }
    let(:sig_header) { 't=123456789,v1=signature' }
    let(:event) { Stripe::Event.construct_from(JSON.parse(payload)) }

    before do
      request.env['HTTP_STRIPE_SIGNATURE'] = sig_header
      allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
    end

    context 'when the payload is invalid' do
      before do
        allow(Stripe::Webhook).to receive(:construct_event).and_raise(JSON::ParserError)
      end

      it 'returns a bad request status' do
        post :create, body: 'invalid payload'
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['error']).to eq('Invalid payload')
      end
    end

    context 'when the signature is invalid' do
      before do
        allow(Stripe::Webhook).to receive(:construct_event).and_raise(Stripe::SignatureVerificationError.new('Invalid signature', sig_header))
      end

      it 'returns a bad request status' do
        post :create, body: payload
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['error']).to eq('Invalid signature')
      end
    end

    context 'when the event is valid' do
      it 'processes the event and returns success' do
        expect(Stripe::Events).to receive(:new).with(event: event).and_call_original
        expect_any_instance_of(Stripe::Events).to receive(:call)
        post :create, body: payload
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['message']).to eq('success')
      end
    end
  end
end
