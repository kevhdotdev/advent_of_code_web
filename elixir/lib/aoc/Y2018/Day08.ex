defmodule Aoc.Y2018.Day08 do
  def part_one(input) do
    input
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> build_node
    |> sum_meta
  end

  def index_sum({[], meta}) do
    Enum.sum(meta)
  end

  def index_sum({children, meta}) do
    index_sums = Enum.map(children, &index_sum/1)

    sums =
      for index <- meta,
          sum = Enum.at(index_sums, index - 1),
          do: sum

    Enum.sum(sums)
  end

  def sum_meta([h | l]) do
    sum_meta(h) + sum_meta(l)
  end

  def sum_meta([]), do: 0

  def sum_meta({a, b}) do
    Enum.sum(b) + sum_meta(a)
  end

  def build_node([children_count, metadata_count | tail]) do
    {children, tail} = children(children_count, tail, [])
    {meta, tail} = Enum.split(tail, metadata_count)
    {{children, meta}, tail}
  end

  def children(0, tail, acc) do
    {Enum.reverse(acc), tail}
  end

  def children(count, tail, acc) do
    {node, tail} = build_node(tail)
    children(count - 1, tail, [node | acc])
  end

  def part_two(input) do
    {root, _} =
      input
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> build_node

    root |> index_sum
  end
end
