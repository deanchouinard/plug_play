defmodule HelloplugTest do
  use ExUnit.Case, async: false
  use Plug.Test

  doctest Helloplug

  setup tags do
    if tags[:user] do
      user = %User{first_name: "Fluffums", last_name: "the Cat"}
      user = Helloplug.Repo.insert!(user)
      {:ok, user: user}
    else
      :ok
    end

  end

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

  @tag :user
  test "user page", %{user: user} do
    conn = conn(:get, "/users/#{user.id}")
    conn = Helloplug.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 200
    #assert conn.resp_body == "You requested user number 6"
    #assert conn.resp_body =~ "User Information Page"
    assert conn.resp_body =~ "Fluffums"

  end

  test "missing page" do
    conn = conn(:get, "/missing")
    conn = Helloplug.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Couldn't find that page, sorry!"

  end

  @tag :user
  test "WebsiteRouter user page", %{user: user} do
    conn = conn(:get, "/users/#{user.id}")
    conn = WebsiteRouter.call(conn, [])

    assert conn.state == :sent
    assert conn.status == 200
    assert String.match?(conn.resp_body, ~r/Fluffums/)
    # assert conn.resp_body =~ "User Information Page"
    #assert conn.resp_body == "You requested user number 6"

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
