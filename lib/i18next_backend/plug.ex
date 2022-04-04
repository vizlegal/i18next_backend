defmodule I18nextBackend.Plug do
  @moduledoc """
  A plug for integerating into a web application.
  ## Examples
  In Phoenix `router.ex`:
      scope "/" do
        forward("/translations", I18nextBackend.Plug)
      end

  """
  import Plug.Conn
  @behaviour Plug

  @spec init(any) :: atom | binary | [any] | number | tuple | map
  @doc """
  Init Plug
  """
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  @doc """
  Return Json response
  """
  def call(%Plug.Conn{path_info: path_info} = conn, _opts) do
    case path_info do
      [lng, domain] ->
        conn
        |> put_resp_content_type("application/json", "UTF-8")
        |> send_resp(
          200,
          lng
          |> I18nextBackend.translations(domain)
          |> Jason.encode!()
        )
        |> halt()

      _ ->
        conn
        |> put_resp_content_type("application/json", "UTF-8")
        |> send_resp(500, Jason.encode!(%{}))
    end
  end
end
