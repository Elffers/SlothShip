require 'spec_helper'
describe Order do
  let(:params) { { order: { origin: { country: 'US',
                                      state:  'CA',
                                      city:  'Beverly Hills',
                                      zip:  '90210'
                                    },
                            destination: {  country: 'US',
                                            state: 'WA',
                                            city:  'Seattle',
                                            zip:  '98122'
                                          },
                            packages: [{  weight: 100,
                                          dimensions: '5, 7, 6',
                                          units: 'imperial' }]
                          }
                  }
                }

  let(:order) { Order.new(params) }
  describe 'set origin' do
    it 'should return valid origin object' do
      expect(order.origin).to be_an_instance_of ActiveMerchant::Shipping::Location
    end
  end

  describe 'set destination' do
    it 'should return valid origin object' do
      expect(order.destination).to be_an_instance_of ActiveMerchant::Shipping::Location
    end
  end

  describe 'set packages' do
    it 'should return array of packages' do
      expect(order.packages).to be_an_instance_of Array
    end

    it 'have valid packages as elements' do
      expect(order.packages.first).to be_an_instance_of ActiveMerchant::Shipping::Package
    end
  end
end
