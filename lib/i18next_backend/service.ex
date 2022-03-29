defmodule I18nextBackend.Service do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  @spec translations(binary, binary | list) :: any
  @doc """
    Return a PO file or a list of PO files as a map.

    ## Examples

    iex> get_translations(["cases", "calendar_events"])
    %{\
      "cases" => %{"error.delete" => "Error removing document", "error.disabled" => "Error disabling document", "error.enabled" => "Error enabling document", "error.get_followings" => "Error retrieving documents"},\
      "calendar_events" => %{"circuit-court" => "Circuit Court", "court-of-appeal" => "Court of Appeal", "high-court" => "High Court", "supreme-court" => "Supreme Court"}\
    }

    iex> get_translations(["cases"])
    %{"cases" => %{"error.delete" => "Error removing document", "error.disabled" => "Error disabling document", "error.enabled" => "Error enabling document", "error.get_followings" => "Error retrieving documents"}}
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
