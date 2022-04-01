defmodule I18nextBackend.PlugTest do
  use ExUnit.Case, async: true

  test "call/2 returns the correct JSON payload" do
    I18nextBackend.start_link([])
    endpoint = "/en/default.json"

    result =
      Plug.Adapters.Test.Conn.conn(%Plug.Conn{}, :get, endpoint, %{})
      |> I18nextBackend.Plug.call([])

    assert %Plug.Conn{
             resp_body: body
           } = result

    assert %{
             "test" => "this is a test string",
             "test.interpolation" => "this is a test {{ interpolation }}",
             "test.plural" => "this is an empty plural string",
             "test.plural_plural" => "this is some ones"
           } = Jason.decode!(body)
  end

  test "call/2 returns empty unexistent file" do
    I18nextBackend.start_link([])
    endpoint = "/en/other.json"

    result =
      Plug.Adapters.Test.Conn.conn(%Plug.Conn{}, :get, endpoint, %{})
      |> I18nextBackend.Plug.call([])

    assert %Plug.Conn{
             resp_body: body
           } = result

    assert "not_found" = Jason.decode!(body)
  end

  test "call/2 returns uncorrect path" do
    endpoint = "/other.json"

    result =
      Plug.Adapters.Test.Conn.conn(%Plug.Conn{}, :get, endpoint, %{})
      |> I18nextBackend.Plug.call([])

    assert %Plug.Conn{
             resp_body: body
           } = result

    assert %{} = Jason.decode!(body)
  end
end
