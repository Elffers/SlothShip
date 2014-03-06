require 'active_shipping'
include ActiveMerchant::Shipping
require 'shipper.rb'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :check_authenticity

  def check_authenticity
    time      = request.env["HTTP_REQUEST_TIME"] # This is the field we set manually in the client
    path      = request.env["PATH_INFO"] # Rails provides this key
    signature = request.env["HTTP_REQUEST_SIGNATURE"] # This is the signature we created on the client
    method    = request.method # This it the HTTP method (ie "GET")
    params.delete(:controller) # Remove the controller and action keys from params
    params.delete(:action)
    params.delete(:format)

    unless ClientAuthentication.new("testkey", params, path, method, time, signature).authenticated?
      render status: :unauthorized, text: "Unauthorized 401"
    end
  end

end
