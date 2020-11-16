defmodule Aoc.Y2018.Day02 do
  def part_one(input) do
    input =
      input
      |> String.split("\n")
      |> Enum.map(&checksum(&1))

    Enum.count(input, fn {x, _} -> x end) * Enum.count(input, fn {_, x} -> x end)
  end

  def part_two(input) do
    list =
      input
      |> String.trim_trailing("\n")
      |> String.split("\n")

    for(x <- list, y <- list, do: difference(x, y)) |> Enum.find(& &1)
  end

  defp checksum(box_id) do
    counts =
      box_id
      |> String.split("")
      |> Enum.group_by(& &1)
      |> Map.delete("")
      |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
      |> Map.new()

    {
      Enum.find(counts, fn {_, v} -> v == 2 end) && 1,
      Enum.find(counts, fn {_, v} -> v == 3 end) && 1
    }
  end

  def difference([], []), do: []
  def difference([h | t1], [h | t2]), do: [h | difference(t1, t2)]
  def difference([_ | t1], [_ | t2]), do: difference(t1, t2)

  def difference(str1, str2) do
    difference =
      str1
      |> String.graphemes()
      |> difference(String.graphemes(str2))
      |> Enum.join()

    String.length(str1) - 1 == String.length(difference) && difference
  end
end
