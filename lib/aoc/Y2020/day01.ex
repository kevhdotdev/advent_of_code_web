defmodule Aoc.Y2020.Day01 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples

      iex> part_one("1721\n979\n366\n299\n675\n1456\n514579\n")
      514579
  """
  @impl true
  def part_one(input) do
    expenses = input |> String.trim() |> String.split() |> Enum.map(&String.to_integer/1)

    try do
      for x <- expenses, y <- expenses, do: if(x + y == 2020, do: throw(x * y))
    catch
      x -> x
    end
  end

  @impl true
  def part_two(_input) do
  end
end
