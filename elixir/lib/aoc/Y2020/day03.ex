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
    map =
      input
      |> String.split()
      |> Enum.map(fn l -> String.split(l, "", trim: true) end)

    trees_in_path(map, 3)
  end

  defp trees_in_path(map, shift), do: trees_in_path(map, shift, 0, 0)

  defp trees_in_path([], _, _, trees), do: trees

  defp trees_in_path([line | map], shift, x, trees) do
    trees_in_path(
      map,
      shift,
      x + shift,
      if(tree_at(line, x), do: trees + 1, else: trees)
    )
  end

  defp tree_at(line, x) do
    Enum.at(line, rem(x, length(line))) == "#"
  end

  @impl true
  def part_two(_input) do
  end
end
