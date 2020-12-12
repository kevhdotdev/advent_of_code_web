defmodule Aoc.Y2020.Day12 do
  @behaviour Aoc.Day

  @doc ~S"""
  ## Examples
      iex> part_one("F10\nN3\nF7\nR90\nF11\n")
      25
  """
  @impl true
  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> run
  end

  defp run(list), do: run(list, "E", 0, 0)

  defp run([], _, x, y), do: abs(x) + abs(y)

  defp run([h | t], dir, x, y) do
    {l, n} = String.split_at(h, 1)
    n = String.to_integer(n)
    {x, y, dir} = run({l, n}, dir, x, y)
    run(t, dir, x, y)
  end

  defp run({l, n}, dir, x, y) do
    case {l, n} do
      {"R", n} -> {x, y, rot(dir, n)}
      {"L", n} -> {x, y, rot(dir, 360 - n)}
      {"N", n} -> {x, y + n, dir}
      {"E", n} -> {x + n, y, dir}
      {"S", n} -> {x, y - n, dir}
      {"W", n} -> {x - n, y, dir}
      {"F", n} -> run({dir, n}, dir, x, y)
    end
  end

  @doc ~S"""
  ## Examples
      iex> rot("E", 90)
      "S"
      iex> rot("S", 180)
      "N"
      iex> rot("W", 270)
      "S"
  """
  def rot("E", 90), do: "S"
  def rot("S", 90), do: "W"
  def rot("W", 90), do: "N"
  def rot("N", 90), do: "E"
  def rot(d, n), do: rot(d, 90) |> rot(n - 90)

  @doc ~S"""
  ## Examples
      iex> part_two("F10\nN3\nF7\nR90\nF11\n")
      286
  """
  @impl true
  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> run2
  end

  defp run2(list), do: run2(list, "E", 0, 0, 10, 1)

  defp run2([], _, x, y, _, _), do: abs(x) + abs(y)

  defp run2([h | t], dir, x, y, wx, wy) do
    {l, n} = String.split_at(h, 1)
    n = String.to_integer(n)
    {x, y, {wx, wy}, dir} = run2({l, n}, dir, x, y, wx, wy)
    run2(t, dir, x, y, wx, wy)
  end

  defp run2({l, n}, dir, x, y, wx, wy) do
    case {l, n} do
      {"R", n} -> {x, y, wrot({wx, wy}, n), dir}
      {"L", n} -> {x, y, wrot({wx, wy}, 360 - n), dir}
      {"N", n} -> {x, y, {wx, wy + n}, dir}
      {"E", n} -> {x, y, {wx + n, wy}, dir}
      {"S", n} -> {x, y, {wx, wy - n}, dir}
      {"W", n} -> {x, y, {wx - n, wy}, dir}
      {"F", n} -> {x + wx * n, y + wy * n, {wx, wy}, dir}
    end
  end

  defp wrot({x, y}, 90), do: {y, -1 * x}
  defp wrot(d, n), do: wrot(d, 90) |> wrot(n - 90)
end
