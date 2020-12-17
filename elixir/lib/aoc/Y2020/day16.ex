defmodule Aoc.Y2020.Day16 do
  @behaviour Aoc.Day

  defp test_input do
  end

  @doc ~S"""
  ## Examples
      iex> part_one("class: 1-3 or 5-7\nrow: 6-11 or 33-44\nseat: 13-40 or 45-50\n\nyour ticket:\n7,1,14\n\nnearby tickets:\n7,3,47\n40,4,50\n55,2,20\n38,6,12\n")
      71
  """
  @impl true
  def part_one(input) do
    [rules, ticket, tickets] = String.split(input, "\n\n")

    rules = for rule <- String.split(rules, "\n"), do:  ~r/([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)/ |> Regex.run(rule) |> Enum.drop(1)

    rules = expand(rules)

    tickets
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(fn t -> t|> String.split(",") |> Enum.map(&String.to_integer/1) end)
    |> List.flatten
    |> invalid(rules)
    |> Enum.sum
  end

  def expand(rules) do
    for rule <- rules do
      [min1, max1, min2, max2] = rule |> Enum.drop(1) |> Enum.map(&String.to_integer/1)
      [min1..max1, min2..max2]
    end |> List.flatten
  end

  defp invalid([], rules), do: []
  defp invalid([h|t], rules) do
    if Enum.any?(rules, fn rule -> h in rule end), do: invalid(t, rules), else: [h | invalid(t, rules)]
  end

  @impl true
  def part_two(_input) do
  end
end
