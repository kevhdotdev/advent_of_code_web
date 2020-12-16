defmodule Aoc.Y2020.Day15 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one("0,3,6")
      436

      iex> part_one("1,3,2")
      1

      iex> part_one("2,1,3")
      10

      iex> part_one("1,2,3")
      27

      iex> part_one("2,3,1")
      78

      iex> part_one("3,2,1")
      438

      iex> part_one("3,1,2")
      1836
  """
  @impl true
  def part_one(input) do
    {h, map} = parse(input)
    process(map, map_size(map), h, 2020 - 1)
  end

  defp parse(input) do
    [h | t] =
      input
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reverse()

    {h, t |> Enum.reverse() |> Enum.with_index() |> Map.new()}
  end

  defp process(_, max, x, max), do: x

  defp process(map, len, x, max),
    do: process(Map.put(map, x, len), len + 1, len - Map.get(map, x, len), max)

  @doc ~S"""
  I've commented this out 'cos it takes nearly a minute to run!
  ## Examples
      #iex> part_two("0,3,6")
      #175594
  """
  @impl true
  def part_two(input) do
    {h, map} = parse(input)
    process(map, map_size(map), h, 30_000_000 - 1)
  end
end
