require 'active_shipping'
include ActiveMerchant::Shipping

class UpsController < ApplicationController

  def estimate
    origin = 
    packages = [
                Package.new(  100,                        # 100 grams
                              [93,10],                    # 93 cm long, 10 cm diameter
                              :cylinder => true),         # cylinders have different volume calculations

                Package.new(  (7.5 * 16),                 # 7.5 lbs, times 16 oz/lb.
                              [15, 10, 4.5],              # 15x10x4.5 inches
                              :units => :imperial)        # not grams, not centimetres
                ]
    origin = Location.new(  :country => 'US',
                            :state => 'CA',
                            :city => 'Beverly Hills',
                            :zip => '90210')
    destination = Location.new( :country => 'CA',
                            :province => 'ON',
                            :city => 'Ottawa',
                            :postal_code => 'K1P 1J1')

    @estimate = ups_client.find_rates(origin, destination, packages)
    respond_to do |format|
        format.html { render :estimate }
        format.json { render json: @estimate }
      end
  end

  def ups_client
    UPS.new(:login => ENV['UPS_USERNAME'], :password => ENV['UPS_PASSWORD'], :key => ENV['UPS_ACCESS_KEY'])
  end
end
