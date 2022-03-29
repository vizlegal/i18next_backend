defmodule I18nextBackend.MixProject do
  use Mix.Project

  def project do
    [
      app: :i18next_backend,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {I18nextBackend, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.12", only: [:test], runtime: false},
      {:ex_doc, "~> 0.24", only: [:dev], runtime: false},
      {:gettext, "~> 0.18"},
      # {:jason, "~> 1.2"},
      {:plug, "~> 1.11"}
    ]
  end
end
