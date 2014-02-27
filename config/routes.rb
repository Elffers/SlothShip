SlothShip::Application.routes.draw do

  get '/ups_estimate' => 'ups#estimate'
  get '/' => 'ups#go_estimate'
  
end
