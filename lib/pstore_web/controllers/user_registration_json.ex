defmodule PstoreWeb.UserRegistrationJSON do
  use PstoreWeb, :json

  def register(%{token: token}) do
    %{
      status: "ok",
      message: "User created successfully. Please check your email to confirm your account.",
      token: token
    }
  end
end
