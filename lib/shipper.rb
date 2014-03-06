require 'active_shipping'
include ActiveMerchant::Shipping
require 'order.rb'

class Shipper

  def self.extract_info(order)
    order = Order.new(order)
    info = all_carriers(order).map do |rate|
      shipment = {}
      shipment[:carrier]        = rate.carrier
      shipment[:service]        = rate.service_name
      shipment[:price]          = rate.price
      shipment[:delivery_date]  = rate.delivery_date
      shipment
    end
    info
  end

  def self.fastest_rates(order)
    deliverable = self.extract_info(order).keep_if { |option| option[:delivery_date].present?}
    deliverable.sort_by { |option| option[:delivery_date] }
  end

  def self.cheapest_rates(order)
    self.extract_info(order).sort_by { |option| option[:price ] }
  end

  def self.ups_client
    UPS.new(:login => ENV['UPS_USERNAME'], 
            :password => ENV['UPS_PASSWORD'], 
            :key => ENV['UPS_ACCESS_KEY']
            )
  end

  def self.fedex_client
    options = { :key=> ENV['FEDEX_KEY'],
                :password=> ENV['FEDEX_PASSWORD'],
                :account=> ENV['FEDEX_ACCOUNT'],
                :login=> ENV['FEDEX_LOGIN'],
                :test => true 
              }
    FedEx.new(options)
  end

# These make calls (.find_rates) to remote APIs via Active Shipping gem
  def self.ups_info(order)
    ups_client.find_rates(order.origin, order.destination, order.packages)
  end

  def self.fedex_info(order)
    fedex_client.find_rates(order.origin, order.destination, order.packages)
  end

  def self.all_carriers(order)
    ups_info(order).rates + fedex_info(order).rates 
  end

# nested error class to handle errors

end
