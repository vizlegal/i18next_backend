defmodule I18nextBackend.Backend do
  use GenServer

  def start_link(_name) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def handle_call(:translations, domain) do
    {:reply, I18nextBackend.translations(domain)}
  end
end
