defmodule PstoreWeb.WelcomeController do
  use PstoreWeb, :controller

  def index(conn, _) do
    render(conn, :index, ip: conn.host)
  end
end
