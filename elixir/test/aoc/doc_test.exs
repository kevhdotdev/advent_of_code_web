defmodule Aoc.DocTest do
  use ExUnit.Case, async: true

  for year <- [2015, 2020], day <- 1..25 do
    try do
      doctest :"Elixir.Aoc.Y#{year}.Day#{Aoc.Input.padded_number(day)}", import: true
    rescue
      e in UndefinedFunctionError -> e
    end
  end
end
