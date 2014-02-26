require 'spec_helper'

describe UpsController do
  describe 'GET estimate' do
    let(:origin){ { :country => 'US',
                    :state => 'CA',
                    :city => 'Beverly Hills',
                    :zip => '90210'}}
    let(:destination){{ :country => 'CA',
                        :province => 'ON',
                        :city => 'Ottawa',
                        :postal_code => 'K1P 1J1'
                      }}
    let(:package){ [100, [93,10], :cylinder => true] }
    let(:params){ {origin: origin, destination: destination, packages: package} }
    let(:ups_client) { double("ups_client")}
    let(:extracted_info) { {"price" => 13437, "delivery_date" => "2014-02-27T00:00:00+00:00"} }

    before do
      allow(controller).to receive(:ups_client).and_return ups_client
      # allow(ups_client).to receive(:find_rates).and_return( {order: "hi"} )
      allow(controller).to receive(:extract_info).and_return(extracted_info)
    end

    it 'should return JSON' do
      get :estimate, order: params, format: :json
      expect{JSON.parse(response.body)}.to_not raise_error
    end

    it 'should return estimated shipping price and delivery info' do
      get :estimate, order: params, format: :json
      order_info = JSON.parse(response.body)
      expect(order_info).to eq extracted_info
    end
    
  end

end
