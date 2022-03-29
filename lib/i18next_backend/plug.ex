defmodule I18nextBackend.Plug do
  @moduledoc """
  A plug for integerating into a web application.
  ## Examples
  In Phoenix `router.ex`:
      scope "/" do
        forward("/translations/:lng/:ns", I18nextBackend.Plug)
      end

  """
  import Plug.Conn
  @behaviour Plug

  @spec init(any) :: any
  def init(opts), do: opts

  # defp http_status(%ExHealth.Status{result: %{msg: :healthy}}), do: 200
  # defp http_status(%ExHealth.Status{}), do: 503

  @spec call(any, any) :: none
  def call(%Plug.Conn{path_info: path_info} = conn, _opts) do
    [lng, domain] = path_info

    conn
    |> put_resp_content_type("application/json", "UTF-8")
    |> send_resp(
      200,
      lng
      |> I18nextBackend.translations(domain)
      |> Jason.encode!()
    )
    |> halt()
  end
end
