defmodule Aoc.Y2020.Day05 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
    iex> part_one("BFFFBBFRRR\nFFFBBBFRRR\nBBFFBBFRLL")
    820
  """
  @impl true
  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&seat_id/1)
    |> Enum.max()
  end

  @doc ~S"""
  ## Examples
    iex> seat_id("BFFFBBFRRR")
    567

    iex> seat_id("FFFBBBFRRR")
    119

    iex> seat_id("BBFFBBFRLL")
    820
  """
  def seat_id(seat) do
    seat
    |> String.split("", trim: true)
    |> Enum.map(fn x -> if x in ["B", "R"], do: "1", else: "0" end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  @impl true
  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&seat_id/1)
    |> Enum.sort()
    |> find_seat
  end

  def find_seat([a, b | t]) do
    if a + 2 == b, do: a + 1, else: find_seat([b | t])
  end
end
