defmodule PstoreWeb.UserSessionJSON do
  use PstoreWeb, :json

  def login(%{token: token}) do
    %{
      status: "ok",
      token: token
    }
  end
end
