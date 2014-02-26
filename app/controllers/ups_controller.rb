class UpsController < ApplicationController

  def estimate(origin, destination, packages)
    @estimate = ups_client.find_rates(origin, destination, packages)
  end

  def ups_client
    UPS.new(:login => ENV['UPS_USERNAME'], :password => ENV['UPS_PASSWORD'], :key => ENV['UPS_ACCESS_KEY'])
  end
end
