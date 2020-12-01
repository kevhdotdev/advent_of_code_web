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

  @doc ~S"""
  ## Examples

  iex> part_two("1721\n979\n366\n299\n675\n1456\n514579\n")
  241861950
  """
  @impl true
  def part_two(input) do
    expenses = input |> String.trim() |> String.split() |> Enum.map(&String.to_integer/1)

    try do
      for x <- expenses,
          y <- expenses,
          z <- expenses,
          do: if(x + y + z == 2020, do: throw(x * y * z))
    catch
      x -> x
    end
  end
end
