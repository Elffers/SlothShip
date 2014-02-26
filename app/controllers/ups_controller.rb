require 'active_shipping'
include ActiveMerchant::Shipping

class UpsController < ApplicationController

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
    info = {} 
    response = ups_client.find_rates(order[:origin], order[:destination], order[:packages])
    rates = response.rates
    info[:options] = rates.map {|rate| [rate.service_name, rate.price, rate.delivery_date] }
    # info[:price] = rates.price
    # info[:delivery_date] = rate.delivery_date
    info
  end

  def estimate_params
    params.require(:order).permit(:origin, :destination, :packages)
    # estimate_hash = {}
    # estimate_hash[:packages] = [
    #             Package.new(  100,                        # 100 grams
    #                           [93,10],                    # 93 cm long, 10 cm diameter
    #                           :cylinder => true),         # cylinders have different volume calculations

    #             Package.new(  (7.5 * 16),                 # 7.5 lbs, times 16 oz/lb.
    #                           [15, 10, 4.5],              # 15x10x4.5 inches
    #                           :units => :imperial)        # not grams, not centimetres
    #             ]
    # estimate_hash[:origin] = Location.new(  :country => 'US',
    #                         :state => 'CA',
    #                         :city => 'Beverly Hills',
    #                         :zip => '90210')
    # estimate_hash[:destination] = Location.new( :country => 'US',
    #                         :state => 'WA',
    #                         :city => 'Seattle',
    #                         :postal_code => '98117')
    # estimate_hash
    # params
  end
end
