defmodule Aoc.Y2020.Day03 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples

      iex> map = "..##.......\n#...#...#..\n.#....#..#.\n..#.#...#.#\n.#...##..#.\n..#.##.....\n.#.#.#....#\n.#........#\n#.##...#...\n#...##....#\n.#..#...#.#"
      iex> part_one(map)
      7
  """
  @impl true
  def part_one(input) do
    input |> parse_map() |> trees_in_path(3, 1, 0, 0)
  end

  defp parse_map(input) do
    input
    |> String.split()
    |> Enum.map(fn l -> String.split(l, "", trim: true) end)
  end

  defp trees_in_path([], _, _, _, trees), do: trees

  defp trees_in_path([line | map], shift, yshift, x, trees) do
    trees_in_path(
      Enum.drop(map, yshift - 1),
      shift,
      yshift,
      x + shift,
      if(tree_at(line, x), do: trees + 1, else: trees)
    )
  end

  defp tree_at(line, x) do
    Enum.at(line, rem(x, length(line))) == "#"
  end

  @doc ~S"""
  ## Examples

      iex> map = "..##.......\n#...#...#..\n.#....#..#.\n..#.#...#.#\n.#...##..#.\n..#.##.....\n.#.#.#....#\n.#........#\n#.##...#...\n#...##....#\n.#..#...#.#"
      iex> part_two(map)
      336
  """
  @impl true
  def part_two(input) do
    map = parse_map(input)

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {x, y} -> trees_in_path(map, x, y, 0, 0) end)
    |> Enum.reduce(&*/2)
  end
end
