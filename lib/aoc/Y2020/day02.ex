defmodule Aoc.Y2020.Day02 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples

      iex> part_one("1-3 a: abcde\n1-3 b: cdefg\n2-9 c: ccccccccc\n")
      2
  """
  @impl true
  def part_one(input) do
    input |> String.trim() |> String.split("\n") |> Enum.count(&valid?/1)
  end

  @doc ~S"""
  Returns true/false depending on the validity of a line

      iex> valid?("1-3 a: abcde")
      true

      iex> valid?("1-3 b: cdefg")
      false

      iex> valid?("2-9 c: ccccccccc")
      true
  """
  def valid?(line) do
    [^line, min, max, char, password] = Regex.run(~r/(\d+)\-(\d+) (\w): (\w+)/, line)

    freqs = password |> String.split("") |> Enum.frequencies()

    freqs[char] >= String.to_integer(min) && freqs[char] <= String.to_integer(max)
  end

  @doc ~S"""
  ## Examples

      iex> part_two("1-3 a: abcde\n1-3 b: cdefg\n2-9 c: ccccccccc\n")
      1
  """
  @impl true
  def part_two(input) do
    input |> String.trim() |> String.split("\n") |> Enum.count(&valid2?/1)
  end

  @doc ~S"""
  Returns true/false depending on the validity of a line

      iex> valid2?("1-3 a: abcde")
      true

      iex> valid2?("1-3 b: cdefg")
      false

      iex> valid2?("2-9 c: ccccccccc")
      false
  """
  def valid2?(line) do
    [^line, a, b, char, password] = Regex.run(~r/(\d+)\-(\d+) (\w): (\w+)/, line)

    at_a = password |> String.at(String.to_integer(a) - 1)
    at_b = password |> String.at(String.to_integer(b) - 1)

    case {at_a, at_b} do
      {^char, ^char} -> false
      {^char, _} -> true
      {_, ^char} -> true
      _ -> false
    end
  end
end
