defmodule PstoreWeb.UserAuth do
  use PstoreWeb, :verified_routes

  import Plug.Conn

  alias Pstore.Accounts

  @doc """
  Logs the user in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_user(conn, user, _params \\ %{}) do
    token = Accounts.create_user_api_token(user)

    conn
    |> log_out_user()
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_user(conn) do
    with {:ok, user_token} <- Map.fetch(conn.assigns, :user_token) do
      user_token && Accounts.delete_user_session_token(user_token)
      update_in(conn.assigns, &Map.drop(&1, [:user_token, :current_user]))
    else
      _ -> conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    case try_authenticate(conn) do
      {:ok, token, user} ->
        conn
        |> assign(:current_user, user)
        |> assign(:user_token, token)

      {:error, status} ->
        conn
        |> resp(status, "")
        |> send_resp()
        |> halt()
    end
  end

  def try_authenticate(conn) do
    fetch_api_user(conn)
  end

  def fetch_api_user(conn, _opts \\ %{}) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Accounts.fetch_user_by_api_token(token) do
      {:ok, token, user}
    else
      _ -> {:error, 403}
    end
  end
end
