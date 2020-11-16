defmodule Aoc.Input do
  def exists?(year, day), do: filename(year, day) |> File.exists?()

  def as_string(year, day) do
    case File.read(filename(year, day)) do
      {:ok, input} -> String.replace_trailing(input, "\n", "")
      {:error, _} -> :no_input
    end
  end

  defp filename(year, day), do: "priv/inputs/#{year}/#{padded_number(day)}.txt"
  defp padded_number(n) when is_integer(n), do: padded_number(Integer.to_string(n))
  defp padded_number(n) when is_binary(n), do: String.pad_leading(n, 2, "0")
end
