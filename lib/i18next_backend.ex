defmodule I18nextBackend do
  @moduledoc """
  `I18nextBackend` is a simple Plug to serve PO files in json format

    all locales files are parsed in a Genserver
  """
  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  @doc """
  Starts the I18nextBacked Application
  """
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: I18nextBackend.Worker.start_link(arg)
      # {I18nextBackend.Worker, arg}
      I18nextBackend.Backend
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: I18nextBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Stops the I18nextBacked Application.
  """
  @spec stop() :: :ok
  def stop() do
    Supervisor.stop(I18nextBackend.Supervisor, :normal)
  end

  @spec translations(any, any) :: any
  @doc """
  Use Backend to get `po` files as `json`
  """
  def translations(lng, domain) do
    I18nextBackend.Backend
    |> GenServer.call({:translations, %{lng: lng, domain: domain |> String.replace(".json", "")}})
  end
end
