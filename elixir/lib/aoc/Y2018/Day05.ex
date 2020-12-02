defmodule Aoc.Y2018.Day05 do
  def part_one(input) do
    String.length(chunk_and_process(input, 60))
  end

  def part_two(input) do
    alphabet = for l <- ?a..?z, do: <<l::utf8>>

    for l <- alphabet do
      IO.write(l)

      fixed_input =
        input
        |> String.replace(l, "")
        |> String.replace(String.upcase(l), "")

      String.length(chunk_and_process(chunk_and_process(fixed_input, 100), 100))
    end
    |> Enum.min()
  end

  def chunk_and_process(string, chunk) do
    tasks =
      string
      |> String.graphemes()
      |> Enum.chunk_every(chunk)
      |> Enum.map(fn letters ->
        letters = Enum.join(letters)
        Task.async(fn -> smash(letters) end)
      end)

    processed =
      Enum.map(tasks, fn task -> Task.await(task) end)
      |> Enum.join()

    case chunk do
      2 ->
        string

      _ ->
        case processed do
          ^string -> chunk_and_process(processed, chunk - 1)
          _ -> chunk_and_process(processed, chunk)
        end
    end
  end

  def smash(""), do: ""

  def smash(string) do
    smashed = smash_once(string)

    case smashed do
      ^string -> string
      _ -> smash(smashed)
    end
  end

  def two_letter_match(a, b) do
    (String.match?(a, ~r/[a-z]/) && b == String.upcase(a)) ||
      (String.match?(a, ~r/[A-Z]/) && b == String.downcase(a))
  end

  def smash_once(string), do: smash_once(string, 0)

  def smash_once(string, x) do
    case string |> String.slice(x, 2) |> String.graphemes() do
      [] ->
        string

      [_] ->
        string

      [a, b] ->
        cond do
          two_letter_match(a, b) ->
            {left, mid} = String.split_at(string, x)
            {_, right} = String.split_at(mid, 2)
            smash_once(Enum.join([left, right]), x + 1)

          x < String.length(string) - 2 ->
            smash_once(string, x + 1)

          true ->
            string
        end
    end
  end
end
