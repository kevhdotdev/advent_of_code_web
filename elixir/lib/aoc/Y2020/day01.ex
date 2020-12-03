defmodule Aoc.Y2020.Day01 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples

      iex> part_one("1721\n979\n366\n299\n675\n1456\n")
      514579

      # Duplicates don't count
      iex> part_one("1010\n1721\n979\n366\n299\n675\n1456\n")
      514579
  """
  @impl true
  def part_one(input) do
    input |> String.trim() |> String.split() |> Enum.map(&String.to_integer/1) |> match
  end

  defp match([h | t]) do
    if((2020 - h) in t, do: h * (2020 - h), else: match(t))
  end

  @doc ~S"""
  ## Examples

      iex> part_two("1721\n979\n366\n299\n675\n1456\n")
      241861950

      # Duplicates don't count
      iex> part_two("564\n1721\n979\n366\n299\n675\n1456\n")
      241861950
  """
  @impl true
  def part_two(input) do
    input |> String.trim() |> String.split() |> Enum.map(&String.to_integer/1) |> match3()
  end

  defp match3(list), do: match3(list, list)

  defp match3([_, h | t], []), do: match3([h | t], t)

  defp match3([h1 | t1], [h2 | t2]) do
    if((2020 - h1 - h2) in t2) do
      h1 * h2 * (2020 - h1 - h2)
    else
      match3([h1 | t1], t2)
    end
  end
end
