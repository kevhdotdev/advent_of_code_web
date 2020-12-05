defmodule Aoc.Y2015.Day03 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one(">")
      2

      iex> part_one("^>v<")
      4

      iex> part_one("^v^v^v^v^v")
      2
  """
  @impl true
  def part_one(input) do
    input |> String.split("", trim: true) |> deliver |> MapSet.size()
  end

  defp deliver(list), do: deliver(list, MapSet.new([{0, 0}]), 0, 0)

  defp deliver([], houses, _, _), do: houses

  defp deliver([h | t], houses, x, y) do
    {x, y} =
      case h do
        "^" -> {x, y - 1}
        "v" -> {x, y + 1}
        "<" -> {x - 1, y}
        ">" -> {x + 1, y}
      end

    deliver(t, MapSet.put(houses, {x, y}), x, y)
  end

  @doc ~S"""
  ## Examples
      iex> part_two("^v")
      3

      iex> part_two("^>v<")
      3

      iex> part_two("^v^v^v^v^v")
      11
  """
  @impl true
  def part_two(input) do
    input |> String.split("", trim: true) |> deliver2 |> MapSet.size()
  end

  defp deliver2(list), do: deliver2(list, MapSet.new([{0, 0}]), 0, 0, 0, 0, false)

  defp deliver2([], houses, _, _, _, _, _), do: houses

  defp deliver2([h | t], houses, x1, y1, x2, y2, robosanta) do
    {x, y} = if robosanta, do: {x2, y2}, else: {x1, y1}

    {x, y} =
      case h do
        "^" -> {x, y - 1}
        "v" -> {x, y + 1}
        "<" -> {x - 1, y}
        ">" -> {x + 1, y}
      end

    if robosanta do
      deliver2(t, MapSet.put(houses, {x, y}), x1, y1, x, y, false)
    else
      deliver2(t, MapSet.put(houses, {x, y}), x, y, x2, y2, true)
    end
  end
end
