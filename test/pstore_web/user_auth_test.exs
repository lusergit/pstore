defmodule PstoreWeb.UserAuthTest do
  use PstoreWeb.ConnCase, async: true

  alias Pstore.Accounts
  alias PstoreWeb.UserAuth
  import Pstore.AccountsFixtures

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, PstoreWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{user: user_fixture(), conn: conn}
  end

  describe "log_in_user/3" do
    test "stores the user token in the session", %{conn: conn, user: user} do
      conn = UserAuth.log_in_user(conn, user)
      assert token = conn.assigns[:user_token]
      assert {:ok, _} = Accounts.fetch_user_by_api_token(token)
    end
  end

  describe "logout_user/1" do
    test "works even if user is already logged out", %{conn: conn} do
      conn = UserAuth.log_out_user(conn)
      refute conn.assigns[:current_user]
      assert UserAuth.log_out_user(conn)
    end
  end

  describe "require_authenticated_user/2" do
    test "halts if user is not authenticated", %{conn: conn} do
      conn = conn |> fetch_flash() |> UserAuth.require_authenticated_user([])
      assert conn.halted
      assert conn.status == 401
    end
  end
end
