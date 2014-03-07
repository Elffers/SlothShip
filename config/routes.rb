SlothShip::Application.routes.draw do

  get  '/' => 'shipper#mock_external_request'
  get  '/shipping_estimate' => 'shipper#estimate'
  post '/shipping_estimate' => 'shipper#estimate'

  post '/shipping' => 'shipper#hello'
  post '/get_fastest' => 'shipper#fastest'
  post '/get_cheapest' => 'shipper#cheapest'

  
end
