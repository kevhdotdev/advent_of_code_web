defmodule AOC.Y2019.Day01Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    assert 2 == AOC.Y2019.Day01.part_one(12)
    assert 2 == AOC.Y2019.Day01.part_one(14)
    assert 654 == AOC.Y2019.Day01.part_one(1969)
    assert 33583 == AOC.Y2019.Day01.part_one(100_756)
  end
end
