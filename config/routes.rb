Rails.application.routes.draw do
  get 'units/si', to: :get, controller: 'units'
end
