SlothShip::Application.routes.draw do

  get '/ups_estimate' => 'ups#estimate'
  get '/fedex_estimate' => 'fedex#estimate'
  
end
