Rails.application.routes.draw do
  devise_for :users

  root 'pages#root'

  resources :accounts
  resources :records

  resources :databases, only: [:new, :create], path_names: {new: :upload}
  resources :importers do
    resources :rules, shallow: true
    resources :importer_sessions, shallow: true, only: [:new, :create, :show] do
      member do
        delete 'commit'
        delete 'rollback'
      end
    end
  end
end
