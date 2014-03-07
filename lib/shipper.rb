require 'active_shipping'
include ActiveMerchant::Shipping
require 'order.rb'

class Shipper

  def initialize(order_hash)
    @order_hash = order_hash
  end

  def order
    Order.new(@order_hash)
  end

  def extract_info
    info = all_carriers.map do |rate|
      shipment = {}
      shipment[:carrier]        = rate.carrier
      shipment[:service]        = rate.service_name
      shipment[:price]          = rate.price
      shipment[:delivery_date]  = rate.delivery_date
      shipment
    end
    info
  end

  def fastest_rates
    deliverable = self.extract_info(order).keep_if { |option| option[:delivery_date].present?}
    deliverable.sort_by { |option| option[:delivery_date] }
  end

  def cheapest_rates
    self.extract_info(order).sort_by { |option| option[:price ] }
  end

 # Clients are instances of Active Shipping classes
  def ups_client
    UPS.new(:login => ENV['UPS_USERNAME'], 
            :password => ENV['UPS_PASSWORD'], 
            :key => ENV['UPS_ACCESS_KEY']
            )
  end

  def fedex_client
    options = { :key=> ENV['FEDEX_KEY'],
                :password=> ENV['FEDEX_PASSWORD'],
                :account=> ENV['FEDEX_ACCOUNT'],
                :login=> ENV['FEDEX_LOGIN'],
                :test => true 
              }
    FedEx.new(options)
  end

# These make calls (.find_rates) to remote APIs via Active Shipping gem
  def ups_info
    ups_client.find_rates(order.origin, order.destination, order.packages)
  end

  def fedex_info
    fedex_client.find_rates(order.origin, order.destination, order.packages)
  end

  def all_carriers
    ups_info.rates + fedex_info.rates 
  end

# nested error class to handle errors

end
