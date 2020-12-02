defmodule Aoc.Y2018.Day14 do
  def part_one(input) do
    input = String.to_integer(input)

    {recipes, _, _} = new_recipes([3, 7], 0, 1, 0, input + 10)

    recipes
    |> Enum.split(input)
    |> elem(1)
    |> Enum.split(10)
    |> elem(0)
    |> Enum.join()
  end

  def new_recipes(recipes, elf1, elf2, max, max), do: {recipes, elf1, elf2}

  def new_recipes(recipes, elf1, elf2, count, max) do
    elf1r = Enum.at(recipes, elf1)
    elf2r = Enum.at(recipes, elf2)

    new_recipes =
      (elf1r + elf2r)
      |> Integer.to_string()
      |> String.split("")
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.map(&String.to_integer(&1))

    recipes = recipes ++ new_recipes
    elf1 = rem(elf1 + elf1r + 1, length(recipes))
    elf2 = rem(elf2 + elf2r + 1, length(recipes))

    new_recipes(recipes, elf1, elf2, count + 1, max)
  end

  def find_string(recipe, string, elf1, elf2) do
    if Enum.random(0..100) == 43, do: IO.puts(length(recipe))

    cond do
      String.ends_with?(Enum.join(recipe), string) ->
        Regex.compile(string)
        |> elem(1)
        |> Regex.run(Enum.join(recipe), return: :index)
        |> List.first()
        |> elem(0)

      true ->
        {recipe, elf1, elf2} = new_recipes(recipe, elf1, elf2, 0, 1)
        find_string(recipe, string, elf1, elf2)
    end
  end

  def part_two(input) do
    find_string([3, 7], input, 0, 1)
  end
end
