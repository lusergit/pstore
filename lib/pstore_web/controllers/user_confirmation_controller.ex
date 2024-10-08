defmodule PstoreWeb.UserConfirmationController do
  use PstoreWeb, :controller

  alias Pstore.Accounts

  action_fallback PstoreWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email}}) do
    with {:ok, user} <- Accounts.fetch_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        fn _ -> nil end
      )
    end

    render(
      conn,
      :message_ok,
      msg:
        "If your email is in our system and it has not been confirmed yet, " <>
          "you will receive an email with instructions shortly."
    )
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def update(conn, %{"token" => token}) do
    with {:ok, _} <- Accounts.confirm_user(token) do
      render(conn, :message_ok, msg: "User confirmed successfully.")
    end
  end
end
