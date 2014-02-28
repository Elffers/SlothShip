SlothShip::Application.routes.draw do

  get '/' => 'ups#mock_external_request'
  
  # get '/usps_estimate' => "usps#estimate"
  get '/ups_estimate' => 'ups#estimate'
  get '/fedex_estimate' => 'fedex#estimate'
  
end
