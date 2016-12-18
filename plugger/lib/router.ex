defmodule Plugger.ShowName do
  def init(opts), do: opts

  def call(conn, opts) do
    IO.puts opts[:name]
    conn
  end
end

defmodule Plugger.Router do
  use Plug.Router

  plug Plugger.Authenticate, [token: "token"]
  plug :match
  plug :dispatch

  plug :say_hello
  plug Plugger.ShowName, [name: "Dean"]

  get "/" do
    conn
    |> send_resp(200, "Plug!")
  end
  
  def say_hello(conn, _params) do
    IO.puts "hello!"
    conn
  end

  def start_link do
    Plug.Adapters.Cowboy.http(Plugger.Router, [])
  end

end

