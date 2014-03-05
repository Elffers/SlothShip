require 'spec_helper'

describe ShipperController do
  describe 'GET estimate' do
    let(:origin){ { :country => 'US',
                    :zip => '90210'
                  }
                }
    let(:destination){ { :country => 'CA',
                        :postal_code => 'K1P 1J1'
                        } 
                      }
    let(:packages){ [{weight: 100, dimensions: "93,10,5", :units => "imperial"}] }
    let(:params){ {origin: origin, destination: destination, packages: packages} }
    let(:ups_client) { double("ups_client") }
    let(:extracted_info) { {"carrier" => "UPS", 
                            "service" => "UPS Express", 
                            "price" => 13437, 
                            "delivery_date" => "2014-02-27T00:00:00+00:00"} }
    let(:estimate){ {foo:"bar"} }

    before do
      # allow(controller).to receive(:ups_client).and_return ups_client
      allow(controller).to receive(:extract_info).and_return(extracted_info)
      expect(Shipper).to receive(:extract_info).and_return(estimate)
    end

    it 'should return JSON' do
      post :estimate, order: params, format: :json
      parsed_response = JSON.parse(response.body)
      expect{JSON.parse(response.body)}.to_not raise_error
      expect(parsed_response.class).to eq(Hash)
    end

    it 'logs request' do
      expect { post :estimate, order: params, format: :json }.to change(Request, :count).by(1)
    end
 
  end

end
