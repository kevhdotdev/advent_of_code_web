defmodule Aoc.Y2019.Day06 do
  @doc ~S"""
  Maps orbits

  ## Examples
  iex> Aoc2019.Day06.map_orbits("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L")
  %{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}
  """
  def map_orbits(orbits) do
    orbits
    |> String.split("\n")
    |> Enum.map(fn x -> String.split(x, ")") end)
    |> Enum.reduce(%{}, fn [v, k], acc -> Map.put(acc, k, v) end)
  end

  @doc ~S"""
  Counts orbits for one object

  ## Examples
  iex> Aoc2019.Day06.count_orbits(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "D")
  3

  iex> Aoc2019.Day06.count_orbits(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "L")
  7

  iex> Aoc2019.Day06.count_orbits(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "COM")
  0
  """
  def count_orbits(orbits, object) do
    orbits
    |> path(object)
    |> Enum.count()
  end

  @doc ~S"""
  Counts total orbits

  ## Examples
   iex> Aoc2019.Day06.count_orbits(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"})
   42
  """
  def count_orbits(orbits) do
    orbits
    |> Map.keys()
    |> Enum.map(fn o -> count_orbits(orbits, o) end)
    |> Enum.sum()
  end

  @doc ~S"""
  Path to COM for one object

  ## Examples
  iex> Aoc2019.Day06.path(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "D")
  ["C", "B", "COM"]

  iex> Aoc2019.Day06.path(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "L")
  ["K","J","E","D","C","B","COM"]

  iex> Aoc2019.Day06.path(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "COM")
  []
  """
  def path(orbits, object)
  def path(_, object) when object == "COM", do: []

  def path(orbits, object) do
    parent = orbits[object]
    [parent] ++ path(orbits, parent)
  end

  def part_one(input) do
    input
    |> map_orbits
    |> count_orbits
  end

  def part_two(input) do
    dist =
      input
      |> map_orbits
      |> dist_between("YOU", "SAN")

    dist - 2
  end

  @doc ~S"""
  Distance between two objects

  ## Examples
  iex> Aoc2019.Day06.dist_between(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "K", "I")
  4

  iex> Aoc2019.Day06.dist_between(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "I", "H")
  5

  iex> Aoc2019.Day06.dist_between(%{"B" => "COM", "C" => "B", "D" => "C", "E" => "D", "F" => "E", "G" => "B", "H" => "G", "I" => "D", "J" => "E", "K" => "J", "L" => "K"}, "F", "J")
  2
  """
  def dist_between(orbits, a, b) do
    p1 = MapSet.new(path(orbits, a))
    p2 = MapSet.new(path(orbits, b))
    MapSet.size(MapSet.union(MapSet.difference(p1, p2), MapSet.difference(p2, p1))) + 2
  end
end
