defmodule Router do
  defmacro __using__(_opts) do
    quote do
      def init(default_opts) do
        IO.puts "starting up Helloplug..."
        default_opts
      end

      def call(conn, _opts) do
        route(conn.method, conn.path_info, conn)
      end
    end
  end
end

defmodule Helloplug do
  use Router
  
  def route("GET", [], conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "Hello, root!")
  end

  def route("GET", ["hello"], conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "Hello, world!")
  end
  
  def route("GET", ["users", user_id], conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "You requested user number #{user_id}")
  end
  
  def route(_method, _path, conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(404, "Couldn't find that page, sorry!")
  end
end

defmodule WebsiteRouter do
  use Router

  @helloplug_options Helloplug.init([])
  def route("GET", ["users" | path], conn) do
    Helloplug.call(conn, @helloplug_options)
  end

  def route(_method, _path, conn) do
    conn |> Plug.Conn.send_resp(404, "Could not find page.")
  end
end

