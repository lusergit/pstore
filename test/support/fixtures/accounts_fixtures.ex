defmodule Pstore.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pstore.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      admin_level: 0
    })
  end

  def user_fixture(attrs \\ %{}) do
    valid_attrs = valid_user_attributes(attrs)

    {:ok, user} =
      %Pstore.Accounts.User{}
      |> Pstore.Accounts.User.registration_changeset(valid_attrs)
      |> Pstore.Repo.insert()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
