defmodule I18nextBackend.MixProject do
  use Mix.Project

  def project do
    [
      app: :i18next_backend,
      version: "0.1.0",
      name: "I18nextBackend",
      description: "A simple 18next backend",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      source_url: "https://github.com/vizlegal/i18next_backend",
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
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
      {:mix_audit, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.12", only: [:test], runtime: false},
      {:ex_doc, "~> 0.24", only: [:dev], runtime: false},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug, "~> 1.11"}
    ]
  end
end
