defmodule Aoc.Y2018.Day09 do
  def part_one(input) do
    [players, _, _, _, _, _, last, _] =
      input
      |> String.split()

    players = List.duplicate(0, String.to_integer(players)) |> List.to_tuple()

    play([0], 1, 0, players, String.to_integer(last))
  end

  def part_two(input) do
    [players, _, _, _, _, _, last, _] =
      input
      |> String.split()

    players = List.duplicate(0, String.to_integer(players)) |> List.to_tuple()

    play([0], 1, 0, players, String.to_integer(last) * 100)
  end

  def play(circle, round, current, players, last) do
    player = rem(round, tuple_size(players))

    cond do
      round == last ->
        players |> Tuple.to_list() |> Enum.max()

      rem(round, 23) == 0 ->
        players = put_elem(players, player, elem(players, player) + round)

        new_index =
          rem(
            Enum.find_index(circle, fn x -> current == x end) + length(circle) - 7,
            length(circle)
          )

        players = put_elem(players, player, elem(players, player) + Enum.at(circle, new_index))
        {left, [_ | right]} = Enum.split(circle, new_index)
        circle = left ++ right
        play(circle, round + 1, List.first(right), players, last)

      true ->
        new_index =
          rem(
            Enum.find_index(circle, fn x -> current == x end) + 2,
            length(circle)
          )

        {left, right} = Enum.split(circle, new_index)
        new_circle = left ++ [round] ++ right
        play(new_circle, round + 1, round, players, last)
    end
  end
end
