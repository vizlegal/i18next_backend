defmodule I18nextBackend.Backend do
  @moduledoc """
    all locales files are parsed in a Genserver
  """
  use GenServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_name) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  @spec init(any) :: {:ok, nil}
  def init(_) do
    {:ok, nil}
  end

  def handle_call({:translations, %{domain: domain, lng: lng}}, _from, state) do
    {:reply, I18nextBackend.Service.translations(lng, domain), state}
  end
end
