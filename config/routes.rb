SlothShip::Application.routes.draw do

  get '/ups_estimate' => 'ups#estimate'
  get '/' => 'ups#mock_external_request'
  get '/' => 'ups#go_estimate'
  get '/fedex_estimate' => 'fedex#estimate'
  
end
