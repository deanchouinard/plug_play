defmodule HelloplugTest do
  use ExUnit.Case
  use Plug.Test

  doctest Helloplug

  test "makes connection" do
    conn = conn(:get, "/")
    conn = Helloplug.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, world!"

  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end
