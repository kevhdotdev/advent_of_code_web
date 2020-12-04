defmodule Aoc.Y2020.Day04 do
  @behaviour Aoc.Day

  @required_fields ~w(byr ecl eyr hcl hgt iyr pid)

  @doc ~S"""
  ## Examples
      iex> input = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\nbyr:1937 iyr:2017 cid:147 hgt:183cm\n\niyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\nhcl:#cfa07d byr:1929\n\nhcl:#ae17e1 iyr:2013\neyr:2024\necl:brn pid:760753108 byr:1931\nhgt:179cm\n\nhcl:#cfa07d eyr:2025 pid:166559648\niyr:2011 ecl:brn hgt:59in\n"
      iex> part_one(input)
      2
  """
  @impl true
  def part_one(input) do
    input |> String.split("\n\n", trim: true) |> Enum.count(&valid?/1)
  end

  @doc ~S"""
  Returns true or false if a specific passport is valid

  ## Examples
      iex> valid?("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\nbyr:1937 iyr:2017 cid:147 hgt:183cm")
      true

      iex> valid?("iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\nhcl:#cfa07d byr:1929")
      false

      iex> valid?("hcl:#ae17e1 iyr:2013\neyr:2024\necl:brn pid:760753108 byr:1931\nhgt:179cm")
      true

      iex> valid?("hcl:#cfa07d eyr:2025 pid:166559648\niyr:2011 ecl:brn hgt:59in")
      false
  """
  def valid?(passport) do
    passport |> parse |> Map.keys() |> List.delete("cid") |> Enum.sort() == @required_fields
  end

  defp parse(passport) do
    passport
    |> String.split(~r/[ \n]/, trim: true)
    |> Enum.into(%{}, fn f ->
      [k, v] = String.split(f, ":", trim: true)
      {k, v}
    end)
  end

  @impl true
  def part_two(_input) do
  end
end
