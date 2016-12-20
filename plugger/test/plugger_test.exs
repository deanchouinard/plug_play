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

  test "request failure" do
    assert %HTTPoison.Response{status_code: 401} = HTTPoison.get!  "http://localhost:4000/"
  end

  test "request success" do
    response = HTTPoison.get!  "http://localhost:4000/", [{"authorization", "token"}]

    assert %HTTPoison.Response{status_code: 200} = response
    assert %HTTPoison.Response{body: "Plug!"} = response
   end

  test "the truth" do
    assert 1 + 1 == 2
  end
end
