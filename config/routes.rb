SlothShip::Application.routes.draw do

  get '/' => 'shipper#mock_external_request'
  
  get '/shipping_estimate' => 'shipper#estimate'
  
end
