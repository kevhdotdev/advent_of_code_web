defmodule Aoc.Y2019.Day02 do
  def part_one(input, noun \\ 12, verb \\ 2) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> process
    |> Enum.at(0)
  end

  def process(list, pointer \\ 0) do
    process(list, pointer, Enum.slice(list, pointer, 4))
  end

  defp process(list, _, [99 | _]), do: list

  defp process(list, pointer, [opcode, a, b, r]) do
    list
    |> List.replace_at(r, Enum.reduce([Enum.at(list, a), Enum.at(list, b)], op(opcode)))
    |> process(pointer + 4)
  end

  defp op(1), do: &+/2
  defp op(2), do: &*/2

  def part_two(input) do
    try do
      for noun <- 0..99,
          verb <- 0..99,
          do: if(part_one(input, noun, verb) == 19_690_720, do: throw(noun * 100 + verb))
    catch
      x -> x
    end
  end
end
