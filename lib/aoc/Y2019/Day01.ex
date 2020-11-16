defmodule Aoc.Y2019.Day01 do
  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.reject(fn x -> x == "" end)
    |> Enum.map(&String.to_integer/1)
  end

  def part_one(input) do
    input
    |> parse
    |> Enum.map(&mass/1)
    |> Enum.sum()
  end

  def mass(m) do
    trunc(m / 3) - 2
  end

  def part_two(input) do
    input
    |> parse
    |> Enum.map(&culm_mass/1)
    |> Enum.sum()
  end

  def culm_mass(m), do: culm_mass(m, 0)

  def culm_mass(m, sum) do
    case mass(m) do
      x when x <= 0 -> sum
      x -> culm_mass(x, x + sum)
    end
  end
end
