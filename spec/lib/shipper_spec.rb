require 'spec_helper'
 
describe Shipper do
  let(:origin){ { :country => 'US', :zip => '90210'} }
  let(:destination){ { :country => 'CA', :postal_code => 'K1P 1J1'} }
  let(:packages){ [{weight: 100, dimensions: "93,10,5", :units => "imperial"}] }
  let(:params){ {origin: origin, destination: destination, packages: packages} }

  #check webmock docs for how to store an actual call and tweak to get desired erros

  # xit "handles bad zip code error" do
  #   expect{ raise ArgumentError, "no"}.to raise_error ArgumentError
  # end

  describe '.ups_client' do
    it 'returns ups client' do
      # client = double("ups client") #is this kind of silly?
      # expect(UPS).to receive(:new){ client }
      expect(Shipper.ups_client).to be_an_instance_of ActiveMerchant::Shipping::UPS
    end
  end

  describe '.fedex_client' do
    it 'returns fedex client' do
      expect(Shipper.fedex_client).to be_an_instance_of ActiveMerchant::Shipping::FedEx
    end
  end

  describe '.ups info' do
    xit 'returns an array of hashes' do
      # order = double("order")
      # origin = double("origin")
      # destination = double("destination")
      # packages = double("packages")
      # expect(order).to receive(:[]).with(:destination) {destination}
      # expect(order).to receive(:[]).with(:origin)      {origin}
      # expect(order).to receive(:[]).with(:packages)    {packages}
      # #is this just testing the gem?

      ups_client = double("ups client")
      rate_response = double("ActiveMerchant Response")
      ups_client.stub(:find_rates){ rate_response }
      expect(Shipper.ups_info(order)).to be_an_instance_of Array

    end
  end

  describe '.extract info' do
    xit 'returns an array of hashes' do
      carriers = double("carriers")
      expect(Shipper.extract_info(order)).to be_an_instance_of Array

    end

  end

end