defmodule Aoc.Y2020.Day11 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one("L.LL.LL.LL\nLLLLLLL.LL\nL.L.L..L..\nLLLL.LL.LL\nL.LL.LL.LL\nL.LLLLL.LL\n..L.L.....\nLLLLLLLLLL\nL.LLLLLL.L\nL.LLLLL.LL\n")
      37
  """
  @impl true
  def part_one(input) do
    input |> build_map |> detect_no_change(nil, 1) |> Enum.count(fn {_, s} -> s == "#" end)
  end

  @doc ~S"""
  ## Examples
      iex> part_two("L.LL.LL.LL\nLLLLLLL.LL\nL.L.L..L..\nLLLL.LL.LL\nL.LL.LL.LL\nL.LLLLL.LL\n..L.L.....\nLLLLLLLLLL\nL.LLLLLL.L\nL.LLLLL.LL\n")
      26
  """
  @impl true
  def part_two(input) do
    input
    |> build_map
    |> detect_no_change(nil, 2)
    |> Enum.count(fn {_, s} -> s == "#" end)
  end

  defp build_map(input) do
    for {line, y} <- input |> String.split("\n", trim: true) |> Enum.with_index() do
      for {seat, x} <- line |> String.split("", trim: true) |> Enum.with_index() do
        {{x, y}, seat}
      end
    end
    |> List.flatten()
    |> Map.new()
  end

  defp detect_no_change(map, map, _), do: map
  defp detect_no_change(map, _, part), do: map |> process(part) |> detect_no_change(map, part)

  defp fill({coords, ".", _}), do: {coords, "."}
  defp fill({coords, "L", 0}), do: {coords, "#"}
  defp fill({coords, "L", _}), do: {coords, "L"}
  defp fill({coords, "#", n}) when n >= 5, do: {coords, "L"}
  defp fill({coords, "#", _}), do: {coords, "#"}

  defp process(map, part) do
    map
    |> Enum.map(fn x -> process(map, x, part) end)
    |> Enum.map(&fill/1)
    |> Map.new()
  end

  defp process(map, {{x, y}, s}, 1) do
    {{x, y}, s,
     for x1 <- [x - 1, x, x + 1],
         y1 <- [y - 1, y, y + 1] do
       if map[{x1, y1}] == "#", do: 1, else: 0
     end
     |> Enum.sum()}
  end

  defp process(map, {coords, s}, 2) do
    {coords, s,
     for dir <- [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}] do
       filled?(map, coords, dir)
     end
     |> Enum.sum()}
  end

  defp filled?(map, {x, y}, {dx, dy}) do
    {x1, y1} = {x + dx, y + dy}

    case map[{x1, y1}] do
      "#" -> 1
      "." -> filled?(map, {x1, y1}, {dx, dy})
      _ -> 0
    end
  end
end
