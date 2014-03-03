require 'active_shipping'
include ActiveMerchant::Shipping
require 'shipper.rb' 

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def estimate_params
    params.require(:order).permit(:origin, :destination, :packages)
    order = { origin: set_origin(params[:order][:origin]),
              destination: set_destination(params[:order][:destination]),
              packages: set_packages(params[:order][:packages])
            }
    order
  end

  def set_destination(destination_hash)
    Location.new(destination_hash)
  end

  def set_origin(origin_hash)
    Location.new(origin_hash)
  end

  def set_packages(packages)
    packages.map do |package|
      pkg_weight = package[:weight].to_i
      pkg_dimensions = package[:dimensions].split(",").map {|dimension| dimension.to_i }
      Package.new(pkg_weight, pkg_dimensions, units: package[:units])
    end
  end
end
