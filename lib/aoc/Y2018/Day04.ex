defmodule Aoc.Y2018.Day04 do
  def part_one(input) do
    cal = build_cal(input)

    most_asleep =
      cal
      |> Enum.filter(fn x -> elem(x, 3) == :asleep end)
      |> Enum.group_by(fn x -> elem(x, 2) end)
      |> Enum.map(fn {id, logs} -> {id, Enum.count(logs)} end)
      |> Enum.sort_by(fn x -> -elem(x, 1) end)
      |> List.first()
      |> elem(0)

    best_minute =
      cal
      |> Enum.filter(fn x -> elem(x, 3) == :asleep && elem(x, 2) == most_asleep end)
      |> Enum.group_by(fn x -> elem(x, 1) end)
      |> Enum.map(fn {id, logs} -> {id, Enum.count(logs)} end)
      |> Enum.sort_by(fn x -> -elem(x, 1) end)
      |> List.first()
      |> elem(0)

    best_minute * most_asleep
  end

  def part_two(input) do
    cal =
      build_cal(input)
      |> Enum.filter(fn x -> elem(x, 3) == :asleep end)

    best =
      for m <- 0..59, into: %{} do
        {
          m,
          Enum.filter(cal, fn x -> elem(x, 1) == m end) |> Enum.dedup()
        }
      end
      |> Enum.map(fn {day, v} ->
        {day,
         Enum.group_by(v, fn x -> elem(x, 2) end)
         |> Enum.map(fn {id, v} -> {{day, id}, Enum.count(v)} end)}
      end)
      |> Enum.map(fn x -> elem(x, 1) end)
      |> List.flatten()
      |> Enum.sort_by(fn x -> -elem(x, 1) end)
      |> List.first()
      |> elem(0)

    elem(best, 0) * elem(best, 1)
  end

  def build_cal(input) do
    log =
      input
      |> String.trim_trailing("\n")
      |> String.split("\n")
      |> Enum.sort()
      |> parse_log(nil)

    days =
      log
      |> Enum.map(fn l ->
        {day, _, _, _} = l
        day
      end)

    cal =
      for day <- days do
        for min <- 0..59, do: {day, min, nil, nil}
      end
      |> List.flatten()

    add_to_cal(cal, log, nil, nil)
  end

  def add_to_cal([], _, _, _), do: []

  def add_to_cal([{date, min, _, _} | t], log, guard, state) do
    nl =
      Enum.find(log, fn l ->
        case l do
          {^date, ^min, nil, nil} -> {date, min, guard, state}
          {^date, ^min, guard, state} -> {date, min, guard, state}
          _ -> false
        end
      end) || {date, min, guard, state}

    {_, _, guard, state} = nl
    [nl | add_to_cal(t, log, guard, state)]
  end

  def parse_log([], _), do: []

  def parse_log([line | t], guard) do
    log = {_, _, guard, _} = parse_log(line, guard)
    [log | parse_log(t, guard)]
  end

  def parse_log(
        "[1518-" <>
          <<date::bytes-size(5)>> <>
          " " <> <<_hour::bytes-size(2)>> <> ":" <> <<min::bytes-size(2)>> <> "] Guard #" <> guard,
        _
      ) do
    [{guard, _}, {min, _}] = [guard, min] |> Enum.map(fn x -> Integer.parse(x) end)
    {date, min, guard, :awake}
  end

  def parse_log(
        "[1518-" <>
          <<date::bytes-size(5)>> <>
          " " <> <<_hour::bytes-size(2)>> <> ":" <> <<min::bytes-size(2)>> <> "] falls asleep",
        guard
      ) do
    {min, _} = Integer.parse(min)
    {date, min, guard, :asleep}
  end

  def parse_log(
        "[1518-" <>
          <<date::bytes-size(5)>> <>
          " " <> <<_hour::bytes-size(2)>> <> ":" <> <<min::bytes-size(2)>> <> "] wakes up",
        guard
      ) do
    {min, _} = Integer.parse(min)
    {date, min, guard, :awake}
  end
end
