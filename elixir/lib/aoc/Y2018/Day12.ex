defmodule Aoc.Y2018.Day12 do
  def part_one(input) do
    {pots, rules} = parse(input)

    generation(pots, rules, 20, -2, %{})
    |> Enum.filter(fn {_, v} -> v == "#" end)
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.sum()
  end

  def part_two(input) do
    {pots, rules} = parse(input)
    #
    # results = for x <- 1..1000 do
    #   r = generation(pots, rules, x, -2, %{})
    #   |> Enum.filter(fn {k,v} -> v == "#" end)
    #   |> Enum.map(fn {k,v} -> k end)
    #   |> Enum.sum
    #   IO.inspect [x,r]
    # end |> Enum.with_index(1)
    #
    # results
    result =
      generation(pots, rules, 100, -2, %{})
      |> Enum.filter(fn {_, v} -> v == "#" end)
      |> Enum.map(fn {k, _} -> k end)
      |> Enum.sum()

    # Using the commented out code above I found that the answer increases by 51
    # for every generation about somewhere around 100 so or the answer
    # for 50,000,000,000 generations is:
    (50_000_000_000 - 100) * 51 + result
  end

  def generation(pots, _, 0, _, _), do: pots

  def generation(pots, rules, g, pot, next_gen) do
    cond do
      pot > (pots |> Map.keys() |> Enum.max()) + 2 ->
        # IO.inspect {pots |> Map.keys |> Enum.min, g, pots |> Enum.map(fn {k,v} -> {k,v} end) |> Enum.sort_by(&elem(&1,0)) |> Enum.map(&elem(&1,1)) |> Enum.join }
        generation(next_gen, rules, g - 1, (pots |> Map.keys() |> Enum.min()) - 2, %{})

      true ->
        rule = for(x <- (pot - 2)..(pot + 2), do: Map.get(pots, x, ".")) |> Enum.join()
        next_gen = Map.put(next_gen, pot, Map.get(rules, rule, "."))
        generation(pots, rules, g, pot + 1, next_gen)
    end
  end

  # ONLY APPLY RULES TO THE CURRENT GEN BEFORE STARTING THE NEXT GEN

  def parse(input) do
    [initial, _ | rules] =
      input
      |> String.trim_trailing()
      |> String.split("\n")

    initial =
      initial
      |> String.trim_leading("initial state: ")
      |> String.split("")
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.with_index()
      |> Enum.map(fn {pot, i} -> {i, pot} end)
      |> Map.new()

    rules =
      rules
      |> Enum.map(fn x -> String.split(x, " => ") |> List.to_tuple() end)
      |> Map.new()

    {initial, rules}
  end
end
