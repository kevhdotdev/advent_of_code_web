defmodule Aoc.Y2018.Day13 do
  def part_one(input) do
    carts = input |> build_map |> get_carts
    blank_map = input |> build_map(true)

    try do
      step(blank_map, carts, [], true)
    catch
      {x, y} -> "#{x}, #{y}"
    end
  end

  def part_two(input) do
    carts = input |> build_map |> get_carts
    blank_map = input |> build_map(true)

    try do
      step(blank_map, carts, [], false)
    catch
      {x, y} -> "#{x}, #{y}"
    end
  end

  def get_carts(map) do
    for y <- 0..(tuple_size(map) - 1),
        x <- 0..(tuple_size(elem(map, 0)) - 1),
        String.contains?("<>^v", map |> elem(y) |> elem(x)) do
      {x, y, map |> elem(y) |> elem(x), :left}
    end
  end

  def print_map(map, carts) do
    for y <- 0..(tuple_size(map) - 1),
        x <- 0..(tuple_size(elem(map, 0)) - 1) do
      cart = for({^x, ^y, cart, _} <- carts, do: cart) |> List.first()
      IO.write(if cart, do: cart, else: map |> elem(y) |> elem(x))
      if x == tuple_size(elem(map, 0)) - 1, do: IO.puts("")
    end

    IO.puts("")
  end

  def step(map, [], carts, die_on_crash) do
    carts = carts |> Enum.sort_by(fn {x, y, _, _} -> {y, x} end)
    step(map, carts, [], die_on_crash)
  end

  def step(map, [cart | tail], new_carts, die_on_crash) do
    if length(new_carts) + length(tail) == 0, do: throw({elem(cart, 0), elem(cart, 1)})
    {_, _, d, t} = cart

    {x, y} =
      case cart do
        {x, y, "^", _} -> {x, y - 1}
        {x, y, "v", _} -> {x, y + 1}
        {x, y, "<", _} -> {x - 1, y}
        {x, y, ">", _} -> {x + 1, y}
      end

    crashed = for({^x, ^y, d, t} <- tail ++ new_carts, do: {x, y, d, t}) |> List.first()
    if !!crashed and die_on_crash, do: throw({x, y})

    {d, t} =
      case({d, t, map |> elem(y) |> elem(x)}) do
        {_, t, "|"} -> {d, t}
        {_, t, "-"} -> {d, t}
        {"^", t, "\\"} -> {"<", t}
        {"^", t, "/"} -> {">", t}
        {"<", t, "\\"} -> {"^", t}
        {"<", t, "/"} -> {"v", t}
        {">", t, "\\"} -> {"v", t}
        {">", t, "/"} -> {"^", t}
        {"v", t, "/"} -> {"<", t}
        {"v", t, "\\"} -> {">", t}
        {d, t, "+"} -> junction(d, t)
      end

    new_carts =
      case crashed do
        nil -> [{x, y, d, t} | new_carts]
        crashed -> new_carts -- [crashed]
      end

    step(map, tail -- [crashed], new_carts, die_on_crash)
  end

  def junction(current_direction, next_turn) do
    case next_turn do
      :straight ->
        {current_direction, :right}

      :left ->
        case current_direction do
          "<" -> {"v", :straight}
          "v" -> {">", :straight}
          ">" -> {"^", :straight}
          "^" -> {"<", :straight}
        end

      :right ->
        case current_direction do
          "<" -> {"^", :left}
          "v" -> {"<", :left}
          ">" -> {"v", :left}
          "^" -> {">", :left}
        end
    end
  end

  def build_map(input, blank \\ false) do
    input
    |> String.trim_trailing("\n")
    |> String.split("\n")
    |> Enum.map(fn line ->
      line =
        line
        |> String.split("")
        |> Enum.reject(fn x -> x == "" end)

      line =
        if blank do
          for char <- line do
            case char do
              "<" -> "-"
              ">" -> "-"
              "^" -> "|"
              "v" -> "|"
              x -> x
            end
          end
        else
          line
        end

      line = line |> List.to_tuple()
    end)
    |> List.to_tuple()
  end
end
