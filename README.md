# I18next Phoenix Backend

> Adds to your phoenix application the ability to be a remote backend for use with [i18next http backend](https://github.com/i18next/i18next-http-backend)
.

Create an endpoint easily to serve your `PO` translation files in `json` format.


## Installation

The package can be installed
by adding `i18next_backend` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:i18next_backend, git: "https://github.com/vizlegal/i18next_backend"}
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

You can use as a plug, defining a forwarded route
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

## Usage

let's imagine this translation file `priv/gettext/en/LC_MESSAGES/default.po`

```po
msgid "test"
msgstr "this is a test string"

msgid "test2"
msgid_plural "test2_plural"

msgstr[0] "this is an empty string"
msgstr[1] "this is only one"
msgstr[2] "these are several"

msgid "interpolation"
msgstr "this is a test %{interpolation}"
```

You can request for the file by lang and domain (filename) to obtain the json formatted file.
```
GET /locales/en/default.json

{
  "test": "this is a test string",
  "interpolation": "this is a test {{ interpolation }}",
  "test2": "this is only one",
  "test2_plural": "these are several"
}
```
