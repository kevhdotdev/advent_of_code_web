defmodule Aoc.Y2015.Day04 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one("abcdef")
      609043

      iex> part_one("pqrstuv")
      1048970
  """
  @impl true
  def part_one(input) do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.find(fn x ->
      "#{input}#{x}" |> :erlang.md5() |> Base.encode16() |> String.slice(0, 5) == "00000"
    end)
  end

  @impl true
  def part_two(input) do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.find(fn x ->
      "#{input}#{x}" |> :erlang.md5() |> Base.encode16() |> String.slice(0, 6) ==
        "000000"
    end)
  end
end
