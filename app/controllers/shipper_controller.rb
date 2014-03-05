class ShipperController < ApplicationController
  skip_before_action :verify_authenticity_token

  def estimate
    @estimate = Shipper.extract_info(estimate_params)
    Request.create(request: estimate_params.to_s, result: @estimate.to_s)
    respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  def fastest
    @estimate = Shipper.fastest_rates(estimate_params)
     respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  def cheapest
    @estimate = Shipper.cheapest_rates(estimate_params)
     respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  #test method to simulate external request for estimate

  # def mock_external_request
  #   estimate_hash = {order: {} }
  #   estimate_hash[:order][:packages] =[ { weight: 100,
  #                                         dimensions: "93, 10, 5", #breaks if this is an array
  #                                         units: "metric" 
  #                                       },

  #                                       { weight: (7.5 * 16),
  #                                         dimensions: "15, 10, 4.5",
  #                                         units: "imperial"
  #                                       }
  #                                     ]
  #   estimate_hash[:order][:origin] =  { :country => 'US',
  #                                       :state => 'CA',
  #                                       :city => 'Beverly Hills',
  #                                       :zip => '90210'
  #                                     }

  #   estimate_hash[:order][:destination] = { :country => 'US',
  #                                           :state => 'WA',
  #                                           :city => 'Seattle',
  #                                           :postal_code => '98117'
  #                                         }
                                          
  #   redirect_to "/get_estimate.json?#{estimate_hash.to_query}"
  # end

  private
  # put these in a class?
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
