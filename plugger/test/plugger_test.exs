defmodule PluggerTest do
  use ExUnit.Case
  use Plug.Test

  doctest Plugger


  test "root directory" do
    conn = conn(:get, "/")
    conn = Plug.Conn.put_req_header(conn, "authorization", "token")
    conn = Plugger.Router.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Plug!"
  end

  test "authorization failure" do
    conn = conn(:get, "/")
    conn = Plug.Conn.put_req_header(conn, "authorization", "blah")
    conn = Plugger.Router.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 401
  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end
