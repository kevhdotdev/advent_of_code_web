defmodule Aoc.Y2015.Day01 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples

      iex> {part_one("(())"), part_one("()()")}
      {0, 0}

      iex> {part_one("(()(()("), part_one("))(((((")}
      {3, 3}

      iex> {part_one("())"), part_one("))(")}
      {-1, -1}

      iex> part_one(")())())")
      -3
  """
  @impl true
  def part_one(input) do
    %{"(" => o, ")" => c} = input |> String.split("", trim: true) |> Enum.frequencies()
    o - c
  end

  @doc ~S"""
  ## Examples
      iex> part_two(")")
      1

      iex> part_two("()())")
      5
  """
  @impl true
  def part_two(input) do
    input |> String.split("", trim: true) |> position(0, 0)
  end

  defp position(_, i, -1), do: i
  defp position(["(" | t], i, floor), do: position(t, i + 1, floor + 1)
  defp position([")" | t], i, floor), do: position(t, i + 1, floor - 1)
end
