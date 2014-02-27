SlothShip::Application.routes.draw do

  get '/ups_estimate' => 'ups#estimate', as: :estimate
  # get '/send' => "ups#send"
end
