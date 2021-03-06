defmodule Helloplug.App do
  @moduledoc """
  Code from 
[Building a Web Framework From Scratch in Elixir](https://codewords.recurse.com/issues/five/building-a-web-framework-from-scratch-in-elixir)

  $ mix run --no-halt
  $ curl localhost:4000/
  $ curl localhost:4000/hello
  $ curl localhost:4000/users/1

  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    #    IO.puts "App.start*****************"
    children = [
      supervisor(Helloplug.Repo, []),
      Plug.Adapters.Cowboy.child_spec(:http, Helloplug, [])
    ]

    opts = [strategy: :one_for_one, name: Helloplug.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

  
defmodule Router do
  defmacro __using__(_opts) do
    quote do
      def init(default_opts) do
        #   IO.puts "starting up Helloplug..."
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
  
  require EEx
  EEx.function_from_file :defp, :template_show_user, "templates/show_user.eex",
    [:user]
  def route("GET", ["users", user_id], conn) do
    case Helloplug.Repo.get(User, user_id) do
      nil ->
        conn |> Plug.Conn.send_resp(404, "User id not found")
      user ->
#    page_contents = EEx.eval_file("templates/show_user.eex", [user_id: user_id])
        page_contents = template_show_user(user)
        conn
        |> Plug.Conn.put_resp_content_type("text/html")
        |> Plug.Conn.send_resp(200, page_contents)
    end
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

