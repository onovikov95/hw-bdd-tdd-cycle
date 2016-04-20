Rottenpotatoes::Application.routes.draw do
  resources :movies
  get '/movies/:id/similar_director', to: 'movies#similar_director', as: 'similar_director'
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
end
