# I18nextBackend

> An i18next backend

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `i18next_backend` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:i18next_backend, "~> 0.1.0"}
  ]
end
```
Ensure `:i18next_backend` is started alongside your application by adding this to
your `mix.exs`

```elixir
def application do
  [
    applications: [:i18next_backend]
  ]
end
```
## Getting Started

Configuration for I18nextBackend must be present the Application environment. This
can be done by updating the `:i18next_backend` values in your `config/config.exs`:

```elixir
config :i18next_backend,
  folder: "priv/gettext"
```


## Integrating with Phoenix

To integrate with [Phoenix](https://hexdocs.pm/phoenix/Phoenix.html)
or any other web framework, you can take advantage of `ExHealth.Plug`
which handles serving a JSON response for you.
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/i18next_backend](https://hexdocs.pm/i18next_backend).

