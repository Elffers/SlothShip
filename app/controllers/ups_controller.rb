require 'active_shipping'
include ActiveMerchant::Shipping

class UpsController < ApplicationController
  #test method to simulate external request for estimate
  def mock_external_request
    estimate_hash = {order: {} }
    estimate_hash[:order][:packages] =[ { weight: 100,
                                          dimensions: [93, 10, 5],
                                          units: "metric" 
                                        },

                                        { weight: (7.5 * 16),
                                          dimensions: [15, 10, 4.5],
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
                                          
    redirect_to "/ups_estimate.json?#{estimate_hash.to_query}"
  end

  def estimate
    @estimate = extract_info(estimate_params)
    @response = response.inspect
    respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  private

  def extract_info(order)
    response = ups_client.find_rates(order[:origin], order[:destination], order[:packages])
    info = response.rates.map do |rate|
      shipment = {}
      shipment[:service] = rate.service_name
      shipment[:price]   = rate.price
      shipment[:delivery_date] = rate.delivery_date
      shipment
    end
    info
  end

  def ups_client
    UPS.new(:login => ENV['UPS_USERNAME'], :password => ENV['UPS_PASSWORD'], :key => ENV['UPS_ACCESS_KEY'])
  end

end
