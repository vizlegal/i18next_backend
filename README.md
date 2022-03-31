# I18next Phoenix Backend

> An i18next backend, create an endpoint to access to your app `PO` in json format, to be used with [i18next http backend](https://github.com/i18next/i18next-http-backend)

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

You can use as a plug in a forwarded route
```elixir
  scope "/", App do
    forward("/locales", I18nextBackend.Plug)
  end
```
In case you need to use Plug inside app namespace, you need to create a simple plug

```elixir
defmodule Plugs.I18next do
  @behaviour Plug

  @spec init(any) :: any
  def init(options), do: I18nextBackend.Plug.init(options)

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, opts),
    do:
      conn |> I18nextBackend.Plug.call(opts)
end
```
and use it in routes instead default

```elixir
  scope "/", App do
    forward("/locales", Plugs.I18next)
  end
```

Client configuration settings example:

```js
{
  crossDomain: false,
  overrideMimeType: false,
  ...
  loadPath: "/locales/{{lng}}/{{ns}}.json",
  ...
  requestOptions: {
    mode: "cors",
    credentials: "same-origin",
    cache: "default"
  }
}
```

  **ns** is the `po` file name, used as namespace in i18next

  **lng** is the language