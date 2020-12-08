defmodule Aoc.Y2020.Day08 do
  @behaviour Aoc.Day
  alias Aoc.Y2020.Processor

  @doc ~S"""
  ## Examples
      iex> part_one("nop +0\nacc +1\njmp +4\nacc +3\njmp -3\nacc -99\nacc +1\njmp -4\nacc +6\n")
      5
  """
  @impl true
  def part_one(input) do
    try do
      process(%Processor{}, String.split(input, "\n", trim: true), MapSet.new())
    catch
      {:loop, ans} -> ans
    end
  end

  @doc ~S"""
  Processes one instruction
  ## Examples
      iex> {%Aoc.Y2020.Processor{acc: 0, pointer: 1}, addrs} = process(%Aoc.Y2020.Processor{}, "nop +0", MapSet.new)
      iex> addrs
      #MapSet<[0]>

  ## Examples
      iex> {%Aoc.Y2020.Processor{acc: 0, pointer: 5}, addrs} = process(%Aoc.Y2020.Processor{pointer: 15}, "jmp -10", MapSet.new)
      iex> addrs
      #MapSet<[15]>

  ## Examples
      iex> {%Aoc.Y2020.Processor{acc: 4, pointer: 1}, addrs} = process(%Aoc.Y2020.Processor{acc: 1}, "acc +3", MapSet.new)
      iex> addrs
      #MapSet<[0]>
  """
  def process(processor, program, addrs) when is_list(program) do
    case process(processor, Enum.at(program, processor.pointer), addrs) do
      {processor, addrs} -> process(processor, program, addrs)
      ans -> throw({:end, ans})
    end
  end

  def process(%{acc: acc}, nil, _), do: acc
  def process(processor, "nop " <> _, addrs), do: inc(processor, addrs)
  def process(processor, "jmp " <> arg, addrs), do: inc(processor, addrs, String.to_integer(arg))

  def process(processor, "acc " <> arg, addrs) do
    {processor, addrs} = inc(processor, addrs)
    {%{processor | acc: processor.acc + String.to_integer(arg)}, addrs}
  end

  defp inc(processor, addrs, offset \\ 1) do
    addr = processor.pointer + offset
    if (processor.pointer + offset) in addrs, do: throw({:loop, processor.acc})
    {%{processor | pointer: addr}, MapSet.put(addrs, processor.pointer)}
  end

  @doc ~S"""
  ## Examples
      iex> part_two("nop +0\nacc +1\njmp +4\nacc +3\njmp -3\nacc -99\nacc +1\njmp -4\nacc +6\n")
      8
  """

  @impl true
  def part_two(input) do
    program = String.split(input, "\n", trim: true)

    try do
      for {line, i} <- Enum.with_index(program), fn line -> String.slice(line, 0, 3) != "acc" end do
        p = List.update_at(program, i, &flip/1)

        try do
          process(%Processor{}, p, MapSet.new())
        catch
          {:loop, _} -> nil
        end
      end
    catch
      {:end, ans} -> ans
    end
  end

  defp flip("nop " <> arg), do: "jmp #{arg}"
  defp flip("jmp " <> arg), do: "nop #{arg}"
  defp flip(line), do: line
end
