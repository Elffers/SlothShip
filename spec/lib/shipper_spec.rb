require 'spec_helper'
 
describe Shipper do
  let(:origin){ { :country => 'US', :zip => '90210'} }
  let(:destination){ { :country => 'CA', :postal_code => 'K1P 1J1'} }
  let(:packages){ [{weight: 100, dimensions: "93,10,5", :units => "imperial"}] }
  let(:params){ {order: {origin: origin, destination: destination, packages: packages} } }
  let(:estimate){ [{carrier:'ups', service: "ground", price: 1000, delivery_date: Date.today}]}
  let(:shipper){ Shipper.new(params) }

  describe '.ups_client' do
    it 'returns ups client' do
      expect(shipper.ups_client).to be_an_instance_of ActiveMerchant::Shipping::UPS
    end
  end

  describe '.fedex_client' do
    it 'returns fedex client' do
      expect(shipper.fedex_client).to be_an_instance_of ActiveMerchant::Shipping::FedEx
    end
  end

  describe 'return info from API' do
    let(:ups_response){ double("Ups response") }
    let(:fedex_response) { double("fedex response") }
    let(:rate){ double("rate", carrier: "foo", service_name: "bar", price: 1000, delivery_date: Date.today) }
    
    before do
      shipper.stub(:ups_info).and_return ups_response
      shipper.stub(:fedex_info).and_return fedex_response
      expect(ups_response).to receive(:rates).and_return [rate]
      expect(fedex_response).to receive(:rates).and_return [rate]
    end

    describe '.extract_info' do
      it 'returns an array of hashes' do
        expect(shipper.extract_info.first[:carrier]).to eq "foo"
      end
    end

    describe '.fastest_rates' do
      it 'returns array of hashes' do
        expect(shipper.fastest_rates.first[:carrier]).to eq "foo"
      end
    end

    describe '.cheapest_rates' do
      it 'returns array of hashes' do
        expect(shipper.cheapest_rates.first[:carrier]).to eq "foo"
      end
    end
  end

  #check webmock docs for how to store an actual call and tweak to get desired erros

  # xit "handles bad zip code error" do
  #   expect{ raise ArgumentError, "no"}.to raise_error ArgumentError
  # end

end