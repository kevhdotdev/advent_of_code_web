defmodule Aoc.Y2018.Day06 do
  def part_one(input) do
    map = create_map(input)
    [[min_x, max_x], [min_y, max_y]] = map_boundaries(map)

    map = List.flatten(for x <- min_x..max_x, y <- min_y..max_y, do: closest_loc(map, map, x, y))

    infinite =
      Enum.filter(map, fn {x, y, _, t} ->
        t == nil && (x == min_x || x == max_x || y == min_y || y == max_y)
      end)
      |> Enum.map(&elem(&1, 2))
      |> MapSet.new()

    IO.puts("")

    # for x <- min_x..max_x do
    #   map
    #   |> Enum.filter(fn {map_x, _, _, _} -> map_x == x end)
    #   |> Enum.map(fn {_, _, l, _} -> if l == nil, do: " ", else: <<l + 65::utf8>> end)
    #   |> Enum.join()
    #   |> IO.puts()
    # end

    map
    |> Enum.filter(fn {_, _, l, _} -> !MapSet.member?(infinite, l) end)
    |> Enum.group_by(fn {_, _, l, _} -> l end)
    |> Enum.map(fn {_, v} -> Enum.count(v) end)
    |> Enum.max()
  end

  def part_two(input, region \\ 10000) do
    map = create_map(input)
    [[min_x, max_x], [min_y, max_y]] = map_boundaries(map)

    for x <- min_x..max_x do
      for y <- min_y..max_y, do: total_distance(map, x, y)
    end
    |> List.flatten()
    |> Enum.count(fn x -> x < region end)
  end

  def closest_loc(map, locations, x, y) do
    cond do
      loc = Enum.find(map, fn {lx, ly, _, _} -> {lx, ly} == {x, y} end) ->
        loc

      true ->
        [a, b | _] =
          Enum.map(locations, fn loc -> distance(loc, x, y) end)
          |> Enum.sort_by(fn {_, dist} -> dist end)

        case {a, b} do
          {{_, dist}, {_, dist}} -> {x, y, nil, nil}
          {{l, _}, _} -> {x, y, l, nil}
        end
    end
  end

  def create_map(input) do
    input
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {s, i} ->
      {x, y} = s |> String.split(", ") |> List.to_tuple()
      {elem(Integer.parse(x), 0), elem(Integer.parse(y), 0), i, :location}
    end)
  end

  def map_boundaries(map) do
    map
    |> Enum.map(fn {x, y, _, _} -> [x, y] end)
    |> Enum.zip()
    |> Enum.map(fn x ->
      x = Tuple.to_list(x)
      [Enum.min(x), Enum.max(x)]
    end)
  end

  def distance({x1, y1, n, :location}, x2, y2), do: {n, abs(x1 - x2) + abs(y1 - y2)}

  def total_distance(locations, x, y) do
    locations
    |> Enum.map(fn l -> distance(l, x, y) end)
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.sum()
  end
end
