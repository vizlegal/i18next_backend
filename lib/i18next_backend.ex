defmodule I18nextBackend do
  @moduledoc """
  `I18nextBackend` is a simple Plug to serve PO files in json format

    all locales files are parsed in a Genserver
  """
  use GenServer

  @ets_table :locales
  def child_spec(opts) do
    %{
      id: opts[:name] || __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  @doc """
  Start Genserver
  """
  def start_link(_name) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @spec path :: any
  def path, do: Application.get_env(:i18next_backend, :path) || "priv/gettext/en/LC_MESSAGES"

  @impl true
  @spec init(any) :: {:ok, nil}
  @doc """
  Init Backend
  """
  def init(_) do
    :ets.new(@ets_table, [:set, :public, :named_table])

    "#{path()}"
    |> File.ls!()
    |> Enum.each(fn f ->
      put(
        f |> String.replace(".po", ""),
        I18nextBackend.Service.translations(
          "en",
          "#{path() |> Path.join(f)}"
        )
      )
    end)

    {:ok, nil}
  end

  @impl true
  @doc """
  Use Service to get translations
  """

  def handle_call({:translations, %{domain: domain, lng: lng}}, _from, state) do
    {:reply, get(lng, domain), state}
  end

  def get(_lng, key) do
    case :ets.lookup(@ets_table, key) do
      [{^key, value} | _rest] -> value
      [] -> :not_found
    end
  end

  def put(key, value) do
    :ets.insert(@ets_table, {key, value})
  end
end
