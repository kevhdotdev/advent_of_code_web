defmodule Aoc.Y2020.Day10 do
  @behaviour Aoc.Day

  @doc ~S"""
  Examples
      iex> part_one("16\n10\n15\n5\n1\n11\n7\n19\n6\n12\n4\n")
      35

      iex> part_one("28\n33\n18\n42\n31\n14\n46\n20\n48\n47\n24\n23\n49\n45\n19\n38\n39\n11\n1\n32\n25\n35\n8\n17\n7\n9\n4\n2\n34\n10\n3\n")
      220
  """
  @impl true
  def part_one(input) do
    %{1 => ones, 3 => threes} = input |> parse |> diffs |> Enum.frequencies()

    ones * threes
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> add_device_and_outlet()
  end

  defp add_device_and_outlet(list) do
    [h | t] = Enum.reverse(list)
    [0 | Enum.reverse([h + 3, h | t])]
  end

  defp diffs([_]), do: []

  defp diffs([a, b | t]) do
    [b - a | diffs([b | t])]
  end

  @doc ~S"""
  Examples
      #iex> part_two("1\n2\n")
      #2

      #iex> part_two("16\n10\n15\n5\n1\n11\n7\n19\n6\n12\n4\n")
      #8

      #iex> part_two("28\n33\n18\n42\n31\n14\n46\n20\n48\n47\n24\n23\n49\n45\n19\n38\n39\n11\n1\n32\n25\n35\n8\n17\n7\n9\n4\n2\n34\n10\n3\n")
      #19208
  """
  @impl true
  def part_two(input) do
  end
end
