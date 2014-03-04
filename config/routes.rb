SlothShip::Application.routes.draw do

  get '/' => 'shipper#mock_external_request'
  
  get '/shipping_estimate' => 'shipper#estimate'
  get '/get_fastest' => 'shipper#fastest'
  get '/get_cheapest' => 'shipper#cheapest'

  post '/hello' => 'shipper#hello'
  
end
