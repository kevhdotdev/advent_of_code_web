defmodule Aoc.Y2015.Day02 do
  @behaviour Aoc.Day

  @impl true
  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      l |> String.split("x") |> Enum.map(&String.to_integer/1) |> paper
    end)
    |> Enum.sum()
  end

  @doc ~S"""
  ## Examples
    iex> paper([2, 3, 4])
    58

    iex> paper([1, 1, 10])
    43
  """
  def paper([l, w, h]) do
    sides = [l * w, w * h, h * l]
    2 * Enum.sum(sides) + Enum.min(sides)
  end

  @doc ~S"""
  ## Examples
    iex> ribbon([2, 3, 4])
    34

    iex< ribbon([1, 1, 10])
    14
  """
  def ribbon([l, w, h]) do
    2 * Enum.min([l + w, w + h, h + l]) + l * w * h
  end

  @impl true
  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      l |> String.split("x") |> Enum.map(&String.to_integer/1) |> ribbon
    end)
    |> Enum.sum()
  end
end
