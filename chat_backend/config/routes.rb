Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth', controllers: { sessions: 'api/auth/sessions' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: "json"} do
    resources :messages, only: [:index, :update]
    resource :user_room, only: [:update]
  end
end
