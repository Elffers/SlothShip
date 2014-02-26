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
    let(:ups_client) { double("ups_client")}

    before do
      allow(controller).to receive(:ups_client).and_return ups_client
      allow(ups_client).to receive(:find_rates).and_return({ origin: "hi"})
    end

    it 'should return JSON' do
      get :estimate, format: :json
      expect{JSON.parse(response.body)}.to_not raise_error
    end
    
  end

end
