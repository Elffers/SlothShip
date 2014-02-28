require 'active_shipping'
include ActiveMerchant::Shipping

class FedexController < ApplicationController

  def estimate(origin, destination, packages)
    @estimate = fedex_client.find_rates(origin, destination, packages)
    respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end


  private

  def fedex_client
    options = { :key=> ENV['FEDEX_KEY'],
                :password=> ENV['FEDEX_PASSWORD'],
                :account=> ENV['FEDEX_ACCOUNT'],
                :login=> ENV['FEDEX_LOGIN'],
                :test => true }
    FedEx.new(options)
  end

  def collect_rates
    @fedex_rates = @estimate.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

  #temporary method
  def estimate_params
    # params.require(:order).permit(:origin, :destination, :packages)
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
  end
end
