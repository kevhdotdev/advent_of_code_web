defmodule Aoc.Y2018.Day07 do
  def part_one(input) do
    input
    |> dep_map
    |> process([])
  end

  def part_two(input, workers \\ 6, time_offset \\ 60) do
    dep_map =
      input
      |> dep_map

    last =
      dep_map
      |> Map.values()
      |> List.flatten()
      |> Enum.sort()
      |> Enum.dedup()

    <<last::utf8>> = List.first(steps(dep_map) -- last)

    time =
      dep_map
      |> timed_process([], 0, workers, time_offset)

    time + last - 64 + time_offset
  end

  def timed_process(deps, [], seconds, _, _) when map_size(deps) == 0, do: seconds

  def timed_process(deps, current_steps, seconds, workers, offset) do
    new_steps =
      Enum.map(next_steps(deps, workers - length(current_steps)), fn s ->
        <<x::utf8>> = s
        {x - 64 + offset, s}
      end)

    new_steps =
      new_steps
      |> Enum.reject(fn {_, s} -> s in Enum.map(current_steps, fn c -> elem(c, 1) end) end)

    current_steps =
      (current_steps ++ new_steps)
      |> Enum.map(fn {t, s} -> {t - 1, s} end)

    finished_steps = current_steps |> Enum.filter(fn s -> elem(s, 0) == 0 end)

    timed_process(
      remove_dep(deps, finished_steps),
      current_steps -- finished_steps,
      seconds + 1,
      workers,
      offset
    )
  end

  def process(deps, steps) when map_size(deps) == 1 do
    left =
      deps
      |> Map.values()
      |> Enum.sort()

    (Map.keys(deps) ++ left ++ steps)
    |> List.flatten()
    |> Enum.reverse()
    |> Enum.join()
  end

  def process(deps, steps) do
    step = next_step(deps)
    process(remove_dep(deps, step), [step | steps])
  end

  def remove_dep(deps, []), do: deps

  def remove_dep(deps, [h | t]) do
    deps |> remove_dep(h) |> remove_dep(t)
  end

  def remove_dep(deps, {_, step}), do: remove_dep(deps, step)

  def remove_dep(deps, step) do
    for({k, v} <- deps, do: {k, Enum.reject(v, fn x -> x == step end)})
    |> Enum.reject(fn {_, d} -> d == [] end)
    |> Map.new()
  end

  def steps(dep_map) do
    dep_map
    |> Map.values()
    |> Enum.concat(Map.keys(dep_map))
    |> List.flatten()
    |> Enum.sort()
    |> Enum.dedup()
  end

  def next_steps(dep_map, limit \\ 1) do
    steps(dep_map)
    |> Enum.filter(fn s -> s not in Map.keys(dep_map) end)
    |> Enum.sort()
    |> Enum.take(limit)
  end

  def next_step(dep_map) do
    dep_map
    |> next_steps
    |> List.first()
  end

  def dep_map(input), do: dep_map(String.split(input, "\n"), %{})
  defp dep_map([""], deps), do: deps
  defp dep_map([], deps), do: deps

  defp dep_map([h | t], deps) do
    "Step " <>
      <<dep::bytes-size(1)>> <>
      " must be finished before step " <> <<x::bytes-size(1)>> <> " can begin." = h

    deps =
      case deps[x] do
        nil -> Map.put(deps, x, [dep])
        _ -> %{deps | x => [dep | deps[x]]}
      end

    dep_map(t, deps)
  end
end
