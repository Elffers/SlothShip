SlothShip::Application.routes.draw do

  # get '/' => 'shipper#mock_external_request'
  
  post '/shipping_estimate' => 'shipper#estimate'

  post '/get_fastest' => 'shipper#fastest'
  post '/get_cheapest' => 'shipper#cheapest'

  
end
