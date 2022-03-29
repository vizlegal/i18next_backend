defmodule I18nextBackend.Service do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  @spec translations(binary, binary | list) :: any
  @doc """
    Return a PO file or a list of PO files as a map.

    ## Examples

    iex> translations("en", ["default"])
    %{"default" => %{"test" => "this is a test string", "test.interpolation" => "this is a test {{ interpolation }}","test.plural" => "this is an empty plural string","test.plural_plural" => "this is some ones"}}

    iex> translations("en", "default")
    %{"test" => "this is a test string", "test.interpolation" => "this is a test {{ interpolation }}","test.plural" => "this is an empty plural string","test.plural_plural" => "this is some ones"}
  """
  def translations(lng, domains) when is_list(domains) do
    domains
    |> Enum.reduce(%{}, fn domain, translations ->
      translations
      |> Map.merge(%{"#{domain}" => lng |> translations(domain)})
    end)
  end

  def translations(lng, domain) when is_binary(domain) do
    # TODO configure po folder by settings
    case Gettext.PO.parse_file(
           "priv/gettext/#{lng}/LC_MESSAGES/#{domain |> String.replace(".json", "")}.po"
         ) do
      {:ok, %Gettext.PO{} = entries} ->
        entries.translations
        |> Enum.reduce(%{}, &merge_translation/2)
        |> Stream.map(fn {key, translation} ->
          {key, Regex.replace(~r/(%{)(.+?)(})/, translation, "{{ \\2 }}")}
        end)
        |> Enum.to_list()
        |> Enum.into(%{})

      {:error, _} ->
        %{}
    end
  end

  defp merge_translation(%Gettext.PO.Translation{} = entry, translations) do
    translations
    |> Map.merge(%{
      "#{entry.msgid |> List.first()}" => entry.msgstr |> List.first()
    })
  end

  defp merge_translation(%Gettext.PO.PluralTranslation{} = entry, translations) do
    translations
    |> Map.merge(%{
      "#{entry.msgid |> List.first()}" => entry.msgstr |> Map.get(0) |> List.first()
    })
    |> Map.merge(%{
      "#{entry.msgid_plural |> List.first()}" => entry.msgstr |> Map.get(2) |> List.first()
    })
  end
end
