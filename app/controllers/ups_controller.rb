require 'active_shipping'
include ActiveMerchant::Shipping

class UpsController < ApplicationController

  #test method to simulate external request for estimate
  def go_estimate
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
    redirect_to generate_url("/ups_estimate.json", estimate_hash) 

  end

  # private test helper method for above
  def generate_url(url, params = {})
    #params hash is working correctly here
    raise
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end

  ###

  def estimate
    @estimate = extract_info(estimate_params)
    respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  private

  def ups_client
    UPS.new(:login => ENV['UPS_USERNAME'], :password => ENV['UPS_PASSWORD'], :key => ENV['UPS_ACCESS_KEY'])
  end

  def extract_info(order)
    response = ups_client.find_rates(order[:origin], order[:destination], order[:packages])
    rates = response.rates
    info = rates.map do |rate| 
      shipment = {}
      shipment[:service] = rate.service_name
      shipment[:price]   = rate.price
      shipment[:delivery_date] = rate.delivery_date
      shipment
    end
    info
  end

  def estimate_params
    # params comes back in from query string as hash (no need for explicit conversion), but the Rack::Utils.parse_nested_query(query_string) is not converting the hash correctly
    # params.require(:order).permit(:destination, :packages)
    # expect :destination to be a hash containing sanitized address
    # expect :packages to be an array of hashes, each containing :weight, :dimensions, and :units (see https://github.com/Shopify/active_shipping/blob/master/lib/active_shipping/shipping/package.rb for other options)

    ### hard coded test option
    params_hash = {order: {} }
    params_hash[:order][:packages]    = [ { weight: 100,                        
                                            dimensions: [93, 10, 5],
                                            :units => :metric 
                                          },

                                          { weight: (7.5 * 16),
                                            dimensions: [15, 10, 4.5],
                                            :units => :imperial
                                          }
                                        ]
    params_hash[:order][:origin]      = { :country => 'US',
                                            :state => 'CA',
                                            :city => 'Beverly Hills',
                                            :zip => '90210'
                                          }

    params_hash[:order][:destination] = { :country => 'US',
                                            :state => 'WA',
                                            :city => 'Seattle',
                                            :postal_code => '98117'
                                          }

    order = { origin: set_destination(params_hash[:order][:origin]), 
              destination: set_origin(params_hash[:order][:destination]),
              packages: set_packages(params_hash[:order][:packages])
            }
    order
  end

  def set_destination(destination_hash)
    Location.new(destination_hash)
  end

  def set_origin(origin_hash)
    Location.new(origin_hash)
  end

  def set_packages(packages)
    packages.map do |package|
      Package.new(package[:weight], package[:dimensions], units: package[:units])
    end
  end
end
