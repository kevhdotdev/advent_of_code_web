defmodule Aoc.Y2015.Day05 do
  @behaviour Aoc.Day

  @impl true
  def part_one(input) do
    input |> String.split("\n", trim: true) |> Enum.count(&nice?/1)
  end

  @doc ~S"""
  ## Examples
  iex> nice?("ugknbfddgicrmopn")
  true

  iex> nice?("aaa")
  true

  iex> nice?("jchzalrnumimnmhp")
  false

  iex> nice?("haegwjzuvuyypxyu")
  false

  iex> nice?("dvszwmarrgswjxmb")
  false
  """
  def nice?(list) when is_list(list), do: nice?(list, 0, false)
  def nice?(string), do: string |> String.split("", trim: true) |> nice?(0, false)
  def nice?([_], _, false), do: false
  def nice?([last], vowels, true), do: if(vowel_count(last, vowels) >= 3, do: true, else: false)
  def nice?(_, 3, true), do: true

  def nice?([a, a | t], vowels, _) do
    case vowel_count(a, vowels) do
      3 -> true
      count -> nice?([a | t], count, true)
    end
  end

  def nice?([a, b | t], vowels, double) do
    if "#{a}#{b}" in ~w(ab cd pq xy) do
      false
    else
      nice?([b | t], vowel_count(a, vowels), double)
    end
  end

  defp vowel_count(char, count), do: if(char in ~w(a e i o u), do: count + 1, else: count)

  @impl true
  def part_two(_input) do
  end
end
