defmodule Aoc.Y2018.Day11 do
  def part_one(input) do
    serial = String.to_integer(input)
    grid = build_grid(serial)
    squares = for y <- 1..298, x <- 1..298, do: {x, y, square_power(grid, x, y, 3)}
    {x, y, _} = Enum.max_by(squares, &elem(&1, 2))
    "#{x},#{y}"
  end

  def power_level(x, y, serial) do
    (
      rackID = x + 10

      ((y * rackID + serial) * rackID)
      |> Integer.to_string()
      |> String.slice(-3, 1)
      |> String.to_integer()
    ) - 5
  end

  def square_coords(x, y) do
    for y <- y..(y + 2), x <- x..(x + 2), do: {x, y}
  end

  def square_power(grid, x, y, size) do
    grid
    |> Enum.slice(y - 1, size)
    |> Enum.map(fn row -> Enum.slice(row, x - 1, size) end)
    |> List.flatten()
    |> Enum.sum()
  end

  def build_grid(serial) do
    for y <- 1..300, do: for(x <- 1..300, do: power_level(x, y, serial))
  end

  def part_two(input) do
    serial = String.to_integer(input)
    grid = build_grid(serial)

    tasks =
      for size <- 1..300 do
        Task.async(fn ->
          squares =
            for y <- 1..(301 - size),
                x <- 1..(301 - size),
                do: {x, y, size, square_power(grid, x, y, size)}

          Enum.max_by(squares, &elem(&1, 3))
        end)
      end

    squares = Enum.map(tasks, fn task -> Task.await(task, :infinity) end)

    {x, y, size, _} = Enum.max_by(squares, &elem(&1, 3))
    "#{x},#{y},#{size}"
  end
end
