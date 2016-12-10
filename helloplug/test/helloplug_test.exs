defmodule HelloplugTest do
  use ExUnit.Case
  use Plug.Test

  doctest Helloplug
  
  test "root directory" do
    conn = conn(:get, "/")
    conn = Helloplug.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, root!"

  end

  test "makes connection" do
    conn = conn(:get, "/hello")
    conn = Helloplug.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, world!"

  end

  test "user page" do
    conn = conn(:get, "/users/6")
    conn = Helloplug.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "You requested user number 6"

  end

  test "missing page" do
    conn = conn(:get, "/missing")
    conn = Helloplug.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Couldn't find that page, sorry!"

  end

  test "WebsiteRouter user page" do
    conn = conn(:get, "/users/6")
    conn = WebsiteRouter.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "You requested user number 6"

  end
  
  test "WebsiteRouter missing page" do
    conn = conn(:get, "/missing")
    conn = WebsiteRouter.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Could not find page."

  end
  test "the truth" do
    assert 1 + 1 == 2
  end
end
