class FedexController < ApplicationController

  def estimate(origin, destination, packages)
    @estimate = fedex_client.find_rates(origin, destination, packages)
  end

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
end