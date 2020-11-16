defmodule Aoc.Y2018.Day03 do
  def part_one(input) do
    input
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.map(fn l -> process_line(l) end)
    |> overlap
    |> Enum.count()
  end

  def part_two(input) do
    input =
      input
      |> String.trim_trailing("\n")
      |> String.split("\n")

    overlap =
      input
      |> Enum.map(fn l -> process_line(l) end)
      |> overlap

    cuts =
      input
      |> Enum.map(fn l -> process_line(l, true) end)

    {claim, _, _, _, _} =
      Enum.find(cuts, fn c ->
        MapSet.intersection(squares(c), overlap)
        |> Enum.count() == 0
      end)

    claim
  end

  def overlap(list), do: overlap(list, MapSet.new(), MapSet.new())
  def overlap([], _, overlap), do: overlap

  def overlap([cut | tail], cloth, overlap) do
    squares = squares(cut)
    new_overlap = MapSet.intersection(cloth, squares)
    overlap(tail, MapSet.union(cloth, squares), MapSet.union(overlap, new_overlap))
  end

  def squares({_, x, y, w, h}), do: squares({x, y, w, h})

  def squares({x, y, w, h}) do
    for(
      x <- x..(x + w - 1),
      y <- y..(y + h - 1),
      do: {x, y}
    )
    |> MapSet.new()
  end

  def process_line(line, with_claim \\ false) do
    [claim, _, xy, wh] =
      line
      |> String.split(" ")

    [x, y] =
      xy
      |> String.trim_trailing(":")
      |> String.split(",")
      |> Enum.map(fn x -> String.to_integer(x) end)

    [w, h] = wh |> String.split("x") |> Enum.map(fn x -> String.to_integer(x) end)

    case with_claim do
      true -> {claim |> String.trim_leading("#") |> String.to_integer(), x, y, w, h}
      false -> {x, y, w, h}
    end
  end
end
