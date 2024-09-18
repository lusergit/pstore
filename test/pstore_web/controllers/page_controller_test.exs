defmodule PstoreWeb.PageControllerTest do
  use PstoreWeb.ConnCase

  test "GET /pets", %{conn: conn} do
    conn = get(conn, ~p"/pets")
    assert %{"data" => l} = json_response(conn, 200)
    assert is_list(l)
  end
end
