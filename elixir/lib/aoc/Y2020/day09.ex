defmodule Aoc.Y2020.Day09 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples 
      iex> part_one("35\n20\n15\n25\n47\n40\n62\n55\n65\n95\n102\n117\n150\n182\n127\n219\n299\n277\n309\n576\n", 5)
      127
  """
  @impl true
  def part_one(input, preamble_size \\ 25) do
    input |> parse |> Enum.split(preamble_size) |> find_invalid
  end

  defp parse(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end

  defp find_invalid({preamble, [h | t]}) do
    if preamble |> Enum.uniq() |> valid?(h) do
      find_invalid({Enum.drop(preamble, 1) ++ [h], t})
    else
      h
    end
  end

  defp valid?(set, h), do: h in for(x <- set, y <- set, do: x + y)

  @doc ~S"""
  ## Examples
      iex> part_two("35\n20\n15\n25\n47\n40\n62\n55\n65\n95\n102\n117\n150\n182\n127\n219\n299\n277\n309\n576\n", 5)
      62
  """
  @impl true
  def part_two(input, preamble_size \\ 25) do
    invalid = part_one(input, preamble_size)
    input |> parse |> find_list(invalid) |> Enum.min_max() |> Tuple.to_list() |> Enum.sum()
  end

  defp find_list(list = [_ | t], x) do
    Enum.find_value(1..length(t), fn l -> find_list(list, l, x) end) || find_list(t, x)
  end

  defp find_list(list, l, x) do
    ans = Enum.slice(list, 0, l)
    Enum.sum(ans) == x && ans
  end
end
