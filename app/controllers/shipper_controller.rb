class ShipperController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_authenticity

  def estimate
    @estimate = Shipper.extract_info(params)
    Request.create(request: estimate_params.to_s, result: @estimate.to_s)
    respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  def fastest
    @estimate = Shipper.fastest_rates(params)
     respond_to do |format|
      format.html { render :estimate }
      format.json { render json: @estimate }
    end
  end

  def cheapest
    @estimate = Shipper.cheapest_rates(params)
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
                                          
  #   redirect_to "/shipping_estimate.json?#{estimate_hash.to_query}"
  # end

  private
  def estimate_params
    params.require(:order).permit(:origin, :destination, :packages)
  end

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
