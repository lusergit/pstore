defmodule PstoreWeb.UserResetPasswordController do
  use PstoreWeb, :controller

  alias Pstore.Accounts

  action_fallback PstoreWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email}}) do
    with {:ok, user} <- Accounts.fetch_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &"POST #{url(~p[/users/reset_password/#{&1}])}"
      )
    end

    render(conn, :message_ok,
      msg:
        "If your email is in our system, you will receive instructions to reset your password shortly."
    )
  end

  def update(conn, %{"user" => user}) do
    %{"token" => token} = conn.params

    with {:ok, original_user} <- Accounts.fetch_user_by_reset_password_token(token),
         {:ok, user} <- Accounts.reset_user_password(original_user, user) do
      render(conn, :data, data: user)
    end
  end
end
