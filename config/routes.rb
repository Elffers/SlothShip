SlothShip::Application.routes.draw do

  get '/' => 'ups#mock_external_request'
  
  get '/shipping_estimate' => 'shipper#estimate'
  post '/hello' => 'shipper#hello'
  
end
