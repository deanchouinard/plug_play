defmodule LearningPlugTest do
  use ExUnit.Case
  use Plug.Test
  
  doctest LearningPlug

  test "make connection" do
    conn = conn(:get, "/bob")
    conn = LearningPlug.call(conn, LearningPlug.init(%{}))

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, bob"
  end

  test "pipeline" do
    conn = conn(:get, "/bob")
    conn = MyPipeline.call(conn, MyPipeline.init(%{}))

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, bob"
  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end
