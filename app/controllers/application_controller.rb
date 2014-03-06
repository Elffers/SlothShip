require 'active_shipping'
include ActiveMerchant::Shipping
require 'shipper.rb'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :check_authenticity

  def check_authenticity
    time = request.env["HTTP_REQUEST_TIME"] # This is the field we set manually in the client
    path = request.env["PATH_INFO"] # Rails provides this key
    sig  = request.env["HTTP_REQUEST_SIGNATURE"] # This is the signature we created on the client
    method = request.method # This it the HTTP method (ie "GET")
    params.delete(:controller) # Remove the controller and action keys from params
    params.delete(:action)
    unless ClientAuthentication.new(ENV["API_KEY"], params, path, method, time, sig).authenticated?
      render status: :unauthorized, text: "403 Unauthorized"
    end
  end

end
