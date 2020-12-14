defmodule Aoc.Y2020.Day13 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one("939\n7,13,x,x,59,x,31,19\n")
      295
  """
  @impl true
  def part_one(input) do
    [time | ids] = parse(input)

    {id, _, wait} =
      ids
      |> Enum.map(fn id -> earliest(id, time) end)
      |> Enum.sort_by(fn {_, time, _} -> time end)
      |> List.first()

    id * wait
  end

  defp parse(input) do
    input
    |> String.split(~r/[\n\,]/, trim: true)
    |> Enum.filter(fn id -> id != "x" end)
    |> Enum.map(&String.to_integer/1)
  end

  defp earliest(id, ready) do
    time = trunc(ready / id) * id + id
    {id, time, time - ready}
  end

  @impl true
  def part_two(input) do
  end
end
