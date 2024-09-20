defmodule PstoreWeb.UserRegistrationController do
  use PstoreWeb, :controller

  alias Pstore.Accounts
  alias PstoreWeb.UserAuth

  action_fallback PstoreWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do
      {:ok, _} =
        Accounts.deliver_user_confirmation_instructions(
          user,
          fn _ -> nil end
        )

      conn = UserAuth.log_in_user(conn, user)

      with {:ok, token} <- Map.fetch(conn.assigns, :user_token) do
        render(conn, :register, token: token)
      end
    end
  end
end
