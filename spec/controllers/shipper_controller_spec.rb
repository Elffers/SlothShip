require 'spec_helper'

describe ShipperController do
  let(:origin) { { country: 'US', zip: '90210' } }
  let(:destination) { { country: 'CA', postal_code: 'K1P 1J1' } }
  let(:packages) { [{ weight: 100, dimensions: '93,10,5', units: 'imperial' }] }
  let(:params) { { origin: origin, destination: destination, packages: packages } }
  let(:estimate) { { foo: 'bar' } }
  let(:shipper) { double('Shipper') }

  describe 'POST "estimate"' do

    before do
      # allow(controller).to receive(:ups_client).and_return ups_client
      # allow(controller).to receive(:extract_info).and_return(extracted_info)
      allow(controller).to receive(:check_authenticity).and_return(true)
      allow(Shipper).to receive(:new).and_return shipper
      expect(shipper).to receive(:extract_info).and_return estimate
    end

    it 'returns JSON' do
      post :estimate, order: params, format: :json
      parsed_response = JSON.parse(response.body)
      expect { JSON.parse(response.body) }.to_not raise_error
      expect(parsed_response.class).to eq(Hash)
    end

    it 'logs request' do
      expect { post :estimate, order: params, format: :json }.to change(Request, :count).by(1)
    end

  end

  describe 'POST "fastest"' do
    before do
      allow(controller).to receive(:check_authenticity).and_return(true)
      allow(Shipper).to receive(:new).and_return shipper
      expect(shipper).to receive(:fastest_rates).and_return estimate
    end

    it 'returns JSON' do
      post :fastest, order: params, format: :json
      parsed_response = JSON.parse(response.body)
      expect { JSON.parse(response.body) }.to_not raise_error
      expect(parsed_response.class).to eq(Hash)
    end
  end

  describe 'POST "cheapest"' do
    before do
      allow(controller).to receive(:check_authenticity).and_return(true)
      allow(Shipper).to receive(:new).and_return shipper
      expect(shipper).to receive(:cheapest_rates).and_return estimate
    end

    it 'returns JSON' do
      post :cheapest, order: params, format: :json
      parsed_response = JSON.parse(response.body)
      expect { JSON.parse(response.body) }.to_not raise_error
      expect(parsed_response.class).to eq(Hash)
    end
  end

end
