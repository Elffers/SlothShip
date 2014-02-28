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
    response = fedex_client.find_rates(order[:origin], order[:destination], order[:packages])
    @info = response.rates.map do |rate|
      shipment = {}
      shipment[:service] = rate.service_name
      shipment[:price]   = rate.price
      shipment[:delivery_date] = rate.delivery_date
      shipment
    end
    @info
  end

  def fedex_client
    options = { :key=> ENV['FEDEX_KEY'],
                :password=> ENV['FEDEX_PASSWORD'],
                :account=> ENV['FEDEX_ACCOUNT'],
                :login=> ENV['FEDEX_LOGIN'],
                :test => true }
    FedEx.new(options)
  end

end
