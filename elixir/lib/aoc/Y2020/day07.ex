defmodule Aoc.Y2020.Day07 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
  iex> part_one "light red bags contain 1 bright white bag, 2 muted yellow bags.\ndark orange bags contain 3 bright white bags, 4 muted yellow bags.\nbright white bags contain 1 shiny gold bag.\nmuted yellow bags contain 2 shiny gold bags, 9 faded blue bags.\nshiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.\ndark olive bags contain 3 faded blue bags, 4 dotted black bags.\nvibrant plum bags contain 5 faded blue bags, 6 dotted black bags.\nfaded blue bags contain no other bags.\ndotted black bags contain no other bags.\n"
  4
  """
  @impl true
  def part_one(input) do
    tree =
      input
      |> String.split("\n", trim: true)
      |> parse(1)

    tree
    |> can_contain(tree, "shiny gold", MapSet.new())
    |> MapSet.size()
  end

  defp can_contain([], _, _, answers), do: answers

  defp can_contain([{parent, children} | t], tree, bag, answers) do
    if bag in children do
      answers
      |> MapSet.put(parent)
      |> MapSet.union(can_contain(tree, tree, parent, MapSet.new()))
    else
      MapSet.new()
    end
    |> MapSet.union(t |> can_contain(tree, bag, answers))
  end

  @doc ~S"""
  ## Examples
  iex> part_two "light red bags contain 1 bright white bag, 2 muted yellow bags.\ndark orange bags contain 3 bright white bags, 4 muted yellow bags.\nbright white bags contain 1 shiny gold bag.\nmuted yellow bags contain 2 shiny gold bags, 9 faded blue bags.\nshiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.\ndark olive bags contain 3 faded blue bags, 4 dotted black bags.\nvibrant plum bags contain 5 faded blue bags, 6 dotted black bags.\nfaded blue bags contain no other bags.\ndotted black bags contain no other bags.\n"
  32
  """
  @impl true
  def part_two(input) do
    tree =
      input
      |> String.split("\n", trim: true)
      |> parse(2)
      |> contains("shiny gold")
  end

  defp parse([], _), do: []

  defp parse([h | t], part) do
    [parent, rest] = String.split(h, " bags contain ")

    [
      {parent,
       for child <- String.split(rest, ~r/ bags?[,.] ?/), child != "" && child != "no other" do
         [count, colour] = String.split(child, " ", parts: 2)
         if part == 1, do: colour, else: {colour, String.to_integer(count)}
       end}
      | parse(t, part)
    ]
  end

  def contains(tree, parent) do
    {^parent, children} = Enum.find(tree, fn {p, _} -> p == parent end)

    for {child, count} <- children do
      count + count * contains(tree, child)
    end
    |> Enum.sum()
  end
end
