SlothShip::Application.routes.draw do

  get '/ups_estimate' => 'ups#estimate'
  get '/' => 'ups#mock_external_request'
  
end


