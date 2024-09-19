defmodule PstoreWeb.WelcomeJSON do
  @doc """
  Renders welcome
  """
  def index(%{ip: ip}) do
    "Hello! login at #{ip}/login"
  end
end
