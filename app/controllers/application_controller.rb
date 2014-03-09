require 'active_shipping'
include ActiveMerchant::Shipping
require 'shipper.rb'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :check_authenticity

  def check_authenticity
    time      = request.env['HTTP_REQUEST_TIME']
    path      = request.env['PATH_INFO']
    signature = request.env['HTTP_REQUEST_SIGNATURE']
    method    = request.method
    params.delete(:controller)
    params.delete(:action)
    params.delete(:format)
    incoming_request = ClientAuthentication.new('testkey', params, path, method, time, signature)
    unless incoming_request.authenticated?
      render status: :unauthorized, text: 'Unauthorized 401'
    end
  end
end
