defmodule I18nextBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
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

  def translations(domain) do
    GenServer.call(I18nextBackend.Backend, :translations, domain)
  end
end
