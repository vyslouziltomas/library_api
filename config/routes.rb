Rails.application.routes.draw do
  root "library#index"

  get "admin/index"
  get "history/index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Web GUI
  get "library", to: "library#index"
  get "members", to: "library_members#index"
  get "history", to: "history#index"
  get "history/export", to: "history#export"

  patch "library/books/:id/borrow", to: "library#borrow"
  patch "library/books/:id/return", to: "library#return_book"

  get "admin", to: "admin#index"

  get "admin/books/:id/edit", to: "admin#edit_book"
  patch "admin/books/:id", to: "admin#update_book"
  post "admin/books", to: "admin#create_book"
  delete "admin/books/:id", to: "admin#delete_book"
  post "admin/books/import", to: "admin#import_books"

  post "admin/members", to: "admin#create_member"
  patch "admin/members/:id", to: "admin#update_member"
  delete "admin/members/:id", to: "admin#delete_member"

  get "admin/history/export", to: "admin#export_history"
  delete "admin/history", to: "admin#delete_history"

  # Borrowing history
  get "api/borrowings", to: "borrowings#index"
  get "api/borrowings/export", to: "borrowings#export"

  # API - Members
  scope "/api" do
    resources :members, only: [:index, :show, :create, :update, :destroy]
    post "members/import", to: "members#import"

    # API - Books
    resources :books, only: [:index, :show, :create, :update, :destroy] do
      patch :borrow, on: :member
      patch :return_book, on: :member
    end

    post "books/import", to: "books#import"
  end

end