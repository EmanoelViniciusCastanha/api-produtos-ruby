Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  get "up" => "rails/health#show", as: :rails_health_check

  # Precisa vir antes do resources pra não ser confundida com /produtos/:id.
  get "produtos/relatorio", to: "produtos#relatorio"

  resources :produtos, except: [ :new, :edit ] do
    resources :movimentacoes, only: [ :index, :create ]
  end

  root "produtos#index"
end
