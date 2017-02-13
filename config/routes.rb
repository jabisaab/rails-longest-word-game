Rails.application.routes.draw do

  root to: 'words#game'

  get 'game', to: 'words#game'
  get 'score', to: 'words#score'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
