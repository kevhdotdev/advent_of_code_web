defmodule Aoc.Y2020.Day17 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one(".#.\n..#\n###\n")
      112
  """
  @impl true
  def part_one(input) do
    for {r, y} <- Enum.with_index(parse(input)) do
      for {c, x} <- Enum.with_index(r) do
        {{x, y, 0}, c}
      end
    end
    |> List.flatten()
    |> Map.new()
    |> cycle(6)
    |> Enum.count(fn {_, c} -> c == "#" end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> String.split(l, "", trim: true) end)
  end

  defp cycle(map, 0), do: map

  defp cycle(map, count) do
    [xr, yr, zr] = ranges(map)

    for x <- xr, y <- yr, z <- zr do
      active =
        for x1 <- [x - 1, x, x + 1] do
          for y1 <- [y - 1, y, y + 1] do
            for z1 <- [z - 1, z, z + 1], !(x == x1 && y == y1 && z == z1) do
              map[{x1, y1, z1}]
            end
          end
        end
        |> List.flatten()
        |> Enum.count(fn c1 -> c1 == "#" end)

      {{x, y, z},
       case {Map.get(map, {x, y, z}, "."), active} do
         {"#", 2} -> "#"
         {"#", 3} -> "#"
         {".", 3} -> "#"
         _ -> "."
       end}
    end
    |> Map.new()
    |> cycle(count - 1)
  end

  defp ranges(map) do
    for i <- 0..2 do
      for({c, _} <- map, do: elem(c, i))
      |> Enum.min_max()
    end
    |> Enum.map(fn {l, h} -> (l - 1)..(h + 1) end)
  end

  @doc ~S"""
  ## Examples
      iex> part_two(".#.\n..#\n###\n")
      848
  """
  @impl true
  def part_two(input) do
    for {r, y} <- Enum.with_index(parse(input)) do
      for {c, x} <- Enum.with_index(r) do
        {{x, y, 0, 0}, c}
      end
    end
    |> List.flatten()
    |> Map.new()
    |> cycle4d(6)
    |> Enum.count(fn {_, c} -> c == "#" end)
  end

  defp cycle4d(map, 0), do: map

  defp cycle4d(map, count) do
    [xr, yr, zr, wr] = ranges4d(map)

    for x <- xr, y <- yr, z <- zr, w <- wr do
      active =
        for x1 <- [x - 1, x, x + 1] do
          for y1 <- [y - 1, y, y + 1] do
            for z1 <- [z - 1, z, z + 1] do
              for w1 <- [w - 1, w, w + 1], !(x == x1 && y == y1 && z == z1 && w == w1) do
                map[{x1, y1, z1, w1}]
              end
            end
          end
        end
        |> List.flatten()
        |> Enum.count(fn c1 -> c1 == "#" end)

      {{x, y, z, w},
       case {Map.get(map, {x, y, z, w}, "."), active} do
         {"#", 2} -> "#"
         {"#", 3} -> "#"
         {".", 3} -> "#"
         _ -> "."
       end}
    end
    |> Map.new()
    |> cycle4d(count - 1)
  end

  defp ranges4d(map) do
    for i <- 0..3 do
      for({c, _} <- map, do: elem(c, i))
      |> Enum.min_max()
    end
    |> Enum.map(fn {l, h} -> (l - 1)..(h + 1) end)
  end
end
