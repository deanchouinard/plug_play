defmodule Helloplug do
  def init(default_opts) do
    IO.puts "starting up Helloplug..."
    default_opts
  end

  def call(conn, _opts) do
    IO.puts "saying hello!"
    IO.puts "saying hello!2"
    Plug.Conn.send_resp(conn, 200, "Hello, world!")
  end
end
