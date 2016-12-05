defmodule Example.Plug.VerifyRequest do
  import Plug.Conn

  defmodule IncompleteRequestError do
    @moduledoc """
    Error raised when a required field is missing.
    """

    defexception [message: "show an error?", plug_status: 400]
    #     defexception message: "show an error?"
  end

  def init(options), do: options

  def call(%Plug.Conn{request_path: path} = conn, opts) do
    if path in opts[:paths], do: verify_request!(conn.body_params,
      opts[:fields])
    conn
  end

  defp verify_request!(body_params, fields) do
    IO.puts "verify_request!"
    IO.inspect body_params
    IO.inspect fields
    verified = body_params
      |> Map.keys
      |> IO.inspect
      |> contains_fields?(fields)
    IO.inspect verified
    unless verified, do: raise IncompleteRequestError
  end

  defp contains_fields?(keys, fields), do:
    Enum.all?(fields, &(&1 in keys))
end

