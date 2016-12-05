defmodule HelloWorldPlug do
  import Plug.Conn

  def init(options) do
    IO.puts "HelloWorldPlug:init"
    options
  end

  def call(%Plug.Conn{request_path: path} = conn, opts) do
    if path in opts[:paths] do 
      IO.puts "HelloWorldPlug:call"
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "Hello, World!")
    else
      conn
    end
  end
end

