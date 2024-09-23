defmodule PstoreWeb.Router do
  use PstoreWeb, :router

  import PstoreWeb.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PstoreWeb do
    pipe_through [:api, :require_authenticated_user]

    put "/users/settings", UserSessionController, :update
    put "/users/settings/confirm_email/:token", UserSessionController, :confirm_email

    delete "/users/logout", UserSessionController, :delete

    patch "/pets/:id/add", CartController, :add_to_cart
    get "/users/:id/cart", CartController, :show_open
    patch "/checkout", CartController, :checkout
    post "/empty", CartController, :empty_by_open
  end

  scope "/", PstoreWeb do
    pipe_through :api

    post "/users/confirm", UserConfirmationController, :create
    post "/users/confirm/:token", UserConfirmationController, :update

    post "/users/register", UserRegistrationController, :create

    post "/users/login", UserSessionController, :create
    post "/users/reset_password", UserResetPasswordController, :create
    put "/users/reset_password/:token", UserResetPasswordController, :update

    get "/pets", PetController, :index
    get "/pets/:id", PetController, :show
  end

  scope "/", PstoreWeb do
    pipe_through [:api, :require_admin]

    post "/pets", PetController, :create
    patch "/pets/:id", PetController, :update
    put "/pets/:id", PetController, :update
    delete "/pets/:id", PetController, :delete

    get "/carts", CartController, :index
    get "/carts/:id", CartController, :show
    post "/carts/:id/empty", CartController, :empty_by_id
  end
end
