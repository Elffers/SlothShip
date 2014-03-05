require 'spec_helper'
 
describe Shipper do 
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

  describe '.usps_client' do
    it 'returns usps client' do
      expect(Shipper.usps_client).to be_an_instance_of ActiveMerchant::Shipping::USPS
    end
  end

  describe '.extract info' do
    it 'returns an array of hashes' do
      
    end
  end

end