Rails.application.routes.draw do
  get '/histogram', to: 'histogram#query'
end
