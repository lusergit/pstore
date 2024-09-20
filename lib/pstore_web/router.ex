defmodule PstoreWeb.Router do
  use PstoreWeb, :router

  import PstoreWeb.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PstoreWeb do
    pipe_through [:api, :require_authenticated_user]

    resources "/pets", PetController

    put "/users/settings", UserSessionController, :update
    put "/users/settings", UserSessionController, :confirm_email

    delete "/users/logout", UserSessionController, :delete
  end

  scope "/", PstoreWeb do
    pipe_through :api

    post "/users/register", UserRegistrationController, :create
    post "/users/login", UserSessionController, :create
  end
end
