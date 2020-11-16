defmodule Aoc.Y2018.Day01 do
  def part_one(input) do
    input
    |> parse
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> parse
    |> process(MapSet.new([0]), [], 0)
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def process(input, frequencies, [], freq), do: process(input, frequencies, input, freq)

  def process(input, frequencies, [inst | tail], freq) do
    freq = freq + inst

    cond do
      MapSet.member?(frequencies, freq) -> freq
      true -> process(input, MapSet.put(frequencies, freq), tail, freq)
    end
  end
end
