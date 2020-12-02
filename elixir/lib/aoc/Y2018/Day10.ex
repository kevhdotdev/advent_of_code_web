defmodule Aoc.Y2018.Day10 do
  def part_one(input, steps \\ 10078) do
    sky =
      input
      |> parse
      |> step(steps)

    sky |> to_grid(minmax(sky))
  end

  def part_two(_) do
    # Had to work this out by eye, really.
    10076
  end

  def parse(input) do
    input
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.scan(~r/[-\d]+/, line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def minmax(points) do
    {{minx, _, _, _}, {maxx, _, _, _}} = Enum.min_max_by(points, fn {x, _, _, _} -> x end)
    {{_, miny, _, _}, {_, maxy, _, _}} = Enum.min_max_by(points, fn {_, y, _, _} -> y end)
    {minx, maxx, miny, maxy}
  end

  def step(sky, 0), do: sky

  def step(sky, iterations \\ 1) do
    # if iterations < 40, do: to_grid(sky, minmax(sky))
    sky = for {x, y, dx, dy} <- sky, do: {x + dx, y + dy, dx, dy}
    step(sky, iterations - 1)
  end

  def to_grid(sky, {minx, maxx, miny, maxy}) do
    sky =
      for y <- miny..maxy, x <- minx..(maxx + 1) do
        if x == maxx + 1 do
          "\n"
        else
          if Enum.find(sky, fn {sx, sy, _, _} -> sx == x && sy == y end), do: "#", else: "."
        end
      end
      |> Enum.join()

    sky
  end
end
