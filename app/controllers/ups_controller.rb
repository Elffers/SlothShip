require 'active_shipping'
include ActiveMerchant::Shipping

class UpsController < ApplicationController

  def go_estimate
  
    estimate_hash = {orders: {} }
    estimate_hash[:orders][:packages] = [
                              { weight:  100,                        
                                dimensions: [93,10, 5],                    
                                units: "metic" 
                              },

                              { weight: 7.5 * 16,
                                dimensions: [15, 10, 4.5],              
                                units: "imperial"
                              }
                            ]
              estimate_hash[:orders][:origin] = {
                                        :country => 'US',
                                        :state => 'CA',
                                        :city => 'Beverly Hills',
                                        :zip => '90210'},
              estimate_hash[:orders][:destination] = {
                                              :country => 'US',
                                              :state => 'WA',
                                              :city => 'Seattle',
                                              :postal_code => '98117'
                                            }
    
    redirect_to generate_url("/ups_estimate.json", estimate_hash) 

  end

  def generate_url(url, params = {})
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end

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
    #params comes back in from query string as hash, don't need to use Rack::Utils.parse_nested_query(query_string) after all
    params.require(:order).permit(:destination, :packages)
    # expect :destination to be a hash containing sanitized address
    # expect :packages to be an array of hashes, each containing :weight, :dimensions, and :units (see https://github.com/Shopify/active_shipping/blob/master/lib/active_shipping/shipping/package.rb for other options)

    ### hard coded test option
    estimate_hash = {}
    estimate_hash[:packages] = [
                Package.new(  100,                        # 100 grams
                              [93,10],                    # 93 cm long, 10 cm diameter
                              :cylinder => true),         # cylinders have different volume calculations

                Package.new(  (7.5 * 16),                 # 7.5 lbs, times 16 oz/lb.
                              [15, 10, 4.5],              # 15x10x4.5 inches
                              :units => :imperial)        # not grams, not centimetres
                ]
    estimate_hash[:origin] = Location.new(  :country => 'US',
                            :state => 'CA',
                            :city => 'Beverly Hills',
                            :zip => '90210')
    estimate_hash[:destination] = Location.new( :country => 'US',
                            :state => 'WA',
                            :city => 'Seattle',
                            :postal_code => '98117')
    estimate_hash

    ### end test option
  end
end
