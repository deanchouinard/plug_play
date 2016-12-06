defmodule LearningPlug do
  import Plug.Conn

  def init(opts) do
    Map.put(opts, :my_option, "Hello")
  end

  def call(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
    send_resp(conn, 200, "#{opts[:my_option]}, #{name}")
  end

end
