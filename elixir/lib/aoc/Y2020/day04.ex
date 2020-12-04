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

  @doc ~S"""
  ## Examples

      iex> part_two("eyr:1972 cid:100\nhcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926\n\niyr:2019\nhcl:#602927 eyr:1967 hgt:170cm\necl:grn pid:012533040 byr:1946\n\nhcl:dab227 iyr:2012\necl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277\n\nhgt:59cm ecl:zzz\neyr:2038 hcl:74454a iyr:2023\npid:3556412378 byr:2007\n\npid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980\nhcl:#623a2f\n\neyr:2029 ecl:blu cid:129 byr:1989\niyr:2014 pid:896056539 hcl:#a97842 hgt:165cm\n\nhcl:#888785\nhgt:164cm byr:2001 iyr:2015 cid:88\npid:545766238 ecl:hzl\neyr:2022\n\niyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719")
      4
  """
  @impl true
  def part_two(input) do
    input |> String.split("\n\n", trim: true) |> Enum.count(&valid2?/1)
  end

  defp valid2?(passport) do
    fields = passport |> parse |> Map.drop(["cid"])
    Map.keys(fields) == @required_fields && Enum.all?(fields, &valid_field?/1)
  end

  @doc ~S"""
  Validate individual fields

  Birth Year
  ## Examples
      iex> valid_field?({"byr", "2002"})
      true

      iex> valid_field?({"byr", "2003"})
      false

  Height
  ## Examples
      iex> valid_field?({"hgt", "60in"})
      true

      iex> valid_field?({"hgt", "190cm"})
      true

      iex> valid_field?({"hgt", "190in"})
      false

      iex> valid_field?({"hgt", "190"})
      false

  Hair Colour
  ## Examples
      iex> valid_field?({"hcl", "#123abc"})
      true

      iex> valid_field?({"hcl", "#123abz"})
      false

      iex> valid_field?({"hcl", "123abc"})
      false

  Eye Colour
  ## Examples
      iex> valid_field?({"ecl", "brn"})
      true

      iex> valid_field?({"ecl", "wat"})
      false

  Passport idea
  ## Examples
      iex> valid_field?({"pid", "000000001"})
      true

      iex> valid_field?({"pid", "0123456789"})
      false
  """
  def valid_field?({"byr", year}), do: String.to_integer(year) in 1920..2002
  def valid_field?({"iyr", year}), do: String.to_integer(year) in 2010..2020
  def valid_field?({"eyr", year}), do: String.to_integer(year) in 2020..2030

  def valid_field?({"hgt", height}) do
    {n, unit} = Integer.parse(height)

    case unit do
      "cm" -> n in 150..193
      "in" -> n in 59..76
      _ -> false
    end
  end

  def valid_field?({"hcl", colour}), do: Regex.match?(~r/^\#[0-9a-f]{6}$/, colour)
  def valid_field?({"ecl", colour}), do: colour in ~w(amb blu brn gry grn hzl oth)
  def valid_field?({"pid", pid}), do: Regex.match?(~r/^[0-9]{9}$/, pid)
end
