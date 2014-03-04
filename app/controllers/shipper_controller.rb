class ShipperController < ApplicationController
  skip_before_action :verify_authenticity_token

  def estimate
    @estimate = Shipper.extract_info(estimate_params)
    Request.create(request: estimate_params.to_s, result: @estimate.to_s)
    respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  def fastest
    @estimate = Shipper.fastest_rates(estimate_params)
     respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  def cheapest
    @estimate = Shipper.cheapest_rates(estimate_params)
     respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  #test method to simulate external request for estimate
  def mock_external_request
    estimate_hash = {order: {} }
    estimate_hash[:order][:packages] =[ { weight: 100,
                                          dimensions: "93, 10, 5", #breaks if this is an array
                                          units: "metric" 
                                        },

                                        { weight: (7.5 * 16),
                                          dimensions: "15, 10, 4.5",
                                          units: "imperial"
                                        }
                                      ]
    estimate_hash[:order][:origin] =  { :country => 'US',
                                        :state => 'CA',
                                        :city => 'Beverly Hills',
                                        :zip => '90210'
                                      }

    estimate_hash[:order][:destination] = { :country => 'US',
                                            :state => 'WA',
                                            :city => 'Seattle',
                                            :postal_code => '98117'
                                          }
                                          
    redirect_to "/get_estimate.json?#{estimate_hash.to_query}"
  end

  def hello
    name = JSON.parse(params[:data])["name"]
    render text: "hello, #{name}"
  end

end
