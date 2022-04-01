defmodule I18nextBackendTest do
  # use ExUnit.Case, async: false

  # def ensure_down(_) do
  #   case Process.whereis(I18nextBackend.Supervisor) do
  #     nil -> :ok
  #     _ -> I18nextBackend.stop()
  #   end
  # end

  # setup :ensure_down

  # test "translations/2 will return some translations" do
  #   {:ok, _pid} = I18nextBackend.start(:normal, %{})

  #   assert I18nextBackend.translations("en", "default.json") ==
  #            %{
  #              "test" => "this is a test string",
  #              "test.interpolation" => "this is a test {{ interpolation }}",
  #              "test.plural" => "this is an empty plural string",
  #              "test.plural_plural" => "this is some ones"
  #            }
  # end
end
