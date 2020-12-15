defmodule Aoc.Y2020.Day14 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one("mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X\nmem[8] = 11\nmem[7] = 101\nmem[8] = 0")
      165
  """
  @impl true
  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> String.split(l, " = ") end)
    |> process("", %{})
    |> Map.values()
    |> Enum.sum()
  end

  defp process([], _, mem), do: mem

  defp process([["mask", new_mask] | t], _, mem), do: process(t, new_mask, mem)

  defp process([[addr, v] | t], mask, mem) do
    addr = String.slice(addr, 4..-2)
    v = v |> String.to_integer() |> bin |> mask(mask) |> String.to_integer(2)
    process(t, mask, Map.put(mem, addr, v))
  end

  @doc ~S"""
  Converts to 36 bit binary

  ## Examples
      iex> bin(11)
      "000000000000000000000000000000001011"

      iex> bin(101)
      "000000000000000000000000000001100101"
  """
  def bin(n), do: n |> Integer.to_string(2) |> String.pad_leading(36, "0")

  @doc ~S"""
  Passes a 36 bit bin number through a 36 bin bin mask

  ## Examples
      iex> mask("000000000000000000000000000000001011", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
      "000000000000000000000000000001001001"

      iex> mask("000000000000000000000000000001100101", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
      "000000000000000000000000000001100101"
  """
  def mask(n, mask) do
    n = String.graphemes(n)
    mask = String.graphemes(mask)
    n |> Enum.zip(mask) |> Enum.map(fn {n, m} -> if m == "X", do: n, else: m end) |> Enum.join()
  end

  @doc ~S"""
  ## Examples
      iex> part_two("\nmask = 000000000000000000000000000000X1001X\nmem[42] = 100\nmask = 00000000000000000000000000000000X0XX\nmem[26] = 1\n")
      208
  """
  @impl true
  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> String.split(l, " = ") end)
    |> process2("", %{})
    |> Map.values()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp process2([], _, mem), do: mem

  defp process2([["mask", new_mask] | t], _, mem), do: process2(t, new_mask, mem)

  defp process2([[addr, v] | t], mask, mem) do
    addr = addr |> String.slice(4..-2) |> String.to_integer()
    new = for a <- decode(addr, mask), do: {a, v}
    process2(t, mask, Map.merge(mem, Map.new(new)))
  end

  @doc ~S"""
  Converts an address and a mask to all possible addresses

  ## Examples
      iex> decode(42, "000000000000000000000000000000X1001X") |> Enum.sort
      [26, 27, 58, 59]
  """
  def decode(addr, mask) do
    mask = String.graphemes(mask)
    addr = bin(addr) |> String.graphemes()

    addr =
      Enum.zip(addr, mask)
      |> Enum.map(fn {a, m} -> if m == "0", do: a, else: m end)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()

    xs =
      addr
      |> Enum.filter(fn {_, v} -> v == "X" end)
      |> Enum.map(fn {k, _} -> k end)

    l = length(xs)

    for x <- 0..(trunc(:math.pow(2, l)) - 1) do
      nn =
        x
        |> Integer.to_string(2)
        |> String.pad_leading(l, "0")
        |> String.split("", trim: true)

      nnn =
        xs
        |> Enum.zip(nn)
        |> Map.new()

      Map.merge(addr, nnn)
      |> Enum.map(fn {k, v} -> {k, v} end)
      |> Enum.sort_by(fn {k, _} -> -k end)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.join()
      |> String.to_integer(2)
    end
  end
end
