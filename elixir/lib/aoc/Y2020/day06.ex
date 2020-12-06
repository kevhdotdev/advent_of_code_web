defmodule Aoc.Y2020.Day06 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one("abc\n\na\nb\nc\n\nab\nac\n\na\na\na\na\n\nb\n")
      11
  """
  @impl true
  def part_one(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split("", trim: true)
      |> Enum.sort()
      |> Enum.dedup()
      |> List.delete("\n")
      |> length
    end)
    |> Enum.sum()
  end

  @doc ~S"""
  ## Examples
      iex> part_two("abc\n\na\nb\nc\n\nab\nac\n\na\na\na\na\n\nb\n")
      6
  """
  @impl true
  def part_two(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> MapSet.new()
      end)
      |> Enum.reduce(&MapSet.intersection/2)
      |> MapSet.size()
    end)
    |> Enum.sum()
  end
end
