require 'active_shipping'
include ActiveMerchant::Shipping

class FedexController < ApplicationController

  def estimate
    @estimate = extract_info(estimate_params)
    respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  private

  def extract_info(order)
    response = Shipper.fedex_client.find_rates(order[:origin], order[:destination], order[:packages])
    @info = response.rates.map do |rate|
      shipment = {}
      shipment[:carrier] =  rate.carrier
      shipment[:service] = rate.service_name
      shipment[:price]   = rate.price
      shipment[:delivery_date] = rate.delivery_date
      shipment
    end
    @info
  end

  # def fedex_client
  #   options = { :key=> ENV['FEDEX_KEY'],
  #               :password=> ENV['FEDEX_PASSWORD'],
  #               :account=> ENV['FEDEX_ACCOUNT'],
  #               :login=> ENV['FEDEX_LOGIN'],
  #               :test => true }
  #   FedEx.new(options)
  # end

end

# [{"service":"FedEx First Overnight","price":22165,"delivery_date":"2014-03-04T00:00:00+00:00"},{"service":"FedEx Priority Overnight","price":8245,"delivery_date":"2014-03-04T00:00:00+00:00"},{"service":"FedEx Standard Overnight","price":14647,"delivery_date":"2014-03-04T00:00:00+00:00"},{"service":"FedEx 2 Day Am","price":7011,"delivery_date":"2014-03-05T00:00:00+00:00"},{"service":"FedEx 2 Day","price":6193,"delivery_date":"2014-03-05T00:00:00+00:00"},{"service":"FedEx Express Saver","price":4747,"delivery_date":"2014-03-06T00:00:00+00:00"},{"service":"FedEx Ground Home Delivery","price":2454,"delivery_date":null}]
