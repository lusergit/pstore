defmodule PstoreWeb.UserSessionController do
  use PstoreWeb, :controller

  alias Pstore.Accounts
  alias PstoreWeb.UserAuth

  action_fallback PstoreWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    with {:ok, user} <- Accounts.fetch_user_by_email_and_password(email, password) do
      conn =
        conn
        |> UserAuth.log_in_user(user, user_params)

      token = conn.assigns.user_token
      render(conn, :login, token: token)
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
    |> render(:message_ok, msg: "User logged out successfully")
  end
end
