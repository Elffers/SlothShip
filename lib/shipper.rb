class Shipper

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

  # problem with authenticating with current key
  def self.usps_client
    USPS.new(login: ENV['USPS_USERNAME'])
  end

  def self.extract_info(order)
    info = all_carriers(order).map do |rate|
      shipment = {}
      shipment[:carrier] =  rate.carrier
      shipment[:service] = rate.service_name
      shipment[:price]   = rate.price
      shipment[:delivery_date] = rate.delivery_date
      shipment
    end
    info
  end

  def self.ups_info(order)
    ups_client.find_rates(order[:origin], order[:destination], order[:packages])
  end

  def self.fedex_info(order)
    fedex_client.find_rates(order[:origin], order[:destination], order[:packages])
  end

  def self.all_carriers(order)
    ups_info(order).rates + fedex_info(order).rates
  end

end
