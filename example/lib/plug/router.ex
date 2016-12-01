defmodule Example.Plug.Router do
  use Plug.Router

  plug HelloWorldPlug, paths: ["/hello"]

  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Welcome")
  # get "/hello", do: send_resp(conn, 200, "hello")
  get "/hello", do: conn
  match _, do: send_resp(conn, 404, "Oops!")

end

