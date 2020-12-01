defmodule Aoc.DocTest do
  use ExUnit.Case, async: true

  for year <- [2020], day <- 1..25 do
    doctest :"Elixir.Aoc.Y#{year}.Day#{Aoc.Input.padded_number(day)}"
  end
end
