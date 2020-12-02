defmodule Aoc.Y2019.Day04 do
  def valid?(pass) when is_integer(pass),
    do: valid?(pass |> Integer.to_string() |> String.split(""))

  def valid?([_, _], double, increasing), do: double && increasing

  def valid?([a, b | t], double \\ false, increasing \\ true),
    do: valid?([b | t], double || a == b, increasing && a <= b)

  def part_one(input), do: input |> parse |> Enum.count(&valid?/1)

  def valid2?(pass) do
    pass
    |> Integer.to_string()
    |> String.split("")
    |> Enum.chunk_by(fn x -> x end)
    |> Enum.find(fn x -> length(x) == 2 end)
  end

  def part_two(input) do
    input
    |> parse
    |> Enum.filter(&valid?/1)
    |> Enum.count(&valid2?/1)
  end

  defp parse(input) do
    [min, max] = input |> String.split("-") |> Enum.map(&String.to_integer/1)
    min..max
  end
end
